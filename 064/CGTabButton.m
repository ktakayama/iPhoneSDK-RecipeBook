// 「レシピ064:CoreGraphicsでTabViewのようなボタンを作る」のサンプルコード (P.147)

@interface CGTabButton : UIControl
{
    UILabel *_label;
    UIImage *_image;
}
-(void)setTitle:(NSString *)title;
-(void)setImage:(UIImage *)image;
@end
@implementation CGTabButton
-(void)setTitle:(NSString *)title{
    _label.text = title;
}
-(void)setImage:(UIImage *)image {
    [_image release];
    _image = image;
    [_image retain];
}

//override
-(id)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor blackColor]];
        _label = [[UILabel alloc]initWithFrame:CGRectMake(0,
            frame.size.height-14, frame.size.width, 14)];
        [_label retain];
        _label.textAlignment = UITextAlignmentCenter;
        _label.font = [UIFont boldSystemFontOfSize:10];
        _label.enabled = NO;
        _label.opaque = YES;
        _label.backgroundColor = [UIColor clearColor];
        _label.textColor = [UIColor whiteColor];
        [self addSubview:_label];
    }
    return self;
}

//override
-(void)setHighlighted:(BOOL)value {
    [super setHighlighted:value];
    _label.enabled = value;
    [self setNeedsDisplay];
}
//override
-(void)setSelected:(BOOL)value {
    [super setSelected:value];
    _label.enabled = value;
    [self setNeedsDisplay];
}
//override
-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [_label setFrame:CGRectMake(0, frame.size.height-14, frame.size.width,
        14)];
    return;
}

// rectに内接する角丸矩形のパスを生成する。radius:角丸の半径
- (void) addRoundRect:(CGContextRef )context rect:(CGRect)rc
               radius:(CGFloat)rd{
    CGContextMoveToPoint( context, CGRectGetMinX(rc), CGRectGetMaxY(rc)-rd);
    CGContextAddArcToPoint( context, CGRectGetMinX(rc), CGRectGetMinY(rc),
        CGRectGetMidX(rc), CGRectGetMinY(rc), rd );
    CGContextAddArcToPoint( context, CGRectGetMaxX(rc), CGRectGetMinY(rc),
        CGRectGetMaxX(rc), CGRectGetMidY(rc), rd );
    CGContextAddArcToPoint( context, CGRectGetMaxX(rc), CGRectGetMaxY(rc),
        CGRectGetMidX(rc), CGRectGetMaxY(rc), rd );
    CGContextAddArcToPoint( context, CGRectGetMinX(rc), CGRectGetMaxY(rc),
        CGRectGetMinX(rc), CGRectGetMidY(rc), rd );
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;

    //下部の黒
    CGContextSetFillColorWithColor(context,[self backgroundColor].CGColor);
    CGContextFillRect(context,CGRectMake(0,height/2,width,height/2));

    //最上部のライン
    CGContextSetFillColorWithColor(context,[UIColor colorWithWhite:1
        alpha:0.263].CGColor);
    CGContextFillRect(context,CGRectMake(0,1,width,1));

    // CGGradientを生成する
    // 生成するためにCGColorSpaceと色データの配列が必要になるので
    // 適当に用意する
    size_t num_locations = 2;
    CGFloat locations[2] = { 0.0, 1.0 };
    CGFloat components[8] = { 1, 1, 1, 0.18, 1, 1, 1, 0.083 };
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace,
        components, locations, num_locations);
    CGPoint startPoint = CGPointMake(width/2, 2.0);
    CGPoint endPoint = CGPointMake(width/2, height/2);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGGradientRelease( gradient );
    CGColorSpaceRelease( colorSpace );

    if ((self.state && UIControlStateSelected)||
        (self.state && UIControlStateHighlighted)) {
        //ハイライト
        CGContextSetFillColorWithColor(context,
            [UIColor colorWithWhite:1 alpha:0.14].CGColor);
        CGContextSetStrokeColorWithColor(context,
            [UIColor colorWithWhite:1 alpha:1.0].CGColor);
        CGFloat radius = 3;//角丸の半径
        CGRect hRect = CGRectMake(2, 3, width-4, height-5);
        [self addRoundRect:context rect:hRect radius:radius];
        CGContextFillPath(context);
        CGContextStrokePath(context);
    }

    CGContextSetBlendMode(context, kCGBlendModeNormal);

    // アイコンを描画
    CGFloat imageWidth = CGImageGetWidth(_image.CGImage);
    CGFloat imageHeight = CGImageGetHeight(_image.CGImage);
    CGRect iconRect = CGRectMake(width/2-imageWidth/2,
                                 (height-14)/2-imageHeight/2,
                                 imageWidth,
                                 imageHeight);

    [_image drawInRect:iconRect];

    if ((self.state && UIControlStateSelected)||
        (self.state && UIControlStateHighlighted)) {
    }else{
        //グレーにする
        CGContextSetBlendMode (context, kCGBlendModeDarken);
        CGContextSetFillColorWithColor(context,[UIColor grayColor].CGColor);
        CGContextFillRect(context,iconRect);
        CGContextSetBlendMode (context, kCGBlendModeSaturation);
        CGContextSetFillColorWithColor(context,[UIColor whiteColor].CGColor);
        CGContextFillRect(context,iconRect);
    }
}
- (void)dealloc {
    [super dealloc];
    [_label dealloc];
    [_image dealloc];
}
@end
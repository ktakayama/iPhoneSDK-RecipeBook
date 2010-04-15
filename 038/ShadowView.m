// 「レシピ038:UIButtonに影をつける」のサンプルコード (P.78)

#import <QuartzCore/QuartzCore.h>

@interface ShadowLayer:CALayer {
    UIView *contentView;
}
-(void)setContentView:(UIView*)view;
@end
@implementation ShadowLayer
- (void)drawInContext:(CGContextRef)context {
    if (contentView) {
        // 親レイヤーを描画する
        UIGraphicsBeginImageContext(contentView.frame.size);
        [contentView.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        CGContextSetShadow(context, CGSizeMake(2,-6), 5);
        CGContextTranslateCTM(context, 0, contentView.frame.size.height);
        CGContextScaleCTM(context, 1, -1);
        CGContextDrawImage(context, contentView.frame, [image CGImage]);
    }
}

-(void)setContentView:(UIView*)view {
    [contentView release];
    contentView = view;
    [contentView retain];
    self.frame = CGRectMake(0,0,view.bounds.size.width+10,
                            view.bounds.size.height+10);
    self.needsDisplayOnBoundsChange = YES;
    self.opaque = NO;
}
-(void)dealloc {
    [contentView release];
    [super dealloc];
}
@end

@interface ShadowView:UIView {
    UIView *mainChildView;
    ShadowLayer *shadowLayer;
}
@end
@implementation ShadowView
-(id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.opaque = NO;

        //影を描画するためのレイヤーを作成
        shadowLayer = [ShadowLayer layer];
        [self.layer addSublayer:shadowLayer];
    }
    return self;
}
-(void)setFrame:(CGRect)frame {
    super.frame = frame;
    if (mainChildView) {
        mainChildView.frame=self.bounds;
    }
    shadowLayer.frame = CGRectMake(0,0,self.bounds.size.width+10,
                                   self.bounds.size.height+10);
}

-(void)setChild:(UIView *)view {
    if (mainChildView) {
        [mainChildView removeFromSuperview];
        [mainChildView release];
    }
    mainChildView = view;
    [mainChildView retain];
    [self addSubview:mainChildView];
    [shadowLayer setContentView:mainChildView];
}
@end
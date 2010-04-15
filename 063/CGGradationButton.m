// 「レシピ063:CoreGraphicsでグラデーション付きのボタンを作る」のサンプルコード (P.143)

#import <UIKit/UIKit.h>
@interface CGGradationButton : UIButton
{
}
@end
@implementation CGGradationButton

//override
-(id)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        self.titleLabel.font = [UIFont boldSystemFontOfSize: 18];
        self.titleLabel.shadowOffset = CGSizeMake (0.0, 1.0);
        [self setTitleColor:[UIColor colorWithRed:0.49 green:0.49 blue:0.49
            alpha:1] forState:UIControlStateNormal];
        [self setTitleShadowColor:[UIColor whiteColor]
            forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor]
            forState:(UIControlStateSelected&&UIControlStateHighlighted)];
        [self setTitleShadowColor:[UIColor clearColor]
            forState:(UIControlStateSelected&&UIControlStateHighlighted)];
    }
    return self;
}
//override
-(void)setHighlighted:(BOOL)value {
    [super setHighlighted:value];
    [self setNeedsDisplay];
}
//override
-(void)setSelected:(BOOL)value {
    [super setSelected:value];
    [self setNeedsDisplay];
}
- (void) addRoundRect:(CGContextRef )context rect:(CGRect)rc
    radius:(CGFloat)radius{

    CGContextMoveToPoint( context, CGRectGetMinX(rc),
                         CGRectGetMaxY(rc)-radius);
    CGContextAddArcToPoint( context, CGRectGetMinX(rc), CGRectGetMinY(rc),
                           CGRectGetMidX(rc), CGRectGetMinY(rc), radius );
    CGContextAddArcToPoint( context, CGRectGetMaxX(rc), CGRectGetMinY(rc),
                           CGRectGetMaxX(rc), CGRectGetMidY(rc), radius );
    CGContextAddArcToPoint( context, CGRectGetMaxX(rc), CGRectGetMaxY(rc),
                           CGRectGetMidX(rc), CGRectGetMaxY(rc), radius );
    CGContextAddArcToPoint( context, CGRectGetMinX(rc), CGRectGetMaxY(rc),
                           CGRectGetMinX(rc), CGRectGetMidY(rc), radius );
}
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat w = self.bounds.size.width;
    CGFloat h = self.bounds.size.height;
    CGFloat r = 12;//角丸の半径

    CGContextSaveGState(context);

    // 縁の下部にあるハイライトを描画
    CGContextSetLineWidth(context, 1);
    CGContextSetShouldAntialias(context,true);
    CGContextSetRGBStrokeColor(context, 1, 1, 1, 0.6);
    [self addRoundRect:context rect:CGRectMake(0, 0, w, h-1) radius:r];
    CGContextDrawPath(context, kCGPathStroke);

    if ((self.state && UIControlStateSelected)||
        (self.state && UIControlStateHighlighted)) {
        // 押下時のボタン描画

        // グラデーション描画領域を決める
        [self addRoundRect:context rect:CGRectMake(0, 0, w, h-1) radius:r];
        CGContextClip(context);
        // グラデーションを描画
        size_t num_locations = 2; //グラデーションのポイントの数
        CGFloat locations[2] =
            { 0.0,  //グラデーションのポイント１の位置
              1.0 };//グラデーションのポイント２の位置
        CGFloat components[8] =
            { 0.18, 0.40, 0.78, 1.0,  //グラデーションのポイント１の色
              0.40, 0.65, 1.00, 1.0}; //グラデーションのポイント２の色
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGGradientRef gradient = CGGradientCreateWithColorComponents(
            colorSpace, components, locations, num_locations);
        CGPoint startPoint = CGPointMake(w/2, 0.0);
        CGPoint endPoint = CGPointMake(w/2, h-2.0);
        CGContextDrawLinearGradient(context,
            gradient, startPoint, endPoint, 0);

        // 内側の影を描画
        CGContextSetRGBStrokeColor(context, 0.08,0.3,0.6,1);
        CGContextSetShadowWithColor(context,CGSizeMake(0, -1), 3,
            [UIColor colorWithRed:0 green:0 blue:0 alpha:1].CGColor);
        [self addRoundRect:context rect:CGRectMake(0, -1, w+1, h) radius:r];
        CGContextDrawPath(context, kCGPathStroke);

        // クリップ領域をクリア
        CGContextRestoreGState(context);
        CGContextSaveGState(context);

        // 押下部分にある薄い照り返しを描画
        CGContextSetRGBFillColor(context, 1, 1, 1, 0.07);
        [self addRoundRect:context
            rect:CGRectMake(1, h/2, w-2, h/2-1) radius:r-3];
        CGContextFillPath(context);

        // 縁の描画情報を指定（下部分は描かない）
        CGContextClipToRect(context,CGRectMake(0,0,w,h-r));
        CGContextSetRGBStrokeColor(context,0.02, 0.21, 0.5, 0.6);
    }else {
        // 標準のボタン描画

        // グラデーション描画領域を決める
        [self addRoundRect:context rect:CGRectMake(0, 0, w, h-1) radius:r];
        CGContextClip(context);

        // グラデーションを描画
        size_t num_locations = 2; //グラデーションのポイントの数
        CGFloat locations[2] =
        { 0.0,  //グラデーションのポイント１の位置
          1.0 };//グラデーションのポイント２の位置
        CGFloat components[8] =
        { 1.0,  1.0,  1.0,  1.0,  //グラデーションのポイント１の色
          0.78, 0.78, 0.78, 1.0}; //グラデーションのポイント２の色
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGGradientRef gradient = CGGradientCreateWithColorComponents(
            colorSpace, components, locations, num_locations);
        CGPoint startPoint = CGPointMake(w/2, 0.0);
        CGPoint endPoint = CGPointMake(w/2, h-2.0);
        CGContextDrawLinearGradient(context,
            gradient, startPoint, endPoint, 0);

        // クリップ領域をクリア
        CGContextRestoreGState(context);
        CGContextSaveGState(context);

        // 縁の描画情報を指定
        CGContextSetRGBStrokeColor(context, 0.5, 0.5, 0.5, 0.8);
    }
    // 縁を描画
    CGContextSetLineWidth(context, 1);
    CGContextSetShouldAntialias(context,true);
    [self addRoundRect:context rect:CGRectMake(0, 0, w, h-2) radius:r];
    CGContextDrawPath(context, kCGPathStroke);

    // クリップ領域をクリア
    CGContextRestoreGState(context);
}
@end

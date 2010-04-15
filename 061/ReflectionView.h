// 「レシピ061: UIImageViewに反射エフェクトを付ける」のサンプルコード (P.138)

#import "ReflectionView.h"

@implementation ReflectionView

@synthesize image;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor blackColor];
        // 上下反転させる
        self.transform = CGAffineTransformMakeTranslation(0.0, 0.0);
        self.transform = CGAffineTransformScale(self.transform, 1.0, -1.0);
    }
    return self;
}

- (void) setImage:(UIImage*)img {
    // set image
    CGImageRef imageRef = [img CGImage];
    image = [[UIImage imageWithCGImage:imageRef] retain];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    // CGContextを用意する
    CGContextRef context = UIGraphicsGetCurrentContext();

    // CGGradientを生成する
    size_t num_locations = 2;
    CGFloat locations[2] = { 0.0, 1.0 };
    CGFloat components[8] = { 0.0, 0.0, 0.0, 1.0,   // 開始色
                              0.5, 0.5, 0.5, 1.0 }; // 終点色
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(
                        colorSpace, components, locations, num_locations);
    // グラデーションを描画
    CGPoint startPoint = CGPointMake(0.0f, self.frame.size.height/2);
    CGPoint endPoint = CGPointMake(0.0f, self.frame.size.height);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);

    // 後始末
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);

    // 反射させるUIImageを描画
    [image drawInRect:rect blendMode:kCGBlendModeMultiply alpha:50.0f];

}

- (void)dealloc {
    [image release];
    [super dealloc];
}

@end
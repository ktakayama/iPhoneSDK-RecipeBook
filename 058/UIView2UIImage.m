// 「レシピ058: UIViewの内容をUIImageに変換する」のサンプルコード (P.135)

#import <QuartzCore/CALayer.h>

- (UIImage *) screenImage:(UIView *)view {
    UIImage *screenImage;

    UIGraphicsBeginImageContext(view.frame.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    screenImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenImage;
}

- (UIImage *) screenImage:(UIView *)view rect:(CGRect)rect {
    CGPoint pt = rect.origin;
    UIImage *screenImage;

    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextConcatCTM(context,
            CGAffineTransformMakeTranslation(-(int)pt.x, -(int)pt.y));
    [view.layer renderInContext:context];
    screenImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenImage;
}


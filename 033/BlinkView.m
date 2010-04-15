// 「レシピ033:緩やかに点滅し続けるViewを作る」のサンプルコード (P.71)

#import <UIKit/UIKit.h>
@interface BlinkView : UIView {
}
@end
@implementation BlinkView
-(void)endAnimation{
    [self setAlpha:0.0];
    [NSTimer scheduledTimerWithTimeInterval:0.0
                                     target:self
                                   selector:@selector(startAmination)
                                   userInfo:nil
                                    repeats:NO];
}

-(void)startAmination {
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.5]; //アニメーションの実行間隔
    [UIView setAnimationRepeatAutoreverses:YES];
    [UIView setAnimationRepeatCount:10]; //アニメーションの実行回数
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(endAnimation)];
    [self setAlpha:1.0];
    [UIView commitAnimations];
}

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.opaque = NO;
        self.userInteractionEnabled = NO;
        [self setAlpha:0.0];
        [self startAmination];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
    CGContextFillRect(context, rect);
}
@end

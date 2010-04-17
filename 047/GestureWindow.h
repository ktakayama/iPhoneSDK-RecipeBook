// 「レシピ047: UIWebViewをフィンガージェスチャーで操作する」のサンプルコード (P.103)

#import "GestureWindow.h"

@implementation GestureWindow

@synthesize wView, delegate;

-(void) dealloc {
    [wView release];
    [super dealloc];
}

- (void)sendEvent:(UIEvent *)event {
    [super sendEvent:event];
    if (wView == nil || delegate == nil) {
        return;
    }
    // 2本指でのマルチタッチか
    NSSet *touches = [event allTouches];
    if (touches.count != 2) {
        return;
    }

    UITouch *touch = touches.anyObject;
    // 指定のUIWebViewへのタッチか
    if ([touch.view isDescendantOfView:wView] == NO) {
        return;
    }

    switch (touch.phase) {
        case UITouchPhaseBegan:
            if ([self.delegate
                 respondsToSelector:@selector(touchesBeganWeb:withEvent:)]) {
                [self.delegate
                    performSelector:@selector(touchesBeganWeb:withEvent:)
                    withObject:touches withObject:event];
            }
            break;
        case UITouchPhaseMoved:
            if ([self.delegate
                 respondsToSelector:@selector(touchesMovedWeb:withEvent:)]) {
                [self.delegate
                    performSelector:@selector(touchesMovedWeb:withEvent:)
                    withObject:touches withObject:event];
            }
            break;
        case UITouchPhaseEnded:
            if ([self.delegate
                 respondsToSelector:@selector(touchesEndedWeb:withEvent:)]) {
                [self.delegate
                    performSelector:@selector(touchesEndedWeb:withEvent:)
                    withObject:touches withObject:event];
            }
        default:
            return;
            break;
    }
}

@end
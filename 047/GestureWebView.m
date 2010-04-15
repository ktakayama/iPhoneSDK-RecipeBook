// 「レシピ047: UIWebViewをフィンガージェスチャーで操作する」のサンプルコード (P.103)

#import <objc/runtime.h>

@implementation UIView (__TapHook)

- (void)__touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
    [self __touchesBegan:touches withEvent:event];
    id webView = [[self superview] superview];
    if ([webView respondsToSelector:@selector(beganWithTouches:event:)]) {
        [webView beganWithTouches:touches event:event];
    }
}

- (void)__touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
    [self __touchesMoved:touches withEvent:event];

    id webView = [[self superview] superview];
    if ([webView respondsToSelector:@selector(movedWithTouches:event:)]) {
        [webView movedWithTouches:touches event:event];
    }
}

- (void)__touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
    [self __touchesEnded:touches withEvent:event];

    id webView = [[self superview] superview];
    if ([webView respondsToSelector:@selector(endedWithTouches:event:)]) {
        [webView endedWithTouches:touches event:event];
    }
}

@end

@implementation GestureWebView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        Class _class = objc_getClass("UIWebDocumentView");
        Method targetMethod = class_getInstanceMethod(_class,
                                  @selector(touchesEnded:withEvent:));
        Method newMethod = class_getInstanceMethod(_class,
                                  @selector(__touchesEnded:withEvent:));
        method_exchangeImplementations(targetMethod, newMethod);

        Method targetMethod2 = class_getInstanceMethod(_class,
                                  @selector(touchesBegan:withEvent:));
        Method newMethod2 = class_getInstanceMethod(_class,
                                  @selector(__touchesBegan:withEvent:));
        method_exchangeImplementations(targetMethod2, newMethod2);

        targetMethod = class_getInstanceMethod(_class,
                                  @selector(touchesMoved:withEvent:));
        newMethod = class_getInstanceMethod(_class,
                                  @selector(__touchesMoved:withEvent:));
        method_exchangeImplementations(targetMethod, newMethod);
    }
    return self;
}

- (void)beganWithTouches:(NSSet*)touches event:(UIEvent*)event {
    [(NSObject*)self.delegate webView:self
           zoomingBeganWithTouches:touches event:event];
}

- (void)movedWithTouches:(NSSet*)touches event:(UIEvent*)event {
    [(NSObject*)self.delegate webView:self
           zoomingMovedWithTouches:touches event:event];
}

- (void)endedWithTouches:(NSSet*)touches event:(UIEvent*)event {
    [(NSObject*)self.delegate webView:self
           zoomingEndedWithTouches:touches event:event];
}

@end
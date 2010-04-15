// 「レシピ047: UIWebViewをフィンガージェスチャーで操作する」のサンプルコード (P.103)

@interface NSObject (UIWebViewTappingDelegate)
- (void)webView:(UIWebView*)sender
    zoomingBeganWithTouches:(NSSet*)touches event:(UIEvent*)event;
- (void)webView:(UIWebView*)sender
    zoomingMovedWithTouches:(NSSet*)touches event:(UIEvent*)event;
- (void)webView:(UIWebView*)sender
    zoomingEndedWithTouches:(NSSet*)touches event:(UIEvent*)event;
@end

@interface GestureWebView : UIWebView {

}
- (void)beganWithTouches:(NSSet*)touches event:(UIEvent*)event;
- (void)movedWithTouches:(NSSet*)touches event:(UIEvent*)event;
- (void)endedWithTouches:(NSSet*)touches event:(UIEvent*)event;
@end


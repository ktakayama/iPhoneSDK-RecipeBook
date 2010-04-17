// 「レシピ047: UIWebViewをフィンガージェスチャーで操作する」のサンプルコード (P.103)

@protocol GestureWindowDelegate

- (void) touchesBeganWeb:(NSSet *)touches withEvent:(UIEvent *)event;
- (void) touchesMovedWeb:(NSSet *)touches withEvent:(UIEvent *)event;
- (void) touchesEndedWeb:(NSSet *)touches withEvent:(UIEvent *)event;

@end

@interface GestureWindow : UIWindow {
    UIWebView* wView;
    id delegate;
}

@property (nonatomic, retain) UIWebView* wView;
@property (nonatomic, assign) id delegate;

@end
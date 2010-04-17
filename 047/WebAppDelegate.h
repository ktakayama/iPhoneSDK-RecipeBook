// 「レシピ047: UIWebViewをフィンガージェスチャーで操作する」のサンプルコード (P.103)

@interface WebAppDelegate : NSObject <UIApplicationDelegate> {
    GestureWindow *window;
    WebViewController *viewController;
}

@property (nonatomic, retain) IBOutlet GestureWindow *window;
@property (nonatomic, retain) IBOutlet WebViewController *viewController;

@end
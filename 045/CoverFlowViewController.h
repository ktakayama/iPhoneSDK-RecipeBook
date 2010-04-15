// 「レシピ045: UIWebViewでカバーフローを作る」のサンプルコード (P.96)

@interface CoverFlowViewController : UIViewController <UIWebViewDelegate, UISearchBarDelegate> {
    IBOutlet UIWebView* webView;
    NSString* keyword;
}

@end
// 「レシピ045: UIWebViewでカバーフローを作る」のサンプルコード (P.96)

#import "CoverFlowViewController.h"

@implementation CoverFlowViewController

// 検索キーワードを取得して、HTMLを読み込む
- (void) searchBarSearchButtonClicked: (UISearchBar *) searchBar {
    [searchBar resignFirstResponder];
    // 検索キーワード
    keyword = searchBar.text;
    // HTMLを読み込む
    NSString* path =
       [[NSBundle mainBundle] pathForResource:@"zflow" ofType:@"html"];
    NSURL* url=[NSURL fileURLWithPath:path];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
}

// HTMLのロードが終わったらキーワードをJavaScriptに渡して検索を開始する
- (void)webViewDidFinishLoad:(UIWebView *)web {
    NSString* js =
       [NSString stringWithFormat:@"var q='%@';startLoading();", keyword];
    [web stringByEvaluatingJavaScriptFromString:js];
}

// 横表示に対応するようにする
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)
  interfaceOrientation {
    return YES;
}

- (void)dealloc {
    [super dealloc];
}

@end
// 「レシピ051: UITableCellViewにクリッカブルリンクを入れる」のサンプルコード (P.119)

@interface LinkableViewCell : UITableViewCell {
    UIWebView* webView;
}

@property (nonatomic, retain) UIWebView* webView;

@end
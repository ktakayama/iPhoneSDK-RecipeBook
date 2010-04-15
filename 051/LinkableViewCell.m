// 「レシピ051: UITableCellViewにクリッカブルリンクを入れる」のサンプルコード (P.119)

#import "LinkableViewCell.h"

@implementation LinkableViewCell

@synthesize webView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        // UIWebViewを追加する
        CGRect frame = self.contentView.bounds;
        frame = CGRectInset(frame, 10, 1);
        webView = [[UIWebView alloc] initWithFrame:frame];
        [self.contentView addSubview:webView];
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
    [webView release];
}

@end
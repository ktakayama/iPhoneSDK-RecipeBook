// 「レシピ044: アラート内にUIWebViewを表示する」のサンプルコード (P.92)

#import "AlertWebView.h"

@implementation AlertWebView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        webView = [[UIWebView alloc] initWithFrame:CGRectZero];
        [self addSubview:webView];
        [webView release];
    }
    return self;
}

- (void)setFrame:(CGRect)rect {
    [super setFrame:CGRectMake(0, 0, rect.size.width, 460)];
    self.center = CGPointMake(160, 255);
}

- (void)layoutSubviews {
    CGFloat labelHeight;
    CGFloat buttonTop;
    CGFloat margin = 5.0f;
    CGFloat button_x = 0.0f;
    CGFloat button_w = 0.0f;

    for (UIView *view in self.subviews) {
        if ([[[view class] description] isEqualToString:@"UILabel"]) {
            labelHeight = view.frame.origin.y + view.frame.size.height;
        } else if ([[[view class] description]
                          isEqualToString:@"UIThreePartButton"]) {
            view.frame = CGRectMake(view.frame.origin.x,
                         self.bounds.size.height - view.frame.size.height - 15,
                         view.frame.size.width,
                         view.frame.size.height);
            buttonTop = view.frame.origin.y;
            if (button_x <= 0.0f) {
                button_x = view.frame.origin.x;
            }
            button_w = view.frame.origin.x+view.frame.size.width;
        }
    }
    // UIWebViewの位置と大きさをラベル、ボタンの位置により調整する
    webView.frame = CGRectMake(button_x, labelHeight, button_w-button_x,
                                                buttonTop-labelHeight-margin);

    [webView loadRequest:
     [NSURLRequest requestWithURL:
       [NSURL URLWithString:@"http://www.google.com/"]]];
}

@end
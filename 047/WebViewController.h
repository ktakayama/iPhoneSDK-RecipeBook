// 「レシピ047: UIWebViewをフィンガージェスチャーで操作する」のサンプルコード (P.103)

#define GESTURE_LENGTH  50
#define BLUR_LENGTH     50
#define PINCH_DELTA     100

#import "GestureWindow.h"
#import "GestureView.h"

@interface WebViewController : UIViewController <GestureWindowDelegate> {
    UIWebView* webView;
    GestureView* gestureView;
    NSMutableArray* touchPoints;
    CGFloat initDistance;
}

@end
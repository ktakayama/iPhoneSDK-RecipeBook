// 「レシピ047: UIWebViewをフィンガージェスチャーで操作する」のサンプルコード (P.103)

#define GESTURE_LENGTH  50
#define BLUR_LENGTH     50
#define PINCH_DELTA     100

@interface WebGestureViewController : UIViewController <UIWebViewDelegate> {
    GestureWebView* webView;
    GestureView* gestureView;
    NSMutableArray* touchPoints;
    CGFloat initDistance;
}
@end
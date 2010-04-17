// 「レシピ047: UIWebViewをフィンガージェスチャーで操作する」のサンプルコード (P.103)

#import "WebViewController.h"

@implementation WebViewController

// 2点間の距離を計算
CGFloat distanceBetweenPoints (CGPoint first, CGPoint second) {
    CGFloat deltaX = second.x - first.x;
    CGFloat deltaY = second.y - first.y;
    return sqrt(deltaX*deltaX + deltaY*deltaY );
};

- (void) touchesBeganWeb:(NSSet *)touches withEvent:(UIEvent *)event {
    initDistance = 0;
    NSArray *twoTouches = [touches allObjects];
    UITouch *first = [twoTouches objectAtIndex:0];
    UITouch *second = [twoTouches objectAtIndex:1];
    initDistance = distanceBetweenPoints([first locationInView:self.view],
                                           [second locationInView:self.view]);
}

- (void) touchesMovedWeb:(NSSet *)touches withEvent:(UIEvent *)event {
    NSArray *twoTouches = [touches allObjects];
    UITouch *first = [twoTouches objectAtIndex:0];
    UITouch *second = [twoTouches objectAtIndex:1];
    CGFloat currentDistance =
       distanceBetweenPoints([first locationInView:self.view],
                             [second locationInView:self.view]);
    if (initDistance == 0) {
        initDistance = currentDistance;
    }

    // ピンチ動作かチェック
    if (fabs(currentDistance - initDistance) > PINCH_DELTA) {
        [touchPoints removeAllObjects];
        [gestureView drawGestureLine:touchPoints];
        return;
    }

    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    [touchPoints addObject:[NSValue valueWithCGPoint:point]];

    [gestureView drawGestureLine:touchPoints];
}

- (void) touchesEndedWeb:(NSSet *)touches withEvent:(UIEvent *)event {
    if (touchPoints.count<=0) {
        return;
    }

    CGPoint point1 = [[touchPoints objectAtIndex:0] CGPointValue];
    CGPoint point2 =
       [[touchPoints objectAtIndex:[touchPoints count]-1] CGPointValue];

    CGFloat deltaX = point2.x - point1.x;
    CGFloat deltaY = point2.y - point1.y;
    if (fabsf(deltaX) >= GESTURE_LENGTH && fabsf(deltaY) <= BLUR_LENGTH) {
        if (deltaX < 0) {
            // 戻る
            [webView goBack];
        } else {
            // 進む
            [webView goForward];
        }
    } else if (fabsf(deltaY) >= GESTURE_LENGTH &&
               fabsf(deltaX) <= BLUR_LENGTH) {
        // 上下方向にマルチタッチスワイプ
    }
    [touchPoints removeAllObjects];
    [gestureView setNeedsDisplay];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    initDistance = 0;
    touchPoints = [[NSMutableArray alloc] init];

    // UIWebView
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0 ,0 , 320, 450)];
    webView.userInteractionEnabled = YES;
    webView.scalesPageToFit = YES;
    [self.view addSubview:webView];
    [webView release];

    // ジェスチャーの軌跡を描画するビュー
    gestureView =
       [[GestureView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    gestureView.userInteractionEnabled = NO;
    gestureView.opaque = NO;
    [self.view addSubview:gestureView];
    [gestureView release];

    // タッチイベントをフックするUIWindow
    GestureWindow* tapWindow;
    tapWindow = (GestureWindow*)[[UIApplication sharedApplication].windows
                                                           objectAtIndex:0];
    tapWindow.wView = webView;
    tapWindow.delegate = self;

    // URL をロードする
    [webView loadRequest:[NSURLRequest
       requestWithURL:[NSURL URLWithString:@"http://example.com/"]]];
}

- (void)dealloc {
    [touchPoints release];
    [super dealloc];
}

@end
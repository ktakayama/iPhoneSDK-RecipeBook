// 「レシピ077: ムービプレイヤの上に別レイヤを表示する」のサンプルコード (P.186)

#import "PlayMovieViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@implementation PlayMovieViewController

@synthesize overlayView;

- (void) addOverlayView {
    NSArray *windows = [[UIApplication sharedApplication] windows];
    // ムービプレイヤが起動していればウィンドウの数が2
    // ムービプレイヤの起動を確認してオーバレイ表示させる
    if ([windows count] > 1) {
        // ムービプレイヤのウィンドウ
        UIWindow *moviePlayerWindow;
        moviePlayerWindow = [[UIApplication sharedApplication] keyWindow];
        // ムービプレイヤの上にオーバレイ表示させる
        [moviePlayerWindow addSubview:self.overlayView];
    }
}

// 動画のプレロード終了
- (void) finishPreload:(NSNotificationCenter *) aNotification {
    MPMoviePlayerController *player = [aNotification object];
    [[NSNotificationCenter defaultCenter]
        removeObserver:self
        name:MPMoviePlayerContentPreloadDidFinishNotification
        object:player];
    [player play];

    // ムービプレイヤの上にViewを表示する
    [self addOverlayView];
}
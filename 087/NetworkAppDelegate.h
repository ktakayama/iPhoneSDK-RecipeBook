// 「レシピ087: ネットワークの接続状況を判定する」のサンプルコード (P.208)

#import <UIKit/UIKit.h>
#import "Reachability.h"

@interface NetworkAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    Reachability* wifiReach;
}

@end
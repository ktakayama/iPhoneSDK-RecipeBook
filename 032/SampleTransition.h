// 「レシピ032: Transition Animationを途中で止める」のサンプルコード (P.70)

# import <QuartzCore/QuartzCore.h>

@interface SampleTransitionAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    UIView *v;
    BOOL mode;
}


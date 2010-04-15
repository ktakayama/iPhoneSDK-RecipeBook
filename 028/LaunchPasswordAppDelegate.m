// 「レシピ028: 起動パスワードを付ける」のサンプルコード (P.62)

#import <UIKit/UIKit.h>
#import "PasswordCheckViewController.h"

@interface LaunchPasswordAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    PasswordCheckViewController *checker;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

- (void) launchInputForm;

@end

#import "LaunchPasswordAppDelegate.h"

@implementation LaunchPasswordAppDelegate

@synthesize window;

- (void) applicationDidFinishLaunching:(UIApplication *)application {
    [window makeKeyAndVisible];

    // アプリケーションから離れる場合のNotification
    [[NSNotificationCenter defaultCenter] addObserver:self
            selector:@selector(launchInputForm)
            name:UIApplicationWillResignActiveNotification
            object:application];
    checker = [[PasswordCheckViewController alloc] init];
    [self launchInputForm];
}

- (void) launchInputForm {
    [window addSubview:checker.view];
}

- (void) dealloc {
    [checker release];
    [window release];
    [super dealloc];
}

@end


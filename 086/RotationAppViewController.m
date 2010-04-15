// 「レシピ086: デバイスの回転を検知して別コントローラを表示させる」のサンプルコード (P.204)

#import "RotationAppViewController.h"

@implementation RotationAppViewController

- (void) viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor blueColor];
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(10,10,200,20)];
    lb.text = @"ポートレイト";
    [self.view addSubview:lb];
    [lb release];

    landscapeView = [[LandscapeViewController alloc] init];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:
                (UIInterfaceOrientation)interfaceOrientation {
    if(interfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
        interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        [self presentModalViewController:landscapeView animated:NO];
    }
    return YES;
}

- (void)dealloc {
    [landscapeView release];
    [super dealloc];
}
@end


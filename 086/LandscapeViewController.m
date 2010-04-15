// 「レシピ086: デバイスの回転を検知して別コントローラを表示させる」のサンプルコード (P.205)

#import "LandscapeViewController.h"

@implementation LandscapeViewController

- (void) viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor redColor];
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(10,10,200,20)];
    lb.text = @"ランドスケープ";
    [self.view addSubview:lb];
    [lb release];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:
            (UIInterfaceOrientation)interfaceOrientation {
    if(interfaceOrientation == UIInterfaceOrientationPortrait ||
        interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        [self dismissModalViewControllerAnimated:NO];
    }
    return YES;
}

- (void) dealloc {
    [super dealloc];
}

@end


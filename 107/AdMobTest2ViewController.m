// 「レシピ0107: AdMobの広告を組み込む」のサンプルコード (P.287)

#import "AdMobTest2ViewController.h"

@implementation AdMobTest2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AdMobView* ad = [AdMobView requestAdWithDelegate:self];
    // 上部に広告を表示する
    ad.frame = CGRectMake(0, 0, 320, 48);
    [self.view addSubview:ad];
}

- (NSString *)publisherId {
    return @"ここにpublisher idを入れる";
}

- (void)dealloc {
    [super dealloc];
}

@end
// 「レシピ061: UIImageViewに反射エフェクトを付ける」のサンプルコード (P.138)

#import "RootViewController.h"

@implementation ReflectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(50.0f, 90.0f, 200.0f, 150.0f)];
    [imageView setImage:[UIImage imageNamed:@"test.png"]];
    [self.view addSubview:imageView];

    refView = [[ReflectionView alloc] initWithFrame:CGRectMake(50.0f, 240.0f, 200.0f, 150.0f)];
    [refView setImage:imageView.image];
    [self.view addSubview:refView];
}


- (void)dealloc {
    [super dealloc];
}
@end
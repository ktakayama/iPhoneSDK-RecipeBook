// 「レシピ086: デバイスの回転を検知して別コントローラを表示させる」のサンプルコード (P.204)

#import <UIKit/UIKit.h>
#import "LandscapeViewController.h"

@interface RotationAppViewController : UIViewController {
    LandscapeViewController *landscapeView;
}
@end


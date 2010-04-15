// 「レシピ046: フィンガージェスチャーを認識する」のサンプルコード (P.98)

#import "Gesture.h"

#define DISTANCE 50
#define BLUR 5
#define STOP 2

@interface FingerGestureViewController : UIViewController {
    NSMutableArray* gestures;
    CGPoint startPoint;
    CGPoint endPoint;
}

@end
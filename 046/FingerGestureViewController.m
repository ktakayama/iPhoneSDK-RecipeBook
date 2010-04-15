// 「レシピ046: フィンガージェスチャーを認識する」のサンプルコード (P.98)

#import "FingerGestureViewController.h"

@implementation FingerGestureViewController

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    startPoint = [touch locationInView:self.view];
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    endPoint = [touch locationInView:self.view];

    CGFloat moveX = startPoint.x - endPoint.x;
    CGFloat moveY = startPoint.y - endPoint.y;
    GestureType gestureType;
    if (fabs(moveX) > DISTANCE && fabs(moveY) < BLUR) {
        // 横方向へのジェスチャー
        if (moveX > 0) {
            gestureType = gLeft;
        } else {
            gestureType = gRight;
        }
    } else if (fabs(moveY) > DISTANCE && fabs(moveX) < BLUR) {
        // 縦方向へのジェスチャー
        if (moveY > 0) {
            gestureType = gUp;
        } else {
            gestureType = gDown;
        }
    }

    // 移動停止、許容範囲のチェック
    CGPoint prevPoint = [touch previousLocationInView:self.view];
    CGFloat deltaX = prevPoint.x - endPoint.x;
    CGFloat deltaY = prevPoint.y - endPoint.y;
    CGFloat delta = sqrt(deltaX*deltaX + deltaY*deltaY);
    if (delta < STOP || (fabs(moveX) > BLUR && fabs(moveY) > BLUR))  {
        startPoint = endPoint;
    }

    if (!gestureType) {
        return;
    }
    if (gestures.count==0 ||
        [[gestures lastObject] gestureType]!=gestureType) {
        // 直前のジェスチャーと違うジェスチャーなら登録する
        Gesture* gesture = [[Gesture alloc]
          initWithGesture:gestureType startPoint:startPoint endPoint:endPoint];
        [gestures addObject:gesture];
        [gesture release];
    }
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"---");
    for (Gesture* gesture in gestures) {
        switch ([gesture gestureType]) {
            case gLeft:
                NSLog(@"LEFT");
                break;
            case gRight:
                NSLog(@"RIGHT");
                break;
            case gUp:
                NSLog(@"UP");
                break;
            case gDown:
                NSLog(@"DOWN");
                break;
            default:
                break;
        }
    }
    [gestures removeAllObjects];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    gestures = [[NSMutableArray alloc] init];
}

- (void)dealloc {
    [super dealloc];
    [gestures release];
}

@end
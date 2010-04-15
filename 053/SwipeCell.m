// 「レシピ053: セルのスワイプを検知する」のサンプルコード (P.123)

#import "SwipeCell.h"

#define HORIZON_SWIPE_MIN 12
#define VERTICAL_SWIPE_MAX 4

@implementation SwipeCell

@synthesize swiping,hasSwiped;

CGPoint startPosition;

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
    UITouch *touch = [touches anyObject];
    // タッチ開始時の位置
    startPosition = [touch locationInView:self];
    self.swiping = NO;
    self.hasSwiped = NO;
    [self.nextResponder touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
    // タッチが横方向に移動中ならスワイプジェスチャー判定を行う
    if ([self isMoveHorizon:[touches anyObject]]) {
        [self checkSwipeGesture:(NSSet*)touches withEvent:(UIEvent*)event];
    } else {
        [self.nextResponder touchesMoved:touches withEvent:event];
    }
}


// タッチが横方向に移動中か判定する
- (BOOL)isMoveHorizon:(UITouch*)touch {
    CGPoint currentPosition = [touch locationInView:self];
    if (fabsf(startPosition.x - currentPosition.x) >= 1.0) {
        return YES;
    } else {
        return NO;
    }
}

// スワイプジェスチャーか判定する
- (void)checkSwipeGesture:(NSSet*)touches withEvent:(UIEvent*)event {
    UITouch *touch = [touches anyObject];
    CGPoint currentPosition = [touch locationInView:self];

    self.swiping = YES;

    if (hasSwiped == NO) {
        // スワイプか判定する
        if (fabsf(startPosition.x-currentPosition.x)>=HORIZON_SWIPE_MIN &&
            fabsf(startPosition.y-currentPosition.y)<=VERTICAL_SWIPE_MAX) {
            self.hasSwiped = YES;
            // スワイプした時の処理ここに入れる
        }

    }
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
    if (self.hasSwiped) {
        [self setSelected:NO];
    } else {
        [self.nextResponder touchesEnded:touches withEvent:event];
    }

    self.swiping = NO;
    self.hasSwiped = NO;
}

- (void)dealloc {
    [super dealloc];
}

@end
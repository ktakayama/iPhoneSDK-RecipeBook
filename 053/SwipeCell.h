// 「レシピ053: セルのスワイプを検知する」のサンプルコード (P.123)

@interface SwipeCell : UITableViewCell {
    BOOL swiping;
    BOOL hasSwiped;
}

@property BOOL swiping;
@property BOOL hasSwiped;

- (BOOL)isMoveHorizon:(UITouch*)touch;
- (void)checkSwipeGesture:(NSSet*)touches withEvent:(UIEvent*)event;

@end
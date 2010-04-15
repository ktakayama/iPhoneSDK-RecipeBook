// 「レシピ047: UIWebViewをフィンガージェスチャーで操作する」のサンプルコード (P.103)

@interface GestureView : UIView {
    NSMutableArray* touchPoints;
}
- (void) drawGestureLine:(NSMutableArray*)points;
@end
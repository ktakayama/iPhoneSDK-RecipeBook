// 「レシピ046: フィンガージェスチャーを認識する」のサンプルコード (P.98)

typedef enum  {
    gNone = 0,
    gLeft,
    gRight,
    gUp,
    gDown
} GestureType;


@interface Gesture : NSObject {
    GestureType type;
    CGPoint startPoint;
    CGPoint endPoint;
}
- (id) initWithGesture:(GestureType) gtype startPoint:(CGPoint) spoint
  endPoint:(CGPoint) epoint;
- (GestureType) gestureType;

@end
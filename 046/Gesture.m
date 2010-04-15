// 「レシピ046: フィンガージェスチャーを認識する」のサンプルコード (P.98)

#import "Gesture.h"

@implementation Gesture

- (id) initWithGesture:(GestureType) gtype startPoint:(CGPoint) spoint
  endPoint:(CGPoint) epoint {
    if (self = [super init]) {
        startPoint = spoint;
        endPoint = epoint;
        type = gtype;
    }

    return self;
}

- (GestureType) gestureType {
    return type;
}

@end
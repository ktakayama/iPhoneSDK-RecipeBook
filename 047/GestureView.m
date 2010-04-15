// 「レシピ047: UIWebViewをフィンガージェスチャーで操作する」のサンプルコード (P.103)

#import "GestureView.h"

@implementation GestureView

- (void) drawGestureLine:(NSMutableArray*) points {
    touchPoints = points;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    // ジェスチャーの軌跡を描画する
    if (touchPoints.count > 0 ) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, 5.0f);
        CGContextSetRGBStrokeColor(context, 255, 0, 0, 50);

        CGPoint points[touchPoints.count];
        int i=0;
        for (NSValue* value in touchPoints) {
            points[i++] = [value CGPointValue];
        }
        CGContextAddLines(context, points, touchPoints.count);
        CGContextStrokePath(context);
    }
}

@end
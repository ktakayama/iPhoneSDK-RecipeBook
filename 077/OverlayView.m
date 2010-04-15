// 「レシピ077: ムービプレイヤの上に別レイヤを表示する」のサンプルコード (P.186)

@implementation OverlayView

- (void)awakeFromNib {
    CGAffineTransform transform = self.transform;

    // Viewを90度回転させてセンターを合わせる
    transform = CGAffineTransformRotate(transform, (M_PI / 2.0));
    UIScreen *screen = [UIScreen mainScreen];
    transform = CGAffineTransformTranslate(
                transform,
                ((screen.bounds.size.height) - (self.bounds.size.height))/2,
                0);
    self.transform = transform;
    CGRect newFrame = self.frame;
    newFrame.origin.x = 0;
    self.frame = newFrame;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"touched");
}

- (void)dealloc {
    [super dealloc];
}

@end
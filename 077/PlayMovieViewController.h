// 「レシピ077: ムービプレイヤの上に別レイヤを表示する」のサンプルコード (P.186)

@interface PlayMovieViewController : UIViewController {
    IBOutlet UIView* overlayView;
}

@property (nonatomic, retain) UIView* overlayView;

- (IBAction) play;
- (void) addOverlayView;

@end
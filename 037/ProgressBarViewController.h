// 「レシピ036: ダウンロードして進捗状況をプログレッシブバーに表示する」のサンプルコード (P.76)

@interface ProgressBarViewController : UIViewController <UIActionSheetDelegate> {
	IBOutlet UIToolbar* toolbar;
	UIActionSheet* sheet;
	UIProgressView* progress;
	float total;
	float amount;
    NSMutableData* buff;
}
- (IBAction) getData;

@end

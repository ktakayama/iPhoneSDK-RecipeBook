// 「レシピ041: UIPickerViewでエンドレスなロールを作る」のサンプルコード (P.86)

#define MAX_ROLL 1000

@interface EndlessPickerViewController : UIViewController <UIPickerViewDelegate> {
    UIPickerView* myPickerView;
    NSArray *strings;
}

@end
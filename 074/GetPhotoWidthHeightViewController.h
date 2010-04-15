// 「レシピ074: メラロールから読み込んだ写真の縦横位置を調べる」のサンプルコード (P.178)

@interface GetPhotoWidthHeightViewController :
    UIViewController <UINavigationControllerDelegate,
                      UIImagePickerControllerDelegate> {
    UIImagePickerController* imagePicker;
}
- (IBAction) openPhotoLibrary;
@end
// 「レシピ074: メラロールから読み込んだ写真の縦横位置を調べる」のサンプルコード (P.178)

#import "GetPhotoWidthHeightViewController.h"

@implementation GetPhotoWidthHeightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    imagePicker = [[UIImagePickerController alloc] init];

}

- (IBAction) openPhotoLibrary {
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentModalViewController:imagePicker animated:YES];
}

- (void) imagePickerController:(UIImagePickerController*)picker
            didFinishPickingMediaWithInfo:(NSDictionary*)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    CGImageRef imageRef = [image CGImage];
    size_t w, h;
    if (image.imageOrientation==UIImageOrientationUp ||
        image.imageOrientation==UIImageOrientationDown) {
        // 横位置で撮影した写真
        w = CGImageGetWidth(imageRef);
        h = CGImageGetHeight(imageRef);
    } else {
        // 縦位置で撮影した写真
        w = CGImageGetHeight(imageRef);
        h = CGImageGetWidth(imageRef);
    }
    /*
     リサイズ処理など必要な処理を行う
     */
    [picker dismissModalViewControllerAnimated:YES];
}

- (void)dealloc {
    [imagePicker release];
    [super dealloc];
}

@end
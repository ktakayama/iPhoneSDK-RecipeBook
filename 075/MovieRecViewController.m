// 「レシピ075: 動画を録画する」のサンプルコード (P.180)

#import "MovieRecViewController.h"

@implementation MovieRecViewController

- (NSString*)thumbnailPath:(NSString*)moviePath
{
    // サムネイル画像のファイルパスを取得する
    // 動画が保存されたフォルダの親フォルダにサムネイル画像(.jpg)が保存される
    // 更新日が最新のjpgファイルが動画のサムネイル画像
    NSString *thumbnailPath;
    NSString *thumbnailDirPath =
        [[moviePath stringByDeletingLastPathComponent]
        stringByDeletingLastPathComponent];
    NSDate *latestDate = [NSDate distantPast];
    NSDirectoryEnumerator *directoryEnum =
        [[NSFileManager defaultManager] enumeratorAtPath:thumbnailDirPath];
    NSString *file;
    while (file = [directoryEnum nextObject]) {
        if ([[file pathExtension] isEqualToString: @"jpg"]) {
            file = [thumbnailDirPath stringByAppendingFormat:file];
            NSDate *fileDate = [[directoryEnum fileAttributes]
                                valueForKey:NSFileModificationDate];
            if ([fileDate compare:latestDate] == NSOrderedDescending){
                latestDate = fileDate;
                thumbnailPath = file;
            }
        }
    }
    return [NSString stringWithString:thumbnailPath];
}
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error
  contextInfo:(NSString *)contextInfo{
    NSLog(@"Finished to save into camera roll.");
}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    // アプリのtmpフォルダに保存された動画のパスを取得する
    NSString *moviePath =
        [(NSURL *)[info valueForKey:UIImagePickerControllerMediaURL] path];

    NSLog(@"thumbnailPath:%@",[self thumbnailPath:moviePath]);

    // カメラロールに保存可能かチェック後、保存する
    if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(moviePath)){
        UISaveVideoAtPathToSavedPhotosAlbum(moviePath, self,
            @selector(video:didFinishSavingWithError:contextInfo:),
            moviePath);
    }else {
        NSLog(@"Can not save movie!");
    }

    [self dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController*)picker
{
    // イメージピッカーを隠す
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        [self dismissModalViewControllerAnimated:YES];
    }
}

-(void)openMovieCamera {
    // カメラを使用可能かどうかチェックする
    if (![UIImagePickerController
          isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        return;
    }

    // 動画撮影機能を使用可能かどうかチェックする
    NSArray *mediaTypes;
    BOOL canUseVideo=NO;
    mediaTypes = [UIImagePickerController
                  availableMediaTypesForSourceType:
                  UIImagePickerControllerSourceTypeCamera];
    for (int i=0;i<[mediaTypes count];i++) {
        if (CFStringCompare((CFStringRef)[mediaTypes objectAtIndex:i],
                            kUTTypeMovie,
                            kCFCompareCaseInsensitive)) {
            canUseVideo = YES;
        }
    }
    if (canUseVideo == NO) {
        return;
    }

    // イメージピッカーを作る
    UIImagePickerController* imagePicker;
    imagePicker = [[UIImagePickerController alloc] init];
    [imagePicker autorelease];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.allowsEditing = NO;
    imagePicker.delegate = self;
    //静止画と動画を選択可にするには、 imagePicker.mediaTypes = mediaTypes;
    imagePicker.mediaTypes =
        [NSArray arrayWithObjects:(NSObject*)kUTTypeMovie,nil];

    // イメージピッカーを表示する
    [self presentModalViewController:imagePicker animated:YES];
}

- (void)loadView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,480)];
    self.view = view;
    UIButton *recMovieButton =
        [[UIButton buttonWithType:UIButtonTypeRoundedRect]autorelease];
    [recMovieButton retain];
    [recMovieButton setTitle:@"Rec" forState:UIControlStateNormal];
    [recMovieButton setFrame:CGRectMake(4,60,100,44)];
    [recMovieButton addTarget:self
        action:@selector(openMovieCamera)
        forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:recMovieButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [super dealloc];
}

@end

// 「レシピ022:クリップボードを使う」のサンプルコード (P.45)

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface CopyPaste {
}
- (void)copyImage;
- (void)pasteImageAsFile;
@end 

@implementation CopyPaste

- (void)copyImage {
    UIImage *image = [UIImage imageNamed:@"image.png"];

    UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
    // アプリケーション終了後もコピーした内容を残す
    pasteBoard.persistent = YES;
    
    // データのフォーマットについて
    // 画像を、他のアプリでペーストできることを期待するなら、JpegやPNGといった
    // 複数のフォーマットを指定して、相手が値を取得しやすいようにするべきである。
    // 逆に、自分だけが使う場合は、DNS名を逆にした名前を使うことが推奨されている。
    
    // PNG形式と、JPEG形式でクリップボードにコピー
    NSMutableDictionary *item =
        [NSMutableDictionary dictionaryWithCapacity:2];
    [item setValue:UIImagePNGRepresentation(image)
        forKey:(NSString*)kUTTypePNG];
    [item setValue:UIImageJPEGRepresentation(image,0.9)
        forKey:(NSString*)kUTTypeJPEG];
    [pasteBoard setItems: [NSArray arrayWithObject:item]];
}

- (void)pasteImageAsFile {
    UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];

    // クリップボードに指定したタイプ(kUTTypeImage)のデータがあれば、保存する
    // 受け取るときも、多くのフォーマットで受け取ると、相手に依存しにくい
    // アプリケーション独自のタイプを使う場合は、ドメイン名を逆にした名前を使うこと
    if ( [pasteBoard containsPasteboardTypes:
            [NSArray arrayWithObject:(NSString*)kUTTypeJPEG]]) { //JPEG
        NSData *data = [pasteBoard dataForPasteboardType:
                        (NSString*)kUTTypeJPEG];
        UIImage *image = [UIImage imageWithData:data];
        
        //PNG形式で保存
        NSArray *paths = NSSearchPathForDirectoriesInDomains(
            NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *filePath = [[paths objectAtIndex:0]
            stringByAppendingPathComponent:@"paste.png"];
        NSLog(@"%@",filePath);
        
        [UIImagePNGRepresentation(image)
            writeToFile:filePath atomically:YES];
    }else if ( [pasteBoard containsPasteboardTypes:
            [NSArray arrayWithObject:(NSString*)kUTTypePNG]]) { //PNG
        NSData *data = [pasteBoard dataForPasteboardType:
            (NSString*)kUTTypePNG];
        UIImage *image = [UIImage imageWithData:data];

        //PNG形式で保存
        NSArray *paths = NSSearchPathForDirectoriesInDomains(
            NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *filePath = [[paths objectAtIndex:0]
            stringByAppendingPathComponent:@"paste.png"];
        NSLog(@"%@",filePath);

        [UIImagePNGRepresentation(image)
         writeToFile:filePath atomically:YES];
    }
}
@end
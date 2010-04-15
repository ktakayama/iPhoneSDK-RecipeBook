// 「レシピ097: zipアーカイブ展開フレームワークを使う」のサンプルコード (P.243)

#import "HetimaUnZip.h"

HetimaUnZipItem *item;
HetimaUnZipContainer *container;
NSData *result;

NSString *zipfile = @"nantoka.zip";
container = [[HetimaUnZipContainer alloc] initWithZipFile:zipfile];
[container setListOnlyRealFile:YES];
NSEnumerator *enu = [[container contents] objectEnumerator];

while(item = [enu nextObject]) {
    // ファイル名がsecret.txtというファイルを探す
    if([[[itme path] lastPathComponent] isEqualToString:@"secret.txt"]) {
        result = [item data];
        break;
    }
}
[container release];


// 「レシピ097: zipアーカイブ展開フレームワークを使う」のサンプルコード (P.243)

#import "HetimaUnZip.h"

NSString *zipfile = @"nantoka.zip";
HetimaUnZipContainer *container =
    [[HetimaUnZipContainer alloc] initWithZipFile:zipfile];

// オブジェクトにディレクトリを含むか
[container setListOnlyRealFile:YES];

// ファイルリスト取得
NSMutableArray *lists = [container contents];
NSLog(@"NSArray: %@", lists);

[container release];


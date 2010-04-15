// 「レシピ097: zipアーカイブ展開フレームワークを使う」のサンプルコード (P.244)

#import "HetimaUnZip.h"

NSString *zipfile, *extractPath, *fileName, *baseDir;
NSError *error;
HetimaUnZipItem *item;
HetimaUnZipContainer *container;
NSFileManager *fileManager = [NSFileManager defaultManager];

zipfile = @"nantoka.zip";
container = [[HetimaUnZipContainer alloc] initWithZipFile:zipfile];
[container setListOnlyRealFile:YES];
NSEnumerator *enu = [[container contents] objectEnumerator];

extractPath = [NSTemporaryDirectory() stringByAppendingPathComponent:zipfile];
[fileManager createDirectoryAtPath:extractPath attributes:nil];

while(item = [enu nextObject]) {
    fileName = [extractPath stringByAppendingPathComponent:[item path]];

    baseDir = [fileName stringByDeletingLastPathComponent];
    if(![fileManager fileExistsAtPath:baseDir]) {
        [fileManager createDirectoryAtPath:baseDir attributes:nil];
    }

    BOOL result = [item extractTo:fileName delegate:nil];
    if(!result) {
        // 解凍失敗
        [fileManager removeItemAtPath:extractPath error:&error];
        break;
    }
}
[container release];


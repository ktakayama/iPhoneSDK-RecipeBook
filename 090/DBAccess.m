// 「レシピ090 :SQLiteを使う　準備編」のサンプルコード (P.218)

#import <sqlite3.h>
#define DBPATH @"data.db"
#define DBFLAG @"dbflag"

@interface DBAccess : NSObject {
}
@end
@implementation DBAccess

- (void)copyDatabaseIfNeeded {
    // db未作成なら、templateからコピーして作成する
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;

    NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                  NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    NSString *flagPath = [documentsDir stringByAppendingPathComponent:DBFLAG];

    // 0byteのdata.dbファイルが作られることがあるため、data.dbファイルの有無は見ない
    // db作成済みフラグファイルの有無で判断する
    BOOL success = [fileManager fileExistsAtPath:flagPath];
    if(!success) {
        NSString *dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];
        NSString *templateDBPath = [[[NSBundle mainBundle] resourcePath]
                                    stringByAppendingPathComponent:@"template.db"];

        //DBファイルがあれば削除
        if( [fileManager fileExistsAtPath:dbPath] ==YES) {
            [fileManager removeItemAtPath:dbPath error:NULL];
        }

        // データベースファイルをコピー
        success = [fileManager copyItemAtPath:templateDBPath
                                       toPath:dbPath error:&error];

        if (!success) {
            NSAssert1(0, @"Failed to create database :%@.",
                      [error localizedDescription]);
            return;
        }

        // db作成済みフラグファイルを生成
        [fileManager createFileAtPath:flagPath contents:nil
                           attributes:nil];
    }
}
@end
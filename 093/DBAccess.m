// 「レシピ093 :SQLiteを使う　DBの変更編」のサンプルコード (P.227)

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

-(NSArray*)migrateSqls {
    // マイグレーション用のSQLの配列を返す。
    // retの要素は配列（１回分のバージョンアップに実行するSQLを列挙したもの）。
    // SQLの中で、DBVersionを必ずUPDATEすること
    NSArray *ret = [NSArray arrayWithObjects:
        [NSArray arrayWithObjects:  // vertion 0 to 1
         @"ALTER TABLE Sample ADD viewCount INTEGER DEFAULT 0;",
         @"ALTER TABLE Sample ADD changeCount INTEGER DEFAULT 0;",
         @"UPDATE DBVersion set version=1;",
         nil],
        [NSArray arrayWithObjects:  // vertion 1 to 2
         @"create index test_index_02 on Sample(updateDT DESC);",
         @"UPDATE DBVersion set version=2;",
         nil],
        nil];
    return ret;
}

-(int)dbVersion
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                  NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    NSString *dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];

    sqlite3_stmt *stmt = nil;
    const char *sql = "select version from DBVersion";
    int version = -1;

    if(sqlite3_open([dbPath UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        return version;
    }
    if(sqlite3_prepare_v2(database, sql, -1, &stmt, NULL) == SQLITE_OK) {
        while(sqlite3_step(stmt) == SQLITE_ROW) {
            // INTEGER型として取得。値がないときは0になる
            version=(int)sqlite3_column_int(stmt, 0);
        }
    }
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(database);

    return version;
}
-(void)migrateDBSql:(NSString*)sqlString {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                    NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    NSString *dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];

    NSLog(@"%@",sqlString);

    sqlite3_stmt *stmt = nil;
    if(sqlite3_open([dbPath UTF8String], &database) != SQLITE_OK) {
        NSAssert1(0, @"Error while opening database . '%s'",
                  sqlite3_errmsg(database));
        sqlite3_close(database);
        return;
    }
    const char *sql = [sqlString UTF8String];
    if(sqlite3_prepare_v2(database, sql, -1, &stmt, NULL) != SQLITE_OK) {
        NSAssert1(0, @"Error while creating add statement . '%s'",
                  sqlite3_errmsg(database));
        sqlite3_finalize(stmt);
        sqlite3_close(database);
        return;
    }
    if(SQLITE_DONE != sqlite3_step(stmt))
        NSAssert1(0, @"Error while inserting data. '%s'",
                  sqlite3_errmsg(database));

    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(database);
}
<<<

以下のように、アプリケーションの開始時にDBのバージョンをチェックし、必要なバージョンアップを行います。

>>> ファイル
- (void)applicationDidFinishLaunching:(UIApplication *)application {
    DBAccess *dbAccess  = [[DBAccess alloc]init];
    // まずDBの作成
    [dbAccess copyDatabaseIfNeeded];

    // DBのバージョンを取得
    int dbVersion = [dbAccess dbVersion];
    if (dbVersion >=0) {
        // SQLを取得
        NSArray *migrateSqls = [dbAccess migrateSqls];

        // 順に実行
        for (int i=dbVersion;i<[migrateSqls count];i++) {
            for (NSString *sql in [migrateSqls objectAtIndex:i]) {
                [dbAccess migrateDBSql:sql];
            }
        }
    }
}
@end
// 「レシピ091:SQLiteを使う　検索編」のサンプルコード (P.221)

#import <sqlite3.h>
#define DBPATH @"data.db"

@interface SampleModel : NSObject
{
    int recordId;
    NSDate *createDT;
    NSDate *updateDT;
    NSString *title;
    NSString *content;
    UIImage *image;
    int stars;
}
+(NSMutableArray*)search:(NSString*)conditionTitle;
@property (nonatomic, readwrite) int recordId;
@property (nonatomic, retain, readwrite) NSDate *createDT;
@property (nonatomic, retain, readwrite) NSDate *updateDT;
@property (nonatomic, retain, readwrite) NSString *title;
@property (nonatomic, retain, readwrite) NSString *content;
@property (nonatomic, retain, readwrite) UIImage* image;
@property(nonatomic,readwrite) int stars;
@end

static sqlite3 *database = nil;

@implementation SampleModel
@synthesize recordId,createDT,updateDT,title,content,image,stars;
-(id)init {
    [super init];
    recordId = -1;
    return self;
}
+(NSMutableArray*)search:(NSString*)conditionTitle
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                  NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    NSString *dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];

    sqlite3_stmt *stmt = nil;

    const char *allSql = [[NSString stringWithFormat:@"%@%@",
        @"select id, createDT, updateDT, title, content, image, stars ",
        @"from Sample order by createDT desc" ] UTF8String];
    const char *titleSearchSql = [[NSString stringWithFormat:@"%@%@",
        @"select id, createDT, updateDT, title, content, image, stars ",
        @"from Sample where title like ? order by createDT desc"]UTF8String];

    //[listData release];
    NSMutableArray *listData = [[[NSMutableArray alloc]init]autorelease];
    [listData retain];

    const char *sql = allSql;
    if (conditionTitle) {
        sql = titleSearchSql;
    }

    if(sqlite3_open([dbPath UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        return listData;
    }
    if(sqlite3_prepare_v2(database, sql, -1, &stmt, NULL) == SQLITE_OK) {
        // SQLの条件値をバインド
        if (conditionTitle) {
            sqlite3_bind_text(stmt, 1,[conditionTitle UTF8String],
                              -1, SQLITE_TRANSIENT);
        }

        while(sqlite3_step(stmt) == SQLITE_ROW) {
            SampleModel *data = [[[SampleModel alloc]init]autorelease];
            // TEXT型として取得。値がないときはNULLになるのでチェックが必要
            char* cTitle = (char *)sqlite3_column_text(stmt, 3);
            if (cTitle)
                data.title = [NSString stringWithUTF8String:cTitle];
            char* cContent = (char *)sqlite3_column_text(stmt, 4);
            if (cContent)
                data.content = [NSString stringWithUTF8String:cContent];

            // BLOG型として取得。値がないときはNULLになるのでチェックが必要
            NSData *imageData = [NSData
                dataWithBytes:(const void *)sqlite3_column_blob(stmt, 5)
                length:(int)sqlite3_column_bytes(stmt,5)];
            if (imageData) {
                data.image = [UIImage imageWithData:imageData];
            }

            // INTEGER型として取得。値がないときは0になる
            data.recordId =(int)sqlite3_column_int(stmt, 0);
            data.createDT = [NSDate dateWithTimeIntervalSince1970:
                             (int)sqlite3_column_int(stmt, 1)];
            data.updateDT = [NSDate dateWithTimeIntervalSince1970:
                             (int)sqlite3_column_int(stmt, 2)];
            data.stars = (int)sqlite3_column_int(stmt, 6);
            [listData addObject:data];
        }
    }else{
        NSAssert1(0, @"Error Select pages statement. '%s'",
                  sqlite3_errmsg(database));
    }
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(database);

    return listData;
}
@end

// 「レシピ092:SQLiteを使う　追加・削除編」のサンプルコード (P.224)

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

+(int)saveId:(int)recordId
    createDT:(NSDate*)createDT
        title:(NSString*)title
      content:(NSString*)content
        image:(UIImage*)image
        stars:(int)stars
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                  NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    NSString *dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];

    sqlite3_stmt *stmt = nil;
    const char *sql = [[NSString stringWithFormat:@"%@%@",
        @"insert or replace into Sample(id, createDT, updateDT, title, ",
        @"content, image, stars) Values(?, ?, ?, ?, ?, ?, ?)" ] UTF8String];
    if(sqlite3_open([dbPath UTF8String], &database) != SQLITE_OK) {
        NSAssert1(0, @"Error while opening database . '%s'",
            sqlite3_errmsg(database));
        sqlite3_close(database);
        return -1;
    }
    if(sqlite3_prepare_v2(database, sql, -1, &stmt, NULL) != SQLITE_OK) {
        NSAssert1(0, @"Error while creating add statement . '%s'",
            sqlite3_errmsg(database));
        sqlite3_finalize(stmt);
        sqlite3_close(database);
        return -1;
    }

    NSDate* updateDT = [NSDate new];
    if (recordId==-1) {
        createDT = [updateDT copy];
    }else {
        sqlite3_bind_int(stmt, 1, recordId );
    }
    sqlite3_bind_int(stmt, 2, [createDT timeIntervalSince1970] );
    sqlite3_bind_int(stmt, 3, [updateDT timeIntervalSince1970] );
    sqlite3_bind_text(stmt, 4, [title UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 5, [content UTF8String], -1, SQLITE_TRANSIENT);
    NSData *imageData;
    if (image) {
        imageData = UIImagePNGRepresentation(image);
        sqlite3_bind_blob(stmt, 6, [imageData bytes] , [imageData length],
            SQLITE_TRANSIENT);
    }
    sqlite3_bind_int(stmt, 7, stars );

    if(SQLITE_DONE != sqlite3_step(stmt))
        NSAssert1(0, @"Error while inserting data. '%s'",
            sqlite3_errmsg(database));
    else
        //最後に挿入した主キーを取得して、recordIdにセット
        // sqlite3_last_insert_rowidは主キー(INTEGER PRIMARY KEYな項目)を返す
        // なければrowidを返す
        recordId = sqlite3_last_insert_rowid(database);

    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(database);
    return recordId;
}
+(void)deleteId:(int)recordId
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                  NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    NSString *dbPath = [documentsDir stringByAppendingPathComponent:DBPATH];

    sqlite3_stmt *stmt = nil;
    const char *sql = "delete from Sample where id=?";
    if(sqlite3_open([dbPath UTF8String], &database) != SQLITE_OK) {
        NSAssert1(0, @"Error while opening database . '%s'",
            sqlite3_errmsg(database));
        sqlite3_close(database);
        return;
    }
    if(sqlite3_prepare_v2(database, sql, -1, &stmt, NULL) != SQLITE_OK) {
        NSAssert1(0, @"Error while creating add statement . '%s'",
            sqlite3_errmsg(database));
        sqlite3_finalize(stmt);
        sqlite3_close(database);
        return;
    }
    sqlite3_bind_int(stmt, 1, recordId );
    if(SQLITE_DONE != sqlite3_step(stmt))
        NSAssert1(0, @"Error while inserting data. '%s'",
            sqlite3_errmsg(database));
    sqlite3_reset(stmt);
    sqlite3_finalize(stmt);
    sqlite3_close(database);
}
-(void)saveRecord
{
    recordId = [SampleModel saveId:recordId createDT:createDT
                           title:title content:content
                           image:image stars:stars];
}
-(void)deleteRecord
{
    [SampleModel deleteId:recordId];
}
@end
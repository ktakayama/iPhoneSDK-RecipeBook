// 「レシピ023:NSCoderでデータを保存する」のサンプルコード (P.47)

// キーはencode,decode時の入力ミスを防ぐため、マクロで定義する
#define SAMPLEDATA_KEY_STARS (@"stars")
#define SAMPLEDATA_KEY_TITLE (@"title")
#define SAMPLEDATA_KEY_ITEMS (@"items")

@interface SampleData : NSObject <NSCoding>{
    int starCount;
    NSString *titleText;
    NSMutableDictionary *items;
    int tempNumber; //保存しない変数
}
@property(nonatomic,readwrite) int starCount;
@property (nonatomic, retain, readwrite) NSString *titleText;
@property (nonatomic, retain, readwrite) NSMutableDictionary *items;
@property(nonatomic,readwrite) int tempNumber;
@end

@implementation SampleData
@synthesize starCount, titleText, items, tempNumber;

- (void)encodeWithCoder:(NSCoder*)coder
{
    // エンコード
    [coder encodeObject:titleText forKey:SAMPLEDATA_KEY_TITLE];
    [coder encodeObject:items forKey:SAMPLEDATA_KEY_ITEMS];
    [coder encodeInt:starCount forKey:SAMPLEDATA_KEY_STARS];
}
- (id)initWithCoder:(NSCoder*)decoder
{
    if ((self = [super init])){
        //init:から呼ばれた場合用に、デフォルト値を指定しておく
        self.titleText = nil;
        self.items = [[NSMutableDictionary alloc]init];
        starCount = 0;
        tempNumber = 0;
        if (decoder==nil) {
            return self;
        }

        // デコード。対象となるKeyが存在するか否かは必ずチェックすること。
        if ([decoder containsValueForKey:SAMPLEDATA_KEY_TITLE]) {
            self.titleText =
                [decoder decodeObjectForKey:SAMPLEDATA_KEY_TITLE];
        }
        if ([decoder containsValueForKey:SAMPLEDATA_KEY_ITEMS]) {
            self.items =
                [decoder decodeObjectForKey:SAMPLEDATA_KEY_ITEMS];
        }
        if ([decoder containsValueForKey:SAMPLEDATA_KEY_STARS]) {
            starCount = [decoder decodeIntForKey:SAMPLEDATA_KEY_STARS];
        }
    }
    return self;
}
- (id)init {
    if ((self = [super init])){
        [self initWithCoder:nil];
    }
    return self;
}
@end
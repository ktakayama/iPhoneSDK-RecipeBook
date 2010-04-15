// 「レシピ024:XMLをパースする」のサンプルコード (P.49)

#import <UIKit/UIKit.h>

@interface SampleParser : NSObject
{
    NSMutableArray *tagPath;
    NSMutableArray *tagPathAttributs;
    NSMutableString *recordingText;
}
@end

@implementation SampleParser
+(void) parseTest {
    // YahooのヘッドラインのRSSを取得
    NSString *urlStr = @"http://headlines.yahoo.co.jp/rss/sci.xml";
    NSXMLParser *parser = [[NSXMLParser alloc]
        initWithContentsOfURL:[NSURL URLWithString:urlStr]];
    SampleParser *sp = [[SampleParser alloc]init];

    [parser setDelegate:sp];
    [parser parse];
    NSError *parseError = [parser parserError];
    if (parseError ) {
        NSLog(@"Err %@",[parseError description]);
    }
    NSLog(@"parseEnd");
}

-(id)init {
    if (self = [super init]) {
        tagPath = [[[NSMutableArray alloc]init]retain];
        tagPathAttributs = [[[NSMutableArray alloc]init]retain];
        // ルート要素の代わりにダミー値をセット
        [tagPath addObject:@""];
        [tagPathAttributs addObject:[NSDictionary dictionary]];
    }
    return self;
}
-(void)dealloc {
    [tagPath release];
    [tagPathAttributs release];
    [super dealloc];
}
// タグのフルパス表現(
-(NSString*)tagFullPath {
    return [tagPath componentsJoinedByString:@"/"];
}

// タグの開始
- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributeDict
{
    // タグ階層に情報を追加
    NSString *tag = [elementName copy];
    [tagPath addObject:tag];
    [tagPathAttributs addObject:[attributeDict copy]];

    //文字列の取得開始判定
    NSString *tagFullPath = [self tagFullPath];
    if ([tagFullPath hasPrefix:@"/rss/channel/item/title"]) {
        recordingText = [[[NSMutableString alloc]init]autorelease];
        [recordingText appendString:@""];
    }
}

// タグの終了
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    //文字列の取得終了判定
    NSString *tagFullPath = [self tagFullPath];
    if ([tagFullPath hasPrefix:@"/rss/channel/item/title"]) {
        NSLog(@"Title:%@",recordingText);
        recordingText = nil;
    }
    // その他、タグに応じて行う処理はここで行う。
    // tagPathAttributsの最後の要素にタグの属性が入っている

    // タグ階層を一段階もどす
    [tagPath removeLastObject];
    [tagPathAttributs removeLastObject];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    // テキストの取得中ならば、テキストを記録
    if (recordingText!=nil) {
        [recordingText appendString:string];
    }
}
- (void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock{
    //NSLog(@"cData:%@",[NSString stringWithUTF8String:[CDATABlock bytes]]);
}
@end
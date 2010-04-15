// 「レシピ109 :GoogleDocsからファイルリストを取得する」のサンプルコード (P.296)

#import "GDataDocs.h"
@interface GDocGetSample : UITableViewController {
    GDataServiceGoogleDocs *service;
    GDataFeedDocList *docList;
}
@end

@implementation GDocGetSample
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [[docList entries] count];
}
- (NSString*)getDocKind:(GDataEntryDocBase *)doc
{
    // ドキュメントの種類を取得する
    NSString *docKind = @"unknown";
    NSLog(@"%@",[[doc alternateLink] URL ]);
    NSArray *categories;
    categories = [GDataCategory categoriesWithScheme:kGDataCategoryScheme
                                      fromCategories:[doc categories]];
    if ([categories count] >= 1) {
        docKind = [[categories objectAtIndex:0] label];
    }
    return docKind;
}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *kCellID = @"cellID";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellID] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    if (indexPath.row < [[docList entries] count]) {
        GDataEntryDocBase *doc = [docList entryAtIndex:indexPath.row];
        NSString *docKind = [self getDocKind:doc];
        // スター付き
        if ([doc isStarred]) {
            docKind = [NSString stringWithFormat:@"★ %@",docKind];
        }

        NSString *displayStr = [NSString stringWithFormat:@"%@ (%@)",
                                [[doc title] stringValue], docKind];
        cell.textLabel.text = displayStr;
    }
    return cell;
}

// docList list fetch callback
- (void)docListFetchTicket:(GDataServiceTicket *)ticket
          finishedWithFeed:(GDataFeedDocList *)feed
                     error:(NSError *)error {
    if (error) {
        NSLog(@"fetch error: %@", error);
        return;
    }
    [docList release];
    docList = feed;
    [docList retain];
    [self.tableView reloadData];
}

- (void) getList {
    // fetchDocsFeedWithURLはリストの25%しかとれない。
    //（さらに取得するときはfeedのnextリンクを使う)
    // 一度に取りたいときは、GDataQueryDocsオブジェクトを作成して
    // fetchFeedWithQueryを使う
    NSURL *feedURL = [GDataServiceGoogleDocs docsFeedURLUsingHTTPS:YES];

    GDataQueryDocs *query =
        [GDataQueryDocs documentQueryWithFeedURL:feedURL];
    [query setMaxResults:1000];
    [query setShouldShowFolders:YES];

    GDataServiceTicket *ticket;

    ticket =
        [service fetchFeedWithQuery:query
        delegate:self
        didFinishSelector:
        @selector(docListFetchTicket:finishedWithFeed:error:)];
}
-(void)setupService:(NSString*)username password:(NSString*)password {
    service = [[[GDataServiceGoogleDocs alloc] init] autorelease];
    [service setUserCredentialsWithUsername:username
                                   password:password];
    [service retain];

    // エージェントを設定(書式:yourName-appName-appVersion)
    [service setUserAgent:@"MyCompany-GSample-1.0"];

    // パフォーマンスを良くするため
    [service setServiceShouldFollowNextLinks:YES];
    //[query setMaxResults:1000];
    [service setShouldCacheDatedData:YES];
    // YESにすると、取得したXMLをパースしないので高速化できるが、データの変更は
    // 出来なくなる
    [service setShouldServiceFeedsIgnoreUnknowns:NO];
}

-(id)initWithStyle:(UITableViewStyle)style {
    if ([super initWithStyle:style]!=nil) {
        self.title = @"Google Documents";
        self.tableView.scrollEnabled = YES;

        docList = [[GDataFeedDocList alloc]init];
    }
    return self;
}
- (void)dealloc
{
    [docList release];
    [service release];

    [super dealloc];
}
@end
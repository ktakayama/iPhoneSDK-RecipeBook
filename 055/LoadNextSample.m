// 「レシピ055:TableViewに次のｘ件を読み込むボタンをつける」のサンプルコード (P.xx)

#define nextLoadCount (16)
#define maxDataCount (50)

@interface LoadNextSample : UITableViewController {
    NSMutableArray *dataList;
}
@end

@implementation LoadNextSample
-(void)loadNextData {
    // nextLoadCount件のデータを読み込み、dataListに追加する
    int startIndex = [dataList count]+1;
    for (int i=0; i < nextLoadCount ;i++) {
        if ([dataList count] >= maxDataCount)
            break;
        NSString *text = [NSString stringWithFormat:@"%d",startIndex+i];
        [dataList addObject:text];
    }

    if ([dataList count] < maxDataCount) {
        // 最大件数に達していなければ「次のデータを読み込む」ボタンを生成する
        UIButton *footerButton =
            [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [footerButton setTitle:@"Load More Data..."
            forState:UIControlStateNormal];
        [footerButton setFrame:CGRectMake(4,6,292,44)];
        [footerButton addTarget:self action:@selector(loadNextData)
            forControlEvents:UIControlEventTouchUpInside];
        UIView *footerView =
            [[UIView alloc]initWithFrame:CGRectMake(10,0,300,60)];
        footerView.backgroundColor = [UIColor clearColor];
        [footerView addSubview:footerButton];
        self.tableView.tableFooterView = footerView;
    }else {
        // 最大件数に達したら「次のデータを読み込む」ボタンを削除する
        self.tableView.tableFooterView = nil;
    }

    // テーブルを再描画する
    [self.tableView reloadData];
}
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [dataList count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // セルの再利用が可能ならば再利用する
    static NSString *cID = @"cellID";
    UITableViewCell *cell =
        [tableView dequeueReusableCellWithIdentifier:cID];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:
            UITableViewCellStyleDefault reuseIdentifier:cID] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    // テーブルのセルにデータをセットする
    if (indexPath.row < [dataList count]) {
        NSString *text = [dataList objectAtIndex:indexPath.row];
        cell.textLabel.text = text;
    }
    return cell;
}
-(id)initWithStyle:(UITableViewStyle)style {
    if ([super initWithStyle:style]!=nil) {

        dataList = [[NSMutableArray alloc]init];
        //初期データを追加
        [self loadNextData];
    }
    return self;
}
- (void)dealloc
{
    [dataList release];
    [super dealloc];
}
@end


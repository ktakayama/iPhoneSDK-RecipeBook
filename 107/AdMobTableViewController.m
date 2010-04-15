// 「レシピ0107: AdMobの広告を組み込む」のサンプルコード (P.288)

- (UITableViewCell *)tableView:(UITableView *)tableView
  cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell =
        [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc]
                    initWithStyle:UITableViewCellStyleDefault
                    reuseIdentifier:CellIdentifier] autorelease];
    }

    // AdMobViewをセルに組み込む
    [cell.contentView addSubview:[AdMobView requestAdWithDelegate:self]];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView
  heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // AdMobの広告の高さ
    return 48.0f;
}

- (NSString *)publisherId {
    return @"ここにpublisher idを入れる";
}
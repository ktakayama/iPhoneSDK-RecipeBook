// 「レシピ050: カスタムセルを利用する」のサンプルコード (P.118)

- (UITableViewCell *) tableView:(UITableView *)tableView
                        cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CustomCell";

    MyCustomCell *cell = (MyCustomCell *)[tableView
                        dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[MyCustomCell alloc] initWithFrame:CGRectZero
                    reuseIdentifier:CellIdentifier] autorelease];
    }

    cell.mainText.text =
            [NSString stringWithFormat:@"Section[%d]", indexPath.section];
    cell.description.text =
            [NSString stringWithFormat:@"Row[%d]", indexPath.row];
    return cell;
}


// 「レシピ050: カスタムセルを利用する」のサンプルコード (P.115)

#define LABEL1_TAG 1
#define LABEL2_TAG 2

- (UITableViewCell *) tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CustomCell";

    UILabel *label1, *label2;
    UITableViewCell *cell = (UITableViewCell *)[tableView
                dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectMake(0,0,320,44)
                    reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 100, 25)];
        label1.tag = LABEL1_TAG;
        [cell.contentView addSubview:label1];
        [label1 release];

        label2 = [[UILabel alloc] initWithFrame:CGRectMake(200, 15, 100, 25)];
        label2.tag = LABEL2_TAG;
        [cell.contentView addSubview:label2];
        [label2 release];
    } else {
        label1 = (UILabel *)[cell.contentView viewWithTag:LABEL1_TAG];
        label2 = (UILabel *)[cell.contentView viewWithTag:LABEL2_TAG];
    }

    label1.text = [NSString stringWithFormat:@"Section[%d]", indexPath.section];
    label2.text = [NSString stringWithFormat:@"Row[%d]", indexPath.row];
    return cell;
}


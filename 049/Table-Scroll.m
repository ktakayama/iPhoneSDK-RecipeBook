// 「レシピ049: ITableViewを所定の位置までスクロールさせる」のサンプルコード (P.114)


// セルを指定してスクロールさせる
NSIndexPath* indexPath = [NSIndexPath indexPathForRow:10 inSection:0];
[tableView scrollToRowAtIndexPath:indexPath
                 atScrollPosition:UITableViewScrollPositionTop animated:NO];

// 最後に選択したセルの位置にスクロールさせる
[tableView
    scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionTop
    animated:YES];

// セルを選択状態にしてスクロールさせる
NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
[tableView selectRowAtIndexPath:indexPath
                       animated:YES
                 scrollPosition:UITableViewScrollPositionTop];
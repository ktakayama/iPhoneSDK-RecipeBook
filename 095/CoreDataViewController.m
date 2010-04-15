// 「レシピ095: CoreDataを使う　編集」のサンプルコード (P.237)

- (void)tableView:(UITableView *)tableView
  didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TitleViewController *titleViewController =
       [[TitleViewController alloc] initWithNibName:@"TitleViewController"
                                    bundle:nil];
    Book *book = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    titleViewController.book = book;
    [self.navigationController pushViewController:titleViewController
                                                               animated:YES];
    [titleViewController release];
}

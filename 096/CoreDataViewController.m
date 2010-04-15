// 「レシピ096: CoreDataを使う　ソート」のサンプルコード (P.237)

- (IBAction) save {
    [self.book setValue:titleField.text forKey:@"title"];
    [self.book setValue:authorField.text forKey:@"author"];
    [self.book setValue:datePicker.date forKey:@"date"];

    NSError *error;
    if (![self.book.managedObjectContext save:&error]) {
        // エラー処理
    }

    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
  cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell =
        [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc]
                    initWithStyle:UITableViewCellStyleValue1
                    reuseIdentifier:CellIdentifier] autorelease];
    }

    Book *book = [fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [[book valueForKey:@"title"] description];
    cell.detailTextLabel.text = [[book valueForKey:@"author"] description];

    return cell;
}

// 「レシピ094: CoreDataを使う　登録、保存、削除」のサンプルコード (P.234)

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
    // Bookのtitle属性の値をセルにセット
    Book *book = [fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [[book valueForKey:@"title"] description];

    return cell;
}

- (NSFetchedResultsController *)fetchedResultsController {

    if (fetchedResultsController != nil) {
        return fetchedResultsController;
    }

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // エンティティ名をBookにする
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Book"
                               inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchBatchSize:20];

    // title属性でソートする
    NSSortDescriptor *sortDescriptor =
           [[NSSortDescriptor alloc] initWithKey:@"title" ascending:NO];
    NSArray *sortDescriptors =
           [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];

    NSFetchedResultsController *aFetchedResultsController =
       [[NSFetchedResultsController alloc]
           initWithFetchRequest:fetchRequest
           managedObjectContext:managedObjectContext
           sectionNameKeyPath:nil
           cacheName:@"Root"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;

    [aFetchedResultsController release];
    [fetchRequest release];
    [sortDescriptor release];
    [sortDescriptors release];

    return fetchedResultsController;
}

- (void)insertNewObject {
    NSManagedObjectContext *context =
               [fetchedResultsController managedObjectContext];
    NSEntityDescription *entity =
               [[fetchedResultsController fetchRequest] entity];
    Book *book = (Book*)[NSEntityDescription
               insertNewObjectForEntityForName:[entity name]
               inManagedObjectContext:context];
    // 本のタイトルを設定する
    [book setValue:@"New Book" forKey:@"title"];

    // 追加したエンティティを保存する
    NSError *error = nil;
    if (![context save:&error]) {
        // エラー処理
    }
}

- (void)tableView:(UITableView *)tableView
  commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
  forRowAtIndexPath:(NSIndexPath *)indexPath {

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // 削除処理
        NSManagedObjectContext *context =
                  [fetchedResultsController managedObjectContext];
        [context deleteObject:
                  [fetchedResultsController objectAtIndexPath:indexPath]];

        // 保存処理
        NSError *error = nil;
        if (![context save:&error]) {
            // エラー処理
        }
    }
}
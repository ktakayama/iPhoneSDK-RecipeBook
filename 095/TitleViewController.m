// 「レシピ095: CoreDataを使う　編集」のサンプルコード (P.237)

- (void) textFieldDidEndEditing:(UITextField*) textField {
    [self.book setValue:textField.text forKey:@"title"];

    // 変更内容を保存する
    NSError *error;
    if (![self.book.managedObjectContext save:&error]) {
        // エラー処理
    }

    [self.navigationController popToRootViewControllerAnimated:YES];
}
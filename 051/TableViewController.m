// 「レシピ051: UITableCellViewにクリッカブルリンクを入れる」のサンプルコード (P.119)


- (UITableViewCell *)tableView:(UITableView *)tableView
                    cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    // セル表示にはLinkableViewCellクラスを使用する
    LinkableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[LinkableViewCell alloc]
            initWithStyle:UITableViewCellStyleDefault
            reuseIdentifier:CellIdentifier] autorelease];
        cell.webView.delegate = self;
    }

    // 各セルに表示するリンクを設定する
    NSString *string = @"Go to <a href=¥"http://example.com/¥">Link</a>";
    [cell.webView loadHTMLString:string baseURL:nil];

    return cell;
}

- (BOOL)webView:(UIWebView *)webView
            shouldStartLoadWithRequest:(NSURLRequest *)request
            navigationType:(UIWebViewNavigationType)navigationType {
    if (navigationType == UIWebViewNavigationTypeLinkClicked)
    {
        WebViewController   *webController = [[WebViewController alloc] init];
        webController.url = request.URL;
        [self.navigationController pushViewController:webController
                                             animated:YES];
        [webController release];
        return NO;
    }

    return YES;
}
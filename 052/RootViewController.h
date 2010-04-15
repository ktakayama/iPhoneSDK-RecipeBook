// 「レシピ052: UITableViewControllerを使用せずにUITableViewを表示する」のサンプルコード (P.121)

@interface RootViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    UITableView* myTableView;
}

@end
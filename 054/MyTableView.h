// 「レシピ054: UITableViewをプルダウンしたことを感知する」のサンプルコード (P.126)

#import "HeaderView.h"
@interface MyTableView : UITableView <UITableViewDelegate> {
    HeaderView* headerView;
}
@end
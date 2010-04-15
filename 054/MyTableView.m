// 「レシピ054: UITableViewをプルダウンしたことを感知する」のサンプルコード (P.126)

#import "MyTableView.h"

@implementation MyTableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]){
        headerView = [[HeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.bounds.size.height, 320.0f, self.bounds.size.height)];
        headerView.backgroundColor = [UIColor grayColor];
        [self addSubview:headerView];
        [headerView release];

        self.showsVerticalScrollIndicator = YES;
    }
    return self;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;{
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y > -65.0f &&
        scrollView.contentOffset.y < 0.0f) {
        // プルダウンされている
        headerView.label.text = @"Pull down";
    } else if (scrollView.contentOffset.y < -65.0f) {
        // 十分プルダウンされたのでリロード処理など行う
        headerView.label.text = @"Reload";
    }
}

- (void)scrollViewDidEndDragging:
    (UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
}

@end
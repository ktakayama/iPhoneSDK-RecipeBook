// 「レシピ054: UITableViewをプルダウンしたことを感知する」のサンプルコード (P.126)

@class MyTableView;
@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    MyTableView* myTableView = [[MyTableView alloc]
       initWithFrame:self.view.bounds style:UITableViewStylePlain];
    myTableView.dataSource = self;
    myTableView.delegate = myTableView;
    self.tableView = myTableView;
    [myTableView release];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
  numberOfRowsInSection:(NSInteger)section {
    return 0;
}

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
    return cell;
}


- (void)dealloc {
    [super dealloc];
}

@end
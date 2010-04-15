// 「レシピ036: UINavigationBarにUISearchBarを入れる」のサンプルコード (P.75)

#import "RootViewController.h"

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];

	UISearchBar *searchBar = [[UISearchBar alloc] init];
	searchBar.delegate = self;
	self.navigationItem.titleView = searchBar;
	self.navigationItem.titleView.frame = CGRectMake(0, 0, 320, 44);
	[searchBar release];
}

- (void) searchBarSearchButtonClicked: (UISearchBar *) searchBar {  
	[searchBar resignFirstResponder];  
	NSLog(@"search text=%@", searchBar.text);
	
} 

- (void)dealloc {
    [super dealloc];
}


@end
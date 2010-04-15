// 「レシピ015: Objective-Cでプロパティ名とインスタンス名を変える」のサンプルコード (P.38)

#import "Book.h"

@implementation Book

@synthesize name=title;

- (void) hoge {
    NSLog(@"%@", self.name);
}

- (void)dealloc {
    [super dealloc];
    self.name=nil;
}

@end
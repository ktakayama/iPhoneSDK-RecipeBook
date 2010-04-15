// 「レシピ031: UndocumentedなTransition Animation」のサンプルコード (P.69)

# import <QuartzCore/QuartzCore.h>

CATransition *transition = [CATransition animation];
[transition setDelegate:self];
[transition setDuration:0.5f];
[transition setType:@"suckEffect"];
[[self.view layer] addAnimation:transition forKey:@"SomeAnim"];


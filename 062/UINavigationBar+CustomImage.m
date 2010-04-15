// 「レシピ062: UINavigationBarに画像を使う」のサンプルコード (P.141)

@interface UINavigationBar (CustomImage)
@end

@implementation UINavigationBar (CustomImage)

- (void) drawRect:(CGRect)rect {
    [[UIImage imageNamed:@"bgimage.png"] drawInRect:rect];
}

@end


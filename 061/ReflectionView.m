// 「レシピ061: UIImageViewに反射エフェクトを付ける」のサンプルコード (P.138)

@interface ReflectionView : UIView {
    UIImage* image;
}

@property (nonatomic, retain) UIImage* image;

- (void) setImage:(UIImage*)img;

@end
// 「レシピ056: 画像を任意のサイズにリサイズする」のサンプルコード (P.134)

// 元画像
UIImage *image = [UIImage imageNamed:@"someimage.jpg"];

// 新しいサイズ
CGSize size = CGSizeMake(300, 400);

UIImage *resultImage;
UIGraphicsBeginImageContext(size);
[image drawInRect:CGRectMake(0, 0, size.width, size.height)];
resultImage = UIGraphicsGetImageFromCurrentImageContext();
UIGraphicsEndImageContext();


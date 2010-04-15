// 「レシピ057: 画像を任意のサイズで切り取る」のサンプルコード (P.134)

// 元画像
UIImage *image = [UIImage imageNamed:@"someimage.jpg"];

// 切り取りたいサイズ
CGSize size = CGSizeMake(300, 400);

UIImage *resultImage;
UIGraphicsBeginImageContext(size);
[image drawAtPoint:CGPointMake(0, 0)];
resultImage = UIGraphicsGetImageFromCurrentImageContext();
UIGraphicsEndImageContext();


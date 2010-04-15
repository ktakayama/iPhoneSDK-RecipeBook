// 「レシピ066: 描画の遅いimageWithContentsOfFile:を早くする」のサンプルコード (P.153)

NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:@"image_data"];
UIImage* image = [[UIImage alloc] imageWithData:data];
CGImageRef imageRef = [image CGImage];
UIGraphicsBeginImageContext(CGSizeMake(CGImageGetWidth(imageRef), CGImageGetHeight(imageRef)));
[image drawAtPoint:CGPointMake(0,0)];
image = UIGraphicsGetImageFromCurrentImageContext();
UIGraphicsEndImageContext();
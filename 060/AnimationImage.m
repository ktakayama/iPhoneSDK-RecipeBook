// 「レシピ060: UIImageViewをアニメーション表示する」のサンプルコード (P.137)

CGRect rect = CGRectMake(60.0f, 140.0f, 200.0f, 200.0f);
UIImageView* imageView = [[UIImageView alloc] initWithFrame:rect];
[self.view addSubview:imageView];

// アニメーションさせる画像を配列で用意する
NSArray* images = [NSArray arrayWithObjects:
                       [UIImage imageNamed:@"1.png"],
                       [UIImage imageNamed:@"2.png"],
                       [UIImage imageNamed:@"3.png"],
                       [UIImage imageNamed:@"4.png"],
                       [UIImage imageNamed:@"5.png"],
                       nil
                  ];

// アニメーション表示する画像配列
imageView.animationImages = images;
// アニメーションの1サイクルにかかる時間
imageView.animationDuration = 1.5f;
// アニメーションの繰り返し回数
imageView.animationRepeatCount = 1;
// アニメーションの開始
[imageView startAnimating];

[images release];
[imageView release];
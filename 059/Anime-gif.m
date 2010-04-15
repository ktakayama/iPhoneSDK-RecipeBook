// 「レシピ059: アニメーションGIFを簡単に表示する」のサンプルコード (P.136)

// 表示位置とサイズを生成
CGRect frame = CGRectMake(50,50,0,0);
frame.size = [UIImage imageNamed:@"anim.gif"].size;

// データの読み込み
NSData *gif = [NSData dataWithContentsOfFile:
    [[NSBundle mainBundle] pathForResource:@"anim" ofType:@"gif"]];

// viewの生成
UIWebView *view = [[UIWebView alloc] initWithFrame:frame];
[view loadData:gif MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];


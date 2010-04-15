// 「レシピ036: ダウンロードして進捗状況をプログレッシブバーに表示する」のサンプルコード (P.76)

#import "ProgressBarViewController.h"

@implementation ProgressBarViewController


- (void) actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	[sheet release];
}

- (IBAction) getData {
	// 改行を入れてプログレスバーを入れるスペースを確保
	sheet = [[UIActionSheet alloc]
			 initWithTitle:@"Now Downloading\n\n\n" 
			 delegate:self 
			 cancelButtonTitle:nil 
			 destructiveButtonTitle:nil 
			 otherButtonTitles:nil];
	// プログレスバーをアクションシートに入れる
	progress = [[UIProgressView alloc]
				initWithFrame:CGRectMake(10, 40, 300, 90)];
	[progress setProgressViewStyle:UIProgressViewStyleDefault];
	[sheet addSubview:progress];
	[progress release];
	
	// URLを指定する
    NSURL* url = [NSURL URLWithString:@"http://www.syuhari.jp/test.zip"];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
	
    // URLコネクションを作る
    [NSURLConnection connectionWithRequest:request delegate:self];
}

// ダウンロード開始時に呼ばれる、総データ量を取得する
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	total = [response expectedContentLength];
	amount = 0;
	buff = [[NSMutableData alloc] initWithLength:total];
	
	// アクションシートを表示
	[progress setProgress:0.0f];
	[sheet showInView:self.view];
	[sheet release];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	// エラー処理
}

// ダウンロード中に呼ばれる、取得したデータ量を計算してプログレスバーを更新する
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[buff appendData:data];
	amount += [data length];
	[progress setProgress:(amount/total)];
}

// ダウンロード終了時に呼ばれる、アクションシートを非表示にする
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	[sheet dismissWithClickedButtonIndex:0 animated:YES];
}

- (void)dealloc {
    [super dealloc];
}

@end
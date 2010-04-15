// 「レシピ105 :Tumblrにファイルを送信する」のサンプルコード (P.277)

@implementation TumblrSample

- (void)connection:(NSURLConnection *)connection
didReceiveResponse:(NSHTTPURLResponse *)response
{
    // 送信終了時に呼ばれる。結果をログに出力
    NSLog(@"connction:%d",[response statusCode]);
    // HTTPステータスコードが送信結果を表す
    // 201 Created - 送信成功
    // 403 Forbidden - メールアドレスまたはパスワードが異常
    // 400 Bad Request - データの形式がおかしい
}

-(void)addRet:(NSMutableData*)body {
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
}
-(void)addBoundary:(NSMutableData*)body boundary:(NSString*)boundary{
    [body appendData:[[NSString stringWithFormat:@"--%@",boundary]
                      dataUsingEncoding:NSUTF8StringEncoding]];
    [self addRet:body];
}
-(void)addField:(NSMutableData*)body key:(NSString*)key
            value:(NSString*)value boundary:(NSString*)boundary{
    [body appendData:[[NSString stringWithFormat:
        @"Content-Disposition: form-data; name=\"%@\"",key]
        dataUsingEncoding:NSUTF8StringEncoding]];
    [self addRet:body];
    [self addRet:body];
    [body appendData:[[NSString stringWithFormat:@"%@",value]
        dataUsingEncoding:NSUTF8StringEncoding]];
    [self addRet:body];
}
-(void) uploadImage:(NSString*)path email:(NSString*)email
           password:(NSString*)password {
    // typeに指定可能なものはregular, quote, photo, link, chat, video, audio
    // typeにより必要な属性値が異なる。詳細はTumblrのAPIを参照
    NSString *type = @"photo";

    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:
        [NSURL URLWithString:@"http://www.tumblr.com/api/write"]
        cachePolicy:NSURLRequestUseProtocolCachePolicy
        timeoutInterval:60.0]   ;

    [request setHTTPMethod:@"POST"];

    //Multi-part 形式で送信データを生成
    NSString *boundary = [NSString stringWithString:@"sAmPlE_bOuNdArY"];
    //ヘッダ
    [request addValue:[NSString stringWithFormat:
        @"multipart/form-data; boundary=%@",boundary]
        forHTTPHeaderField: @"Content-Type"];
    //ボディ
    NSMutableData *postBody = [NSMutableData data];
    [self addRet:postBody];
    [self addBoundary:postBody boundary:boundary];

    // 各属性値
    [self addField:postBody key:@"email" value:email boundary:boundary];
    [self addBoundary:postBody boundary:boundary];
    [self addField:postBody key:@"password" value:password
          boundary:boundary];
    [self addBoundary:postBody boundary:boundary];
    [self addField:postBody key:@"type" value:type boundary:boundary];
    [self addBoundary:postBody boundary:boundary];

    // 画像データ用のパート
    [postBody appendData:[[NSString stringWithString:
        @"Content-Disposition: form-data; name=\"data\""]
        dataUsingEncoding:NSUTF8StringEncoding]];
    [self addRet:postBody];
    [postBody appendData:[[NSString stringWithString:
        @"Content-Type: application/octet-stream"]
        dataUsingEncoding:NSUTF8StringEncoding]];
    [self addRet:postBody];
    [self addRet:postBody];

    // 画像用のデータを生成
    NSData *imageData = [NSData dataWithContentsOfFile:path];
    [postBody appendData:[NSData dataWithData:imageData]];
    [self addRet:postBody];
    [self addBoundary:postBody boundary:boundary];

     // リクエストに追加して送信
    [request setHTTPBodyStream:[NSInputStream
        inputStreamWithData:postBody]];
    NSURLConnection *connection = [[NSURLConnection alloc]
        initWithRequest:request delegate:self];
}
@end

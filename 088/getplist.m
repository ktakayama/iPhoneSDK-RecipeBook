// 「レシピ088: インターネット上のplistファイルを取得する」のサンプルコード (P.211)

#define DidDownloadedNotification @"DidDownloadedNotification"
#define DictionaryURL @"http://www.example.com/datafile.plist"

- (void) someMethod {
    // 通知オブジェクトの作成
    [[NSNotificationCenter defaultCenter] addObserver:self
        selector:@selector(didDownloadDictionary:)
        name:DidDownloadedNotification object:nil];

    // 呼び出し
    [self performSelectorInBackground:@selector(loadFile) withObject:nil];
}

- (void) loadFile {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    // ダウンロード&NSDictionary化
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfURL:
        [NSURL URLWithString:DictionaryURL]];

    [[NSNotificationCenter defaultCenter]
        postNotificationName:DidDownloadedNotification
        object:self userInfo:dict];
    [pool release];
}

- (void) didDownloadDictionary:(NSNotification *)info {
    // 結果を受けとる
    NSDictionary *dict = [info userInfo];
    NSLog(@"%@", dict);
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}


// 「レシピ076: ムービプレイヤで動画を再生する」のサンプルコード (P.184)

// 動画の再生処理
- (void) playMoive {
    // 再生する動画を指定
    NSString* path;
    path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"m4v"];
    NSURL* url;
    url = [NSURL fileURLWithPath:path];
    // ネット上にある動画を再生する場合はURLで指定
    // url = [NSURL URLWithString:@"http://..."];
    MPMoviePlayerController *player;
    player = [[MPMoviePlayerController alloc] initWithContentURL:url];

    // ムービープレイヤーのスケールモードを設定
    player.scalingMode = MPMovieScalingModeAspectFill;

    // プレロード終了のNotificationを設定
    [[NSNotificationCenter defaultCenter]
        addObserver:self
        selector:@selector(finishPreload:)
        name:MPMoviePlayerContentPreloadDidFinishNotification
        object:player];

    // 再生終了のNotificationを設定
    [[NSNotificationCenter defaultCenter]
        addObserver:self
        selector:@selector(finishPlayback:)
        name:MPMoviePlayerPlaybackDidFinishNotification
        object:player];
}

// 動画の再生終了
- (void) finishPlayback:(NSNotificationCenter *) aNotification {
    MPMoviePlayerController *player = [aNotification object];
    [[NSNotificationCenter defaultCenter]
        removeObserver:self
        name:MPMoviePlayerPlaybackDidFinishNotification
        object:player];
    [player stop];
    [player release];
}

// 動画のプレロード終了
- (void) finishPreload:(NSNotificationCenter *) aNotification {
    MPMoviePlayerController *player = [aNotification object];
    [[NSNotificationCenter defaultCenter]
        removeObserver:self
        name:MPMoviePlayerContentPreloadDidFinishNotification
        object:player];
    [player play];
}
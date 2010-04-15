// 「レシピ082: 近接センサーを使う」のサンプルコード (P.196)

- (void)applicationDidFinishLaunching:(UIApplication *)application {
    [window makeKeyAndVisible];

    // 近接センサーを有効にする
    [UIDevice currentDevice].proximityMonitoringEnabled = YES;

    // 近接センサーの状態変化を受け取る
    [[NSNotificationCenter defaultCenter]
        addObserver:self
        selector:@selector(changeProximity)
        name:UIDeviceProximityStateDidChangeNotification
        object:nil];

}

// 近接センサーの状態に変化が合った場合に呼ばれる
-(void)changeProximity {
    // センサーに近づいた時 YES、離れた時に NO
    BOOL status = [UIDevice currentDevice].proximityState;
    NSLog(@"proximityState = %d", status);
}
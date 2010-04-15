// 「レシピ032: Transition Animationを途中で止める」のサンプルコード (P.70)

- (void)applicationDidFinishLaunching:(UIApplication *)application {
    [window makeKeyAndVisible];
    mode = false;

    v = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,480)];
    v.backgroundColor  = [UIColor blueColor];
    [window addSubview:v];

    [self action];
}

- (void) action {
    mode = !mode;
    v.hidden = mode;

    CATransition *transition = [CATransition animation];
    [transition setDuration:0.50f];
    [transition setFillMode:kCAFillModeBoth];

    // アニメーション完了後に対象を消去するかどうか
    [transition setRemovedOnCompletion:NO];

    if(mode) {
        [transition setType:@"pageCurl"];
        // アニメーションの停止位置
        [transition setEndProgress:0.6f];
    } else {
        [transition setType:@"pageUnCurl"];
        // アニメーションの開始位置
        [transition setStartProgress:0.4f];
    }
    [[v layer] addAnimation:transition forKey:@"SomeAnim"];
    [self performSelector:@selector(action) withObject:nil afterDelay:1.0f];
}


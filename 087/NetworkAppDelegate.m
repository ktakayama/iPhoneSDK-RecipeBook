// 「レシピ087: ネットワークの接続状況を判定する」のサンプルコード (P.208)

@implementation NetworkAppDelegate

- (void) reachabilityChanged: (NSNotification* )note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);

    if(curReach == wifiReach) {
        if ([curReach currentReachabilityStatus]==ReachableViaWiFi) {
            // Wifiで接続中
        } else {
            // Wifi未接続
        }
    }
}

- (void)applicationDidFinishLaunching:(UIApplication *)application {
    [window makeKeyAndVisible];

    [[NSNotificationCenter defaultCenter]
       addObserver: self selector: @selector(reachabilityChanged:)
       name: kReachabilityChangedNotification object: nil];

    wifiReach = [[Reachability reachabilityForLocalWiFi] retain];
    [wifiReach startNotifer];
}


- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
// 「レシピ087: ネットワークの接続状況を判定する」のサンプルコード (P.208)

Reachability* hostReach =
    [Reachability reachabilityWithHostName: @"example.com"];
switch ([hostReach currentReachabilityStatus]) {
    case NotReachable:
        // 接続不可
        break;
    case ReachableViaWWAN:
        // 3G回線で接続中
        break;
    case ReachableViaWiFi:
        // Wifiで接続中
        break;
}
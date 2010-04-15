// 「レシピ0100: JSONライブラリを使う」のサンプルコード (P.250)

#import "JSON.h"

// Twitterのフレンドタイムラインを取得するAPIのURL
#define FRIEND_TIMELINE_URL
        @"http://%@:%@@twitter.com/statuses/friends_timeline.json"
// TwitterのUSER ID
#define USER_ID @"userid"
// Twitterのパスワード
#define PASSWORD @"password"

/**
 * Twitterのフレンドタイムラインを取得してユーザ名とつぶやきを表示する
 */
- (void) getTwitterTimeLine {
    // Twitter APIのURL
    NSURL* url;
    url = [NSURL URLWithString:
        [NSString stringWithFormat:FRIEND_TIMELINE_URL, USER_ID, PASSWORD]];
    // Twitter APIを使用してフレンドタイムラインのJSONを取得
    NSString *jsonData;
    jsonData = [[NSString alloc] initWithContentsOfURL:url
                           encoding:NSUTF8StringEncoding error:nil];
    if (jsonData == nil) {
        // エラー処理
    } else {
        // JSONを解析する
        NSArray* jsonItem = [jsonData JSONValue];
        if([jsonItem isKindOfClass:[NSDictionary class]]) {
            NSLog(@"err: %@", [(NSDictionary*)jsonItem objectForKey:@"error"]);
            return;
        }
        NSString* user;
        NSString* tweet;
        for (NSDictionary* tweetJson in jsonItem) {
            // ユーザ名
            user  = [[tweetJson objectForKey:@"user"] objectForKey:@"name"];
            // つぶやきの内容
            tweet = [tweetJson objectForKey:@"text"];
            NSLog(@"%@:%@", user, tweet);
        }
    }
}
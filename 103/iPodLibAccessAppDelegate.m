// 「レシピ103 :iPodライブラリの曲情報を取得する」のサンプルコード (P.267)

#import "iPodLibAccessAppDelegate.h"
#import "iPodLibAccessViewController.h"

#import <MediaPlayer/MediaPlayer.h>

@implementation iPodLibAccessAppDelegate

-(void)printMediaItem:(MPMediaItem*)item mediaTypes:(MPMediaType)mediaTypes{
    if (mediaTypes == MPMediaTypeMusic) {
        // Disk番号の個数が2以上なら、Disk番号を出力
        NSString *diskNumString = @"";
        int diskNum = [(NSNumber*)[item valueForProperty:
                                   MPMediaItemPropertyDiscCount] intValue];
        if (diskNum>1) {
            diskNumString = [NSString stringWithFormat:@"disk%02d:",diskNum];
        }
        // 曲情報を出力
        NSLog(@"  [%@%2d] : %@ (%@) Rating:%d",
            diskNumString,
            [(NSNumber*)[item valueForProperty:
                         MPMediaItemPropertyAlbumTrackNumber] intValue],
            [item valueForProperty:MPMediaItemPropertyTitle],
            [item valueForProperty:MPMediaItemPropertyArtist],
            [(NSNumber*)[item valueForProperty:
                         MPMediaItemPropertyRating] intValue]);
    }else {
        // 音楽以外（PodCast等）の場合の情報出力
        NSLog(@"  %@ (%@)",
            [item valueForProperty:MPMediaItemPropertyTitle],
            [item valueForProperty:MPMediaItemPropertyArtist]);
    }
}

-(void)printAlbums {
    // 曲情報を検索するためのクエリを作成
    MPMediaQuery *mediaquery = [[MPMediaQuery alloc] init];

    // 曲名に"Heart"が含まれる(部分一致)という条件を追加
    if ([MPMediaItem canFilterByProperty:MPMediaItemPropertyTitle]) {
        [mediaquery addFilterPredicate:
            [MPMediaPropertyPredicate predicateWithValue: @"Heart"
            forProperty: MPMediaItemPropertyTitle
            comparisonType: MPMediaPredicateComparisonContains]];
    }

    // グループ・ソートの条件をアーティスト・アルバム別に設定
    // ソートの並び順は、iTunesと同様にiPhoneのSystem Languageによって多少変化する
    [mediaquery setGroupingType: MPMediaGroupingAlbumArtist];

    // 検索結果を取得する
    NSArray *collections = [mediaquery collections];

    // 検索結果をログに出力する
    for (MPMediaItemCollection *collection in collections) {
        // アルバムの情報を出力
        MPMediaItem *repItem = collection.representativeItem;
        NSLog(@"Group Title:%@",
              [repItem valueForProperty:MPMediaItemPropertyAlbumTitle]);
        NSLog(@"Group Artist:%@",
              [repItem valueForProperty:MPMediaItemPropertyAlbumArtist]);

        switch (collection.mediaTypes) {
            case MPMediaTypeMusic:
                NSLog(@"Group Type:Music");
                break;
            case MPMediaTypePodcast:
                NSLog(@"Group Type:Podcast");
                break;
            case MPMediaTypeAudioBook:
                NSLog(@"Group Type:AudioBook");
                break;
            default:
                NSLog(@"Group Type:Other");
                break;
        }

        for (MPMediaItem *item in collection.items) {
            // 曲別の情報を出力
            [self printMediaItem:item mediaTypes:collection.mediaTypes];
        }
    }
}

- (void) iPodLibraryChanged:(id)notification {
    NSLog(@"iPodLibrary Changed !!");
    // 画面に曲を表示している場合は、ここで曲情報を再読み込みすること
}

- (void)applicationDidFinishLaunching:(UIApplication *)application {
    UIButton *printAlbums =
    [[UIButton buttonWithType:UIButtonTypeRoundedRect]autorelease];
    [printAlbums retain];
    [printAlbums setTitle:@"Album" forState:UIControlStateNormal];
    [printAlbums setFrame:CGRectMake(4,60,100,44)];
    [printAlbums addTarget:self
                       action:@selector(printAlbums)
             forControlEvents:UIControlEventTouchUpInside];
    [viewController.view addSubview:printAlbums];

    // アプリケーションの動作中に、ユーザ同期を行いiPodライブラリが変化したら通知する
    [[NSNotificationCenter defaultCenter]
     addObserver: self
     selector:    @selector (iPodLibraryChanged:)
     name:        MPMediaLibraryDidChangeNotification
     object:      [MPMediaLibrary defaultMediaLibrary]];
    [[MPMediaLibrary defaultMediaLibrary]
     beginGeneratingLibraryChangeNotifications];

    // Override point for customization after app launch
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
}

- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}
@end


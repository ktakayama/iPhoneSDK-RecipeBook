// 「レシピ104 :iPodで再生中の曲を操作する」のサンプルコード (P.270)

#import <MediaPlayer/MediaPlayer.h>

@interface SimpleMusicPlayerView : UIView {
    MPMusicPlayerController* musicPlayer;

    UIImageView *artworksView;
    UILabel *titleLabel;
    UILabel *artistLabel;
    UILabel *playTimerLabel;
}
- (MPMusicPlaybackState )getPlaybackState;
- (void)setQueueWithQuery:(MPMediaQuery *)query;
- (void)nowPlayingItemChanged:(id)notification;
@end

@implementation SimpleMusicPlayerView
-(MPMusicPlaybackState)getPlaybackState {
    return musicPlayer.playbackState;
}
-(void)refleshTimer {
    if (musicPlayer.nowPlayingItem) {
        NSTimeInterval t = musicPlayer.currentPlaybackTime;
        int min = t/60;
        int sec = t-(min*60);
        playTimerLabel.text =
            [NSString stringWithFormat:@"%02d:%02d",min,sec];
    }else {
        playTimerLabel.text = @"--:--";
    }
}
-(void)refleshView {
    if (musicPlayer.nowPlayingItem) {
        titleLabel.text =
            [musicPlayer.nowPlayingItem
             valueForProperty:MPMediaItemPropertyTitle];
        artistLabel.text =
            [musicPlayer.nowPlayingItem
             valueForProperty:MPMediaItemPropertyArtist];
        MPMediaItemArtwork *artwork =
            [musicPlayer.nowPlayingItem
             valueForProperty:MPMediaItemPropertyArtwork];
        if (artwork) {
            artworksView.image =
                [artwork imageWithSize: artworksView.bounds.size];
        }else {
            artworksView.image = nil;
        }
    }
}
- (void)setQueueWithQuery:(MPMediaQuery *)query {
    [musicPlayer setQueueWithQuery:query];

    //再生・停止中はnowPlayingItemが更新されないので、一瞬だけ再生する
    if (musicPlayer.playbackState == MPMusicPlaybackStateStopped) {
        [musicPlayer play];
        [musicPlayer pause];
        [self refleshView];
    }

}
-(void)playMusic {
    // 再生
    [musicPlayer endSeeking];
    [musicPlayer play];
}
-(void)pauseMusic {
    // 停止
    [musicPlayer endSeeking];
    [musicPlayer pause];
}

-(void)seekBackwardMusic {
    // 巻き戻し
    [musicPlayer beginSeekingBackward];
}
-(void)seekForwardMusic {
    // 早送り
    [musicPlayer beginSeekingForward];
}
-(void)rewindMusic {
    // 前の曲へ戻る
    [musicPlayer skipToPreviousItem];
}
-(void)forwardMusic {
    // 次の曲へ進む
    [musicPlayer skipToNextItem];
}

- (void)nowPlayingItemChanged: (id) notification {
    [self refleshView];
}

-(id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        CGFloat width = frame.size.width;
        CGFloat height = frame.size.height;
        self.backgroundColor = [UIColor whiteColor];

        UIToolbar *toolBar =
        [[UIToolbar alloc]initWithFrame:
         CGRectMake(0,height-44,width,44)];
        NSMutableArray *items = [NSMutableArray array];
        [items addObject:[[UIBarButtonItem alloc]
            initWithBarButtonSystemItem:UIBarButtonSystemItemPlay
            target:self action:@selector(playMusic)]];
        [items addObject:[[UIBarButtonItem alloc]
            initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
            target:self action:nil]];
        [items addObject:[[UIBarButtonItem alloc]
            initWithBarButtonSystemItem:UIBarButtonSystemItemPause
            target:self action:@selector(pauseMusic)]];
        [items addObject:[[UIBarButtonItem alloc]
            initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
            target:self action:nil]];
        [items addObject:[[UIBarButtonItem alloc]
            initWithTitle:@"<<"
            style:UIBarButtonItemStylePlain
            target:self action:@selector(seekBackwardMusic)]];
        [items addObject:[[UIBarButtonItem alloc]
            initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
            target:self action:nil]];
        [items addObject:[[UIBarButtonItem alloc] initWithTitle:@">>"
            style:UIBarButtonItemStylePlain
            target:self action:@selector(seekForwardMusic)]];
        [items addObject:[[UIBarButtonItem alloc]
            initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
            target:self action:nil]];
        [items addObject:[[UIBarButtonItem alloc]
            initWithBarButtonSystemItem:UIBarButtonSystemItemRewind
            target:self action:@selector(rewindMusic)]];
        [items addObject:[[UIBarButtonItem alloc]
            initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
            target:self action:nil]];
        [items addObject:[[UIBarButtonItem alloc]
            initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward
            target:self action:@selector(forwardMusic)]];
        toolBar.items = items;
        [self addSubview:toolBar];

        // ボリュームコントローラ
        MPVolumeView *systemVolumeSlider =
            [[MPVolumeView alloc] initWithFrame:
            CGRectMake(20,height-88,width-40,44)];
        [self addSubview: systemVolumeSlider];
        [systemVolumeSlider release];

        // 曲情報
        titleLabel = [[UILabel alloc]
                      initWithFrame:CGRectMake(10,0,width-100,30)];
        [self addSubview:titleLabel];
        artistLabel = [[UILabel alloc]
                       initWithFrame:CGRectMake(10,30,width-100,30)];
        [self addSubview:artistLabel];
        playTimerLabel = [[UILabel alloc]
                          initWithFrame:CGRectMake(10,60,width-100,30)];
        [self addSubview:playTimerLabel];
        artworksView = [[UIImageView alloc]
                        initWithFrame:CGRectMake(width-90,0,80,80)];
        [self addSubview:artworksView];

        // instantiate a music player
        musicPlayer =
        [MPMusicPlayerController iPodMusicPlayer];
        //[MPMusicPlayerController applicationMusicPlayer];


        musicPlayer.shuffleMode = MPMusicShuffleModeOff;

        [[NSNotificationCenter defaultCenter]
         addObserver: self
         selector: @selector (nowPlayingItemChanged:)
         name: MPMusicPlayerControllerNowPlayingItemDidChangeNotification
         object: musicPlayer];
        [musicPlayer beginGeneratingPlaybackNotifications];

        [NSTimer scheduledTimerWithTimeInterval:1.0
                                         target:self
                                       selector:@selector(refleshTimer)
                                       userInfo:nil
                                        repeats:YES];
        [self refleshView];
    }
    return self;
}

-(void) dealloc {
    [musicPlayer endGeneratingPlaybackNotifications];
    [[NSNotificationCenter defaultCenter]
     removeObserver: self
     name: MPMusicPlayerControllerNowPlayingItemDidChangeNotification
     object: musicPlayer];

    [artworksView release];
    [titleLabel release];
    [artistLabel release];
    [playTimerLabel release];

    [musicPlayer release];
    [super dealloc];
}
@end

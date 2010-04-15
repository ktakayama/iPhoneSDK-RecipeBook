// 「レシピ071: 音を感知するスイッチを作る」のサンプルコード (P.168)

#import "AudioLevelViewController.h"

@implementation AudioLevelViewController

// VoiceSwitchの状態が変化すると呼ばれる
- (void) changeVoiceSwitch:(BOOL) isVoice {
    if (isVoice) {
        NSLog(@"Voice ON");
    } else {
        NSLog(@"Voice OFF");
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    voiceSwitch = [[VoiceSwitch alloc] init];
    voiceSwitch.delegate = self;
    [voiceSwitch start];
}

- (void)dealloc {
    [voiceSwitch release];
    [super dealloc];
}

@end
// 「レシピ071: 音を感知するスイッチを作る」のサンプルコード (P.168)

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AudioToolbox/AudioFile.h>

#define NUM_BUFFERS 3
#define SWITCH_LEVEL -30.0f     // 音声スイッチの閾値

@interface VoiceSwitch : NSObject {
    id delegate;
    AudioStreamBasicDescription dataFormat;
    AudioQueueRef queue;
    AudioQueueBufferRef buffers[NUM_BUFFERS];
    BOOL isOn;
}

@property AudioQueueRef queue;
@property (nonatomic, assign) id delegate;
@property BOOL isOn;

- (id) init;
- (void) start;
- (void) stop;

static void AudioInputCallback(
                void* inUserData,
                AudioQueueRef inAQ,
                AudioQueueBufferRef inBuffer,
                const AudioTimeStamp *inStartTime,
                UInt32 inNumberPacketDescriptions,
                const AudioStreamPacketDescription *inPacketDescs
                );

@end

@interface NSObject (VoiceSwitchDelegate)
- (void)changeVoiceSwitch:(BOOL) isVoice;
@end
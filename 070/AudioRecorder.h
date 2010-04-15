// 「レシピ070: AudioQueueでマイクから録音する」のサンプルコード (P.164)

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AudioToolbox/AudioFile.h>

#define NUM_BUFFERS 3

@interface AudioRecorder : NSObject {
    AudioFileID audioFile;
    AudioStreamBasicDescription dataFormat;
    AudioQueueRef queue;
    AudioQueueBufferRef buffers[NUM_BUFFERS];
    CFURLRef fileURL;
    SInt64 currentPacket;
    BOOL isRecording;
}

@property AudioQueueRef queue;
@property SInt64 currentPacket;
@property AudioFileID audioFile;
@property BOOL isRecording;

- (id) init;
- (void) record;
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
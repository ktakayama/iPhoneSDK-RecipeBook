// 「レシピ072: OpenALで再生する」のサンプルコード (P.173)

#import <Foundation/Foundation.h>
#import <OpenAL/al.h>
#import <OpenAL/alc.h>
#import "MyOpenALSupport.h"

@interface OpenPlayer : NSObject {
    ALCdevice* device;
    ALCcontext* context;
    ALuint sourceID;
    ALuint bufferID;
}

- (void) prepareSound:(CFURLRef) url;
- (void) play;
- (void) stop;
- (void) setVolume:(float)volume;

@end
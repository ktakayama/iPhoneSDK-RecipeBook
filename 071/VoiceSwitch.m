// 「レシピ071: 音を感知するスイッチを作る」のサンプルコード (P.168)

@implementation VoiceSwitch

@synthesize queue, delegate, isOn;

static void AudioInputCallback(
                void* inUserData,
                AudioQueueRef inAQ,
                AudioQueueBufferRef inBuffer,
                const AudioTimeStamp *inStartTime,
                UInt32 inNumberPacketDescriptions,
                const AudioStreamPacketDescription *inPacketDescs) {
    VoiceSwitch* voiceSwitch = (VoiceSwitch*) inUserData;
    AudioQueueEnqueueBuffer(voiceSwitch.queue,inBuffer,0,nil);

    if ([voiceSwitch.delegate
       respondsToSelector:@selector(changeVoiceSwitch:)]) {
        // マイクのレベルを取得する
        AudioQueueLevelMeterState levelMeter;
        UInt32 levelMeterSize = sizeof(AudioQueueLevelMeterState);
        AudioQueueGetProperty(inAQ,kAudioQueueProperty_CurrentLevelMeterDB,
                                              &levelMeter,&levelMeterSize);

        // 一定レベル以上ならON/OFFを切り替える
        float peak = levelMeter.mPeakPower;
        if (!voiceSwitch.isOn && peak > SWITCH_LEVEL) {
            [voiceSwitch.delegate changeVoiceSwitch:YES];
            voiceSwitch.isOn = YES;
        } else if (voiceSwitch.isOn && peak < SWITCH_LEVEL) {
            [voiceSwitch.delegate changeVoiceSwitch:NO];
            voiceSwitch.isOn = NO;
        }
    }

}

-(id) init {
    isOn = NO;
    dataFormat.mSampleRate = 44100.0f;
    dataFormat.mFormatID = kAudioFormatLinearPCM;
    dataFormat.mFramesPerPacket = 1;
    dataFormat.mChannelsPerFrame = 1;
    dataFormat.mBytesPerFrame = 2;
    dataFormat.mBytesPerPacket = 2;
    dataFormat.mBitsPerChannel = 16;
    dataFormat.mReserved = 0;
    dataFormat.mFormatFlags =
       kLinearPCMFormatFlagIsBigEndian |
       kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsPacked;
    return self;
}

- (void) dealloc {
    AudioQueueFlush(queue);
    AudioQueueStop(queue, NO);

    for(int i = 0; i < NUM_BUFFERS; i++) {
        AudioQueueFreeBuffer(queue, buffers[i]);
    }

    AudioQueueDispose(queue, YES);

    [super dealloc];
}

// レベルの監視を開始する
- (void) start {
    AudioQueueNewInput(&dataFormat,AudioInputCallback,self,
       CFRunLoopGetCurrent(),kCFRunLoopCommonModes,0,&queue);
    AudioQueueStart(queue, NULL);

    for(int i=0; i<NUM_BUFFERS; i++) {
        AudioQueueAllocateBuffer(
          queue,
          (dataFormat.mSampleRate/10.0f)*dataFormat.mBytesPerFrame,
          &buffers[i]);
        AudioQueueEnqueueBuffer(queue,buffers[i],0,nil);
    }

    // レベルメータを有効化する
    UInt32 enabledLevelMeter = true;
    AudioQueueSetProperty(queue,kAudioQueueProperty_EnableLevelMetering,
                                       &enabledLevelMeter,sizeof(UInt32));
}

// レベルの監視を停止する
- (void) stop {
    AudioQueueFlush(queue);
    AudioQueueStop(queue, NO);

    for(int i = 0; i < NUM_BUFFERS; i++) {
        AudioQueueFreeBuffer(queue, buffers[i]);
    }

    AudioQueueDispose(queue, YES);
}

@end

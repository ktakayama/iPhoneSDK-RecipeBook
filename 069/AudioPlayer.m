// 「レシピ069: AudioQueueで再生時のレベルを取得する」のサンプルコード (P.163)

static UInt32 gBufferSizeBytes = 0x10000;

@implementation AudioPlayer

@synthesize queue;

// コールバック関数
static void BufferCallback(void *inUserData, AudioQueueRef inAQ,
  AudioQueueBufferRef buffer) {
    AudioPlayer* player = (AudioPlayer*)inUserData;
    [player  audioQueueOutputWithQueue:inAQ queueBuffer:buffer];
}

- (id) init {
    for(int i=0; i<NUM_BUFFERS; i++) {
        AudioQueueEnqueueBuffer(queue,buffers[i],0,nil);
    }
    return self;
}

- (void) audioQueueOutputWithQueue:(AudioQueueRef)audioQueue
                       queueBuffer:(AudioQueueBufferRef)audioQueueBuffer {
    OSStatus status;

    // パケットデータを読み込む
    UInt32  numBytes;
    UInt32  numPackets = numPacketsToRead;
    status = AudioFileReadPackets(
                audioFile, NO, &numBytes, packetDescs,
                packetIndex, &numPackets, audioQueueBuffer->mAudioData);

    // 読み込みに成功した場合
    if (numPackets > 0) {
        // バッファの大きさを、読み込んだパケットデータのサイズに設定する
        audioQueueBuffer->mAudioDataByteSize = numBytes;

        // バッファをキューに追加する
        status = AudioQueueEnqueueBuffer(
                audioQueue, audioQueueBuffer, numPackets, packetDescs);

        // パケット位置を動かす
        packetIndex += numPackets;
    }

}

-(void) play:(CFURLRef) path {
    UInt32      size, maxPacketSize;
    char        *cookie;
    int         i;
    OSStatus status;

    // オーディオファイルを開く
    status = AudioFileOpenURL(path, kAudioFileReadPermission, 0, &audioFile);
    if (status != noErr) {
        // エラー処理
    }

    // オーディオデータフォーマットを取得する
    size = sizeof(dataFormat);
    AudioFileGetProperty(audioFile, kAudioFilePropertyDataFormat,
                                                   &size, &dataFormat);

    // 再生用のAudioQueueを作成する
    AudioQueueNewOutput(&dataFormat, BufferCallback,
                               self, nil, nil, 0, &queue);

    // パケットの見積りをする
    if (dataFormat.mBytesPerPacket==0 || dataFormat.mFramesPerPacket==0) {
        size = sizeof(maxPacketSize);
        AudioFileGetProperty(audioFile,
          kAudioFilePropertyPacketSizeUpperBound, &size, &maxPacketSize);
        if (maxPacketSize > gBufferSizeBytes) {
            maxPacketSize = gBufferSizeBytes;
        }
        // 単位時間あたりのパケット数
        numPacketsToRead = gBufferSizeBytes / maxPacketSize;
        packetDescs = malloc(
          sizeof(AudioStreamPacketDescription) * numPacketsToRead);
    } else {
        numPacketsToRead = gBufferSizeBytes / dataFormat.mBytesPerPacket;
        packetDescs = nil;
    }

    AudioFileGetPropertyInfo(audioFile,
           kAudioFilePropertyMagicCookieData, &size, nil);
    if (size > 0) {
        cookie = malloc(sizeof(char) * size);
        AudioFileGetProperty(audioFile,
                  kAudioFilePropertyMagicCookieData, &size, cookie);
        AudioQueueSetProperty(queue,
                  kAudioQueueProperty_MagicCookie, cookie, size);
        free(cookie);
    }

    // バッファを作成
    packetIndex = 0;
    for (i = 0; i < NUM_BUFFERS; i++) {
        AudioQueueAllocateBuffer(queue, gBufferSizeBytes, &buffers[i]);
        if ([self readPacketsIntoBuffer:buffers[i]] == 0) {
            break;
        }
    }

    Float32 gain = 1.0;
    AudioQueueSetParameter (
                            queue,
                            kAudioQueueParam_Volume,
                            gain
                            );

    AudioQueueStart(queue, nil);
}

- (UInt32)readPacketsIntoBuffer:(AudioQueueBufferRef)buffer {
    UInt32      numBytes, numPackets;

    // ファイルからパケットを受け取りバッファに入れる
    numPackets = numPacketsToRead;
    AudioFileReadPackets(audioFile, NO, &numBytes, packetDescs,
                       packetIndex, &numPackets, buffer->mAudioData);
    if (numPackets > 0) {
        buffer->mAudioDataByteSize = numBytes;
        AudioQueueEnqueueBuffer(queue, buffer,
              (packetDescs ? numPackets : 0), packetDescs);
        packetIndex += numPackets;
    }
    return numPackets;
}

-(void)initMeter {
    UInt32 enabledLevelMeter = true;
    AudioQueueSetProperty(
        queue,kAudioQueueProperty_EnableLevelMetering,&enabledLevelMeter,
        sizeof(UInt32));
}

-(void)logMeter {
    AudioQueueLevelMeterState levelMeter[2];
    UInt32 levelMeterSize = sizeof(AudioQueueLevelMeterState)*2;
    AudioQueueGetProperty(inAQ,kAudioQueueProperty_CurrentLevelMeterDB,
                                            &levelMeter,&levelMeterSize);

    NSLog(@"L: peak=%f, avg=%f",
        levelMeter[0].mPeakPower, levelMeter[0].mAveragePower);
    NSLog(@"R: peak=%f, avg=%f",
        levelMeter[1].mPeakPower, levelMeter[1].mAveragePower);
}

@end
// 「レシピ070: AudioQueueでマイクから録音する」のサンプルコード (P.164)

@implementation AudioRecorder

@synthesize queue, currentPacket, audioFile, isRecording;

// コールバック関数
static void AudioInputCallback(
                void* inUserData,
                AudioQueueRef inAQ,
                AudioQueueBufferRef inBuffer,
                const AudioTimeStamp *inStartTime,
                UInt32 inNumberPacketDescriptions,
                const AudioStreamPacketDescription *inPacketDescs)
{
    AudioRecorder* recorder = (AudioRecorder*) inUserData;

    // ファイルへデータを書き込む
    OSStatus status = AudioFileWritePackets(
                                recorder.audioFile,
                                NO,
                                inBuffer->mAudioDataByteSize,
                                inPacketDescs,
                                recorder.currentPacket,
                                &inNumberPacketDescriptions,
                                inBuffer->mAudioData);

    if (status == noErr) {
        // 書き込み位置を書き込んだパケット分進める
        recorder.currentPacket += inNumberPacketDescriptions;
        // エンキューする
        AudioQueueEnqueueBuffer(recorder.queue,inBuffer,0,nil);
    }
}

// 初期化処理
-(id) init {
    // 記録するデータフォーマットを決める
    isRecording = NO;
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

// 録音開始処理
- (void) record {
    // ファイルへ保存するのでファイル名を決める
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
                       NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath =
       [NSString stringWithFormat:@"%@/record.aiff", documentsDirectory];
    fileURL = CFURLCreateFromFileSystemRepresentation(NULL,
       (const UInt8 *)[filePath UTF8String], [filePath length], NO);

    currentPacket = 0;
    isRecording = YES;

    // 録音用のAudioQueueを作成する
    AudioQueueNewInput(&dataFormat,AudioInputCallback,self,
       CFRunLoopGetCurrent(),kCFRunLoopCommonModes,0,&queue);
    // ファイルを作成する
    AudioFileCreateWithURL(fileURL, kAudioFileAIFFType, &dataFormat,
       kAudioFileFlags_EraseFile, &audioFile);

    UInt32 cookieSize;

    if (AudioQueueGetPropertySize (queue,kAudioQueueProperty_MagicCookie,
                                                   &cookieSize) == noErr) {
        char* magicCookie = (char *) malloc (cookieSize);
        free (magicCookie);
    }

    // バッファの作成
    for(int i=0; i<NUM_BUFFERS; i++) {
        AudioQueueAllocateBuffer(
          queue,
          (dataFormat.mSampleRate/10.0f)*dataFormat.mBytesPerFrame,
          &buffers[i]);
        AudioQueueEnqueueBuffer(queue,buffers[i],0,nil);
    }

    // 録音を開始する
    AudioQueueStart(queue, NULL);
}

// 録音停止処理
- (void) stop {
    // キューを空にしてファイルを閉じる
    isRecording = NO;
    AudioQueueFlush(queue);
    AudioQueueStop(queue, NO);

    for(int i = 0; i < NUM_BUFFERS; i++) {
        AudioQueueFreeBuffer(queue, buffers[i]);
    }

    AudioQueueDispose(queue, YES);
    AudioFileClose(audioFile);
}

@end
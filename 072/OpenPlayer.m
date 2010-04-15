// 「レシピ072: OpenALで再生する」のサンプルコード (P.173)

@implementation OpenPlayer

- (id) init {
    // OpenALデバイスを開く
    device = alcOpenDevice(NULL);
    // OpenALコンテキストを作成
    context = alcCreateContext(device, NULL);
    // コンテキストをアクティブにする
    alcMakeContextCurrent(context);

    //リスナーの位置
    float position[3] = {0.0f, 0.0f, 0.0f};
    alListenerfv(AL_POSITION, position);

    // リスナーの方向
    float orient[6] = {0.0f, 0.0f, 1.0f, 0.0f, 1.0f, 0.0f};
    alListenerfv(AL_ORIENTATION, orient);

    return self;
}

- (void) prepareSound:(CFURLRef) url {
    ALenum outDataFormat;
    ALsizei outDataSize;
    ALsizei outSampleRate;

    // リニアPCMに変換
    char *buffer =
       MyGetOpenALAudioData(url, &outDataSize, &outDataFormat, &outSampleRate);

    // バッファを生成
    alGenBuffers(1, &bufferID);

    // データをバッファにロード
    alBufferData(bufferID, outDataFormat, buffer, outDataSize, outSampleRate);

    // ソースを生成
    alGenSources(1, &sourceID);

    // バッファをソースに対応させる
    alSourcei(sourceID, AL_BUFFER, bufferID);

    // 原点に配置
    alSource3f(sourceID, AL_POSITION, 0.0f, 0.0f, 0.0f);
}

- (void) play {
    alSourcePlay(sourceID);
}

- (void) stop {
    alSourceStop(sourceID);
}

- (void) setVolume:(float) volume {
    alSourcef(sourceID, AL_GAIN, volume);
}

@end
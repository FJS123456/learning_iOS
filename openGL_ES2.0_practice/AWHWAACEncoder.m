//
//  AWHWAACEncoder.m
//  openGL_ES2.0_practice
//
//  Created by 符吉胜 on 2018/8/17.
//  Copyright © 2018年 符吉胜. All rights reserved.
//

#import "AWHWAACEncoder.h"
#import <VideoToolbox/VideoToolbox.h>
#import "AWEncoderManager.h"

@interface AWHWAACEncoder()

@property (nonatomic,strong) NSData *curFramePcmData;
@property (nonatomic,assign) AudioConverterRef aConverter;
@property (nonatomic,assign) uint32_t aMaxOutputFrameSize;

@property (nonatomic,assign) aw_faac_config faacConfig;

@end

@implementation AWHWAACEncoder

static OSStatus aacEncodeInputDataProc(AudioConverterRef inAudioConverter, UInt32 *ioNumberDataPackets, AudioBufferList *ioData, AudioStreamPacketDescription **outDataPacketDescription, void *inUserData)
{
    NSLog(@"supply audio data = %p",&ioData->mBuffers[0]);
    
    AWHWAACEncoder *hwAacEncoder = (__bridge AWHWAACEncoder *)inUserData;
    if (hwAacEncoder.curFramePcmData) {
        ioData->mBuffers[0].mData = (void *)hwAacEncoder.curFramePcmData.bytes;
        ioData->mBuffers[0].mDataByteSize = (uint32_t)hwAacEncoder.curFramePcmData.length;
        ioData->mNumberBuffers = 1;
        ioData->mBuffers[0].mNumberChannels = (uint32_t)hwAacEncoder.audioConfig.channelCount;
        return noErr;
    }
    return -1;
}

- (aw_flv_audio_tag *)encodePCMDataToFlvTag:(NSData *)pcmData
{
    self.curFramePcmData = pcmData;
    
    AudioBufferList outAudioBufferList = {0};
    outAudioBufferList.mNumberBuffers = 1;
    outAudioBufferList.mBuffers[0].mNumberChannels = (uint32_t)self.audioConfig.channelCount;
    outAudioBufferList.mBuffers[0].mDataByteSize = self.aMaxOutputFrameSize;
    outAudioBufferList.mBuffers[0].mData = malloc(self.aMaxOutputFrameSize);
    
    uint32_t outputDataPacketSize = 1;
    
    NSLog(@"start encode audio = %p",&outAudioBufferList.mBuffers[0]);
    OSStatus status = AudioConverterFillComplexBuffer(_aConverter, aacEncodeInputDataProc, (__bridge void * _Nullable)self, &outputDataPacketSize, &outAudioBufferList, NULL);
    if (status == noErr) {
        NSData *rawAAC = [NSData dataWithBytesNoCopy:outAudioBufferList.mBuffers[0].mData length:outAudioBufferList.mBuffers[0].mDataByteSize];
        //TODO:时间戳计算不清楚
        self.manager.timestamp += 1024 * 1000/self.audioConfig.sampleRate;
        NSLog(@"finish encode audio data = %p,timestamp = %@",&outAudioBufferList.mBuffers[0],@(self.manager.timestamp));
        return aw_encoder_create_audio_tag((int8_t *)rawAAC.bytes, rawAAC.length, (uint32_t)self.manager.timestamp, &_faacConfig);
    } else{
        [self onErrorWithCode:AWEncoderErrorCodeAudioEncoderFailed des:@"aac 编码错误"];
    }
    
    return NULL;
}

- (aw_flv_audio_tag *)createAudioSpecificConfigFlvTag
{
    //AAC Profile 5bits | 采样率 4bits | 声道数 4bits | 其他 3bits(都置为0） |
    //TODO:这些配置不应该写死
    uint8_t profile = kMPEG4Object_AAC_LC;
    uint8_t sampleRate = 4;
    uint8_t chanCfg = 1;
    //TODO: 0xe是怎么得出的
    uint8_t config1 = (profile << 3) | ((sampleRate & 0xe) >> 1);
    uint8_t config2 = ((sampleRate & 0x1) << 7) | (chanCfg << 3);
    
    aw_data *config_data = NULL;
    data_writer.write_uint8(&config_data,config1);
    data_writer.write_uint8(&config_data,config2);
    
    aw_flv_audio_tag *audio_specific_config_tag = aw_encoder_create_audio_specific_config_tag(config_data, &_faacConfig);
    free_aw_data(&config_data);
    return audio_specific_config_tag;
}

- (void)open
{
    //创建audio encode converter
    AudioStreamBasicDescription inputAudioDes = {
        .mFormatID = kAudioFormatLinearPCM,
        .mSampleRate = self.audioConfig.sampleRate,
        .mBitsPerChannel = (uint32_t)self.audioConfig.sampleSize,
        .mFramesPerPacket = 1,
        .mBytesPerFrame = 2,
        .mBytesPerPacket = 2,
        .mChannelsPerFrame = (uint32_t)self.audioConfig.channelCount,
        .mFormatFlags = kLinearPCMFormatFlagIsPacked | kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsNonInterleaved,
        .mReserved = 0
    };
    
    AudioStreamBasicDescription outputAudioDes = {
        .mChannelsPerFrame = (uint32_t)self.audioConfig.channelCount,
        .mFormatID = kAudioFormatMPEG4AAC,
        0
    };
    
    uint32_t outDesSize = sizeof(outputAudioDes);
    AudioFormatGetProperty(kAudioFormatProperty_FormatInfo, 0, NULL, &outDesSize, &outputAudioDes);
    OSStatus status = AudioConverterNew(&inputAudioDes, &outputAudioDes, &_aConverter);
    if (status != noErr) {
        [self onErrorWithCode:AWEncoderErrorCodeCreateAudioConverterFailed des:@"硬编码AAC创建失败"];
    }
    
    //设置码率
    uint32_t aBitrate = (uint32_t)self.audioConfig.bitrate;
    uint32_t aBitrateSize = sizeof(aBitrate);
    status = AudioConverterSetProperty(_aConverter, kAudioConverterEncodeBitRate, aBitrateSize, &aBitrate);
    
    //查询最大输出
    uint32_t aMaxOutput = 0;
    uint32_t aMaxOutputSize = sizeof(aMaxOutput);
    AudioConverterGetProperty(_aConverter, kAudioConverterPropertyMaximumOutputPacketSize, &aMaxOutputSize, &aMaxOutput);
    self.aMaxOutputFrameSize = aMaxOutput;
    if (aMaxOutput == 0) {
        [self onErrorWithCode:AWEncoderErrorCodeAudioConverterGetMaxFrameSizeFailed des:@"AAC 获取最大frame size失败"];
    }
    
}

- (void)close
{
    AudioConverterDispose(_aConverter);
    _aConverter = nil;
    self.curFramePcmData = nil;
    self.aMaxOutputFrameSize = 0;
}

@end

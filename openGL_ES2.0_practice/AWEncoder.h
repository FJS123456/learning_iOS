//
//  AWEncoder.h
//  openGL_ES2.0_practice
//
//  Created by 符吉胜 on 2018/8/17.
//  Copyright © 2018年 符吉胜. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "AWAVConfig.h"
#include "aw_all.h"

typedef enum : NSUInteger {
    AWEncoderErrorCodeVTSessionCreateFailed,
    AWEncoderErrorCodeVTSessionPrepareFailed,
    AWEncoderErrorCodeLockSampleBaseAddressFailed,
    AWEncoderErrorCodeEncodeVideoFrameFailed,
    AWEncoderErrorCodeEncodeCreateBlockBufFailed,
    AWEncoderErrorCodeEncodeCreateSampleBufFailed,
    AWEncoderErrorCodeEncodeGetSpsPpsFailed,
    AWEncoderErrorCodeEncodeGetH264DataFailed,
    
    AWEncoderErrorCodeCreateAudioConverterFailed,
    AWEncoderErrorCodeAudioConverterGetMaxFrameSizeFailed,
    AWEncoderErrorCodeAudioEncoderFailed,
} AWEncoderErrorCode;

@class AWEncoderManager;
@interface AWEncoder : NSObject
@property (nonatomic, weak) AWEncoderManager *manager;
//开始
-(void) open;
//结束
-(void) close;
//错误
-(void) onErrorWithCode:(AWEncoderErrorCode) code des:(NSString *) des;

@end

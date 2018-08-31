//
//  AWEncoderManager.h
//  openGL_ES2.0_practice
//
//  Created by 符吉胜 on 2018/8/17.
//  Copyright © 2018年 符吉胜. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AWVideoEncoder.h"
#import "AWAudioEncoder.h"

typedef enum : NSUInteger {
    AWVideoEncoderTypeNone,
    AWVideoEncoderTypeHWH264,
    AWVideoEncoderTypeSWX264,
} AWVideoEncoderType;

typedef enum : NSUInteger {
    AWAudioEncoderTypeNone,
    AWAudioEncoderTypeHWAACLC,
    AWAudioEncoderTypeSWFAAC,
} AWAudioEncoderType;

@class AWVideoEncoder;
@class AWAudioEncoder;
@class AWAudioConfig;
@class AWVideoConfig;

@interface AWEncoderManager : NSObject

@property (nonatomic,assign) AWAudioEncoderType audioEncoderType;
@property (nonatomic,assign) AWVideoEncoderType videoEncoderType;

@property (nonatomic,strong,readonly) AWVideoEncoder *videoEncoder;
@property (nonatomic,strong,readonly) AWAudioEncoder *audioEncoder;

@property (nonatomic,assign) uint32_t timestamp;

- (void)openWithAudioConfig:(AWAudioConfig *)audioConfig videoConfig:(AWVideoConfig *)videoConfig;
- (void)close;

@end

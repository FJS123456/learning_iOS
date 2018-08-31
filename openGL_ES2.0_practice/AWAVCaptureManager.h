//
//  AWAVCaptureManager.h
//  openGL_ES2.0_practice
//
//  Created by 符吉胜 on 2018/8/17.
//  Copyright © 2018年 符吉胜. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AWAVCapture.h"
#import "AWEncoderManager.h"

typedef enum : NSUInteger {
    AWAVCaptureTypeNone,
    AWAVCaptureTypeSystem,
    AWAVCaptureTypeGPUImage
} AWAVCaptureType;

@interface AWAVCaptureManager : NSObject

@property (nonatomic,assign) AWAVCaptureType captureType;
@property (nonatomic,weak) AWAVCapture *avCapture;

@property (nonatomic,assign) AWAudioEncoderType audioEncoderType;
@property (nonatomic,assign) AWVideoEncoderType videoEncoderType;

@property (nonatomic,strong) AWAudioConfig *audioConfig;
@property (nonatomic,strong) AWVideoConfig *videoConfig;

@end

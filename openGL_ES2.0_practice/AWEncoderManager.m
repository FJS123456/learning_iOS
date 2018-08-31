//
//  AWEncoderManager.m
//  openGL_ES2.0_practice
//
//  Created by 符吉胜 on 2018/8/17.
//  Copyright © 2018年 符吉胜. All rights reserved.
//

#import "AWEncoderManager.h"
#import "AWHWAACEncoder.h"
#import "AWHWH264Encoder.h"
#import "AWSWX264Encoder.h"
#import "AWSWFaacEncoder.h"

@interface AWEncoderManager()

//编码器
@property (nonatomic, strong) AWVideoEncoder *videoEncoder;
@property (nonatomic, strong) AWAudioEncoder *audioEncoder;

@end

@implementation AWEncoderManager

- (void)openWithAudioConfig:(AWAudioConfig *)audioConfig videoConfig:(AWVideoConfig *)videoConfig
{
    switch (self.audioEncoderType) {
        case AWAudioEncoderTypeHWAACLC:
            self.audioEncoder = [[AWHWAACEncoder alloc] init];
            break;
        case AWAudioEncoderTypeSWFAAC:
            self.audioEncoder = [[AWSWFaacEncoder alloc] init];
            break;
            
        default:
            NSLog(@"[E] AWEncoderManager.open please assin for audioEncoderType");
            return;
    }
    
    switch (self.videoEncoderType) {
        case AWVideoEncoderTypeHWH264:
            self.videoEncoder = [[AWHWH264Encoder alloc] init];
            break;
        case AWVideoEncoderTypeSWX264:
            self.videoEncoder = [[AWSWX264Encoder alloc] init];
            break;
            
        default:
            NSLog(@"[E] AWEncoderManager.open please assin for videoEncoderType");
            return;
    }
    
    self.audioEncoder.audioConfig = audioConfig;
    self.videoEncoder.videoConfig = videoConfig;
    
    self.audioEncoder.manager = self;
    self.videoEncoder.manager = self;
    
    [self.audioEncoder open];
    [self.videoEncoder open];
    
    
}
- (void)close
{
    [self.audioEncoder close];
    [self.videoEncoder close];
    
    self.audioEncoder = nil;
    self.videoEncoder = nil;
    
    self.timestamp = 0;
    
    self.audioEncoder = AWAudioEncoderTypeNone;
    self.videoEncoder = AWVideoEncoderTypeNone;
}

@end

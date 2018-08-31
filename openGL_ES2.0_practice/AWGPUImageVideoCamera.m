//
//  AWGPUImageVideoCamera.m
//  openGL_ES2.0_practice
//
//  Created by 符吉胜 on 2018/8/28.
//  Copyright © 2018年 符吉胜. All rights reserved.
//

#import "AWGPUImageVideoCamera.h"

@implementation AWGPUImageVideoCamera

- (void)processAudioSampleBuffer:(CMSampleBufferRef)sampleBuffer
{
    [super processAudioSampleBuffer:sampleBuffer];
    [self.awAudioDelegate processAudioSample:sampleBuffer];
}

- (void)setCaptureSessionPreset:(NSString *)captureSessionPreset
{
    if (!_captureSession || ![_captureSession canSetSessionPreset:captureSessionPreset]) {
        @throw [NSException exceptionWithName:@"Not supported captureSessionPreset" reason:[NSString stringWithFormat:@"captureSessionPreset is [%@]", captureSessionPreset] userInfo:nil];
        return;
    }
    [super setCaptureSessionPreset:captureSessionPreset];
}

@end

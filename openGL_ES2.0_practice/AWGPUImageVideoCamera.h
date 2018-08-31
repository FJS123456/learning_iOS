//
//  AWGPUImageVideoCamera.h
//  openGL_ES2.0_practice
//
//  Created by 符吉胜 on 2018/8/28.
//  Copyright © 2018年 符吉胜. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "GPUImage.h"

@protocol AWGPUImageVideoCameraDelegate <NSObject>

-(void) processAudioSample:(CMSampleBufferRef)sampleBuffer;

@end

@interface AWGPUImageVideoCamera : GPUImageVideoCamera

@property (nonatomic,weak) id<AWGPUImageVideoCameraDelegate> awAudioDelegate;

- (void)setCaptureSessionPreset:(NSString *)captureSessionPreset;

@end

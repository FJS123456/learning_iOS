//
//  AWSystemAVCapture.m
//  openGL_ES2.0_practice
//
//  Created by 符吉胜 on 2018/8/17.
//  Copyright © 2018年 符吉胜. All rights reserved.
//

#import "AWSystemAVCapture.h"
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@interface AWSystemAVCapture ()<AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate>

@property (nonatomic,strong) AVCaptureDeviceInput *frontCamera;
@property (nonatomic,strong) AVCaptureDeviceInput *backCamera;

//当前使用的视频设备
@property (nonatomic,weak) AVCaptureDeviceInput *videoInputDevice;
//音频设备
@property (nonatomic,strong) AVCaptureDeviceInput *audioInputDevice;

//输出数据接收
@property (nonatomic,strong) AVCaptureVideoDataOutput *videoDataOutput;
@property (nonatomic,strong) AVCaptureAudioDataOutput *audioDataOutput;

@property (nonatomic,strong) AVCaptureSession *captureSession;
@property (nonatomic,strong) AVCaptureVideoPreviewLayer *previewLayer;

@end

@implementation AWSystemAVCapture

- (void)switchCamera
{
    if ([self.videoInputDevice isEqual:self.frontCamera]) {
        self.videoInputDevice = self.backCamera;
    } else {
        self.videoInputDevice = self.frontCamera;
    }
}

- (void)onInit
{
    [self createCaptureDevice];
    [self createOutput];
    [self createCaptureSession];
    [self createPreviewLayer];
    
    //更新fps
    [self updateFps: self.videoConfig.fps];
}

- (void)createCaptureDevice
{
    //创建视频设备
    NSArray *videoDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    //初始化摄像头
    self.frontCamera = [AVCaptureDeviceInput deviceInputWithDevice:videoDevices.firstObject error:nil];
    self.backCamera = [AVCaptureDeviceInput deviceInputWithDevice:videoDevices.lastObject error:nil];
    //麦克风
    AVCaptureDevice *audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    self.audioInputDevice = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:nil];
    
    self.videoInputDevice = self.frontCamera;
}

- (void)setVideoInputDevice:(AVCaptureDeviceInput *)videoInputDevice
{
    if ([videoInputDevice isEqual:_videoInputDevice]) {
        return;
    }
    [self.captureSession beginConfiguration];
    if (_videoInputDevice) {
        [self.captureSession removeInput:_videoInputDevice];
    }
    
    [self setVideoOutConfig];
    
    [self.captureSession commitConfiguration];
    
    _videoInputDevice = videoInputDevice;
}

//创建预览
-(void) createPreviewLayer
{
    self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
    self.previewLayer.frame = self.preview.bounds;
    [self.preview.layer addSublayer:self.previewLayer];
}

- (void)setVideoOutConfig
{
    for (AVCaptureConnection *conn in self.videoDataOutput.connections) {
        if (conn.isVideoStabilizationSupported) {
            [conn setPreferredVideoStabilizationMode:AVCaptureVideoStabilizationModeAuto];
        }
        //TODO:代码有问题
        if (conn.isVideoOrientationSupported) {
            [conn setVideoOrientation:AVCaptureVideoOrientationPortrait];
        }
        if (conn.isVideoMirrored) {
            [conn setVideoMirrored: YES];
        }
    }
}

- (void)createCaptureSession
{
    self.captureSession = [AVCaptureSession new];
    
    [self.captureSession beginConfiguration];
    
    if ([self.captureSession canAddInput:self.videoInputDevice]) {
        [self.captureSession addInput:self.videoInputDevice];
    }
    
    if ([self.captureSession canAddInput:self.audioInputDevice]) {
        [self.captureSession addInput:self.audioInputDevice];
    }
    
    if ([self.captureSession canAddOutput:self.videoDataOutput]) {
        [self.captureSession addOutput:self.videoDataOutput];
    }
    
    if ([self.captureSession canAddOutput:self.audioDataOutput]) {
        [self.captureSession addOutput:self.audioDataOutput];
    }
    
    if (![self.captureSession canSetSessionPreset:self.captureSessionPreset]) {
        @throw [NSException exceptionWithName:@"Not supported captureSessionPreset" reason:[NSString stringWithFormat:@"captureSessionPreset is [%@]", self.captureSessionPreset] userInfo:nil];
    }
    
    self.captureSession.sessionPreset = self.captureSessionPreset;
    
    [self.captureSession commitConfiguration];
    [self.captureSession startRunning];
}

- (void)destroyCaptureSession
{
    if (self.captureSession) {
        [self.captureSession removeInput:self.audioInputDevice];
        [self.captureSession removeInput:self.videoInputDevice];
        [self.captureSession removeOutput:self.self.videoDataOutput];
        [self.captureSession removeOutput:self.self.audioDataOutput];
    }
    self.captureSession = nil;
}

- (void)createOutput
{
    dispatch_queue_t captureQueue = dispatch_queue_create("aw.capture.queue", DISPATCH_QUEUE_SERIAL);
    
    self.videoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
    [self.videoDataOutput setSampleBufferDelegate:self queue:captureQueue];
    [self.videoDataOutput setAlwaysDiscardsLateVideoFrames:YES];
    [self.videoDataOutput setVideoSettings:@{(__bridge NSString *)kCVPixelBufferPixelFormatTypeKey : @(kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange)}];
    
    self.audioDataOutput = [[AVCaptureAudioDataOutput alloc] init];
    [self.audioDataOutput setSampleBufferDelegate:self queue:captureQueue];
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate & AVCaptureAudioDataOutputSampleBufferDelegate
- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    if (self.isCapturing) {
        if ([self.videoDataOutput isEqual:output]) {
            [self sendVideoSampleBuffer:sampleBuffer];
        } else {
            [self sendAudioSampleBuffer:sampleBuffer];
        }
    }
}

@end

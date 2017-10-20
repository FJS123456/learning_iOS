//
//  MDGPUImage_005.m
//  openGL_ES2.0_practice
//
//  Created by 符吉胜 on 2017/10/20.
//  Copyright © 2017年 符吉胜. All rights reserved.
//

#import "MDGPUImage_005.h"
#import "GPUimage.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface MDGPUimage_005 ()

@property (nonatomic,strong) GPUImageVideoCamera *videoCamera;
@property (nonatomic,strong) GPUImageOutput<GPUImageInput> *filter;
@property (nonatomic,strong) GPUImageMovieWriter *movieWriter;

@property (nonatomic,strong) GPUImageView *filterView;
@property (nonatomic,strong) UIButton *mButton;
@property (nonatomic,strong) UILabel *mLabel;
@property (nonatomic,strong) UISlider *slider;

@property (nonatomic,assign) long mLabelTime;
@property (nonatomic,strong) NSTimer *mTimer;
@property (nonatomic , strong) CADisplayLink *mDisplayLink;

@end

@implementation MDGPUimage_005

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configUI];
    [self setupCaptureSession];
}

- (void)configUI
{
    self.view = self.filterView;
    [self.view addSubview:self.mButton];
    [self.view addSubview:self.mLabel];
    [self.view addSubview:self.slider];
}

- (void)setupCaptureSession
{
    _videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset1920x1080 cameraPosition:AVCaptureDevicePositionBack];
    _videoCamera.outputImageOrientation = [UIApplication sharedApplication].statusBarOrientation;
    
    _filter = [[GPUImageSepiaFilter alloc] init];
    [_videoCamera addTarget:_filter];
    [_filter addTarget:self.filterView];
    
    [_videoCamera startCameraCapture];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidChangeStatusBarOrientationNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        _videoCamera.outputImageOrientation = [UIApplication sharedApplication].statusBarOrientation;
    }];
    
    self.mDisplayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displaylink:)];
    [self.mDisplayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

- (GPUImageView *)filterView
{
    if (!_filterView) {
        _filterView = [[GPUImageView alloc] initWithFrame:self.view.frame];
    }
    return _filterView;
}

- (UIButton *)mButton
{
    if (!_mButton) {
        _mButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 80, 50, 50)];
        [_mButton setTitle:@"录制" forState:UIControlStateNormal];
        [_mButton sizeToFit];
        [_mButton addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _mButton;
}

- (UILabel *)mLabel
{
    if (!_mLabel) {
        _mLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 120, 50, 100)];
        _mLabel.hidden = YES;
        _mLabel.textColor = [UIColor whiteColor];
    }
    return _mLabel;
}

- (UISlider *)slider
{
    if (!_slider) {
        _slider = [[UISlider alloc] initWithFrame:CGRectMake(10, 200, 100, 40)];
        [_slider addTarget:self action:@selector(updateSliderValue:) forControlEvents:UIControlEventValueChanged];
    }
    return _slider;
}

#pragma mark - 事件处理
- (void)onClick:(UIButton *)btn
{
    NSString *pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Movie4.m4v"];
    NSURL *movieURL = [NSURL fileURLWithPath:pathToMovie];
    if ([btn.currentTitle isEqualToString:@"录制"]) {
        [btn setTitle:@"结束" forState:UIControlStateNormal];
        NSLog(@"start recording");
        unlink([pathToMovie UTF8String]);
        [self setupMovieWriterWithMovieURL:movieURL];
        
        _mLabelTime = 0;
        _mLabel.hidden = NO;
        [self onTimer:nil];
        _mTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
    }
    else {
        [btn setTitle:@"录制" forState:UIControlStateNormal];
        NSLog(@"End recording");
        _mLabel.hidden = YES;
        if (_mTimer) {
            [_mTimer invalidate];
        }
        [_filter removeTarget:_movieWriter];
        _videoCamera.audioEncodingTarget = nil;
        [_movieWriter finishRecording];
        
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(pathToMovie))
        {
            [library writeVideoAtPathToSavedPhotosAlbum:movieURL completionBlock:^(NSURL *assetURL, NSError *error)
             {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     
                     if (error) {
                         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"视频保存失败" message:nil
                                                                        delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                         [alert show];
                     } else {
                         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"视频保存成功" message:nil
                                                                        delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                         [alert show];
                     }
                 });
             }];
        }
        
    }
}

- (void)setupMovieWriterWithMovieURL:(NSURL *)movieURL
{
    _movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(480.0, 640.0)];
    _movieWriter.encodingLiveVideo = NO;
    [_filter addTarget:_movieWriter];
    _videoCamera.audioEncodingTarget = _movieWriter;
    
    [_movieWriter startRecording];
}

- (void)updateSliderValue:(UISlider *)slider
{
    [(GPUImageSepiaFilter *)_filter setIntensity:[slider value]];
}

- (void)displaylink:(CADisplayLink *)displaylink
{
    NSLog(@"test");
}

- (void)onTimer:(id)sender {
    _mLabel.text  = [NSString stringWithFormat:@"录制时间:%lds", _mLabelTime++];
    [_mLabel sizeToFit];
}

@end

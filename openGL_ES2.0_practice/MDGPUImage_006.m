//
//  MDGPUImage_006.m
//  openGL_ES2.0_practice
//
//  Created by 符吉胜 on 2017/10/20.
//  Copyright © 2017年 符吉胜. All rights reserved.
//

#import "MDGPUImage_006.h"
#import "GPUImage.h"
#import <AssetsLibrary/ALAssetsLibrary.h>

@interface MDGPUImage_006 ()

@property (nonatomic,strong) UILabel *mLabel;

@property (nonatomic,strong) GPUImageMovie *movieFile;
@property (nonatomic,strong) GPUImageOutput<GPUImageInput> *filter;
@property (nonatomic,strong) GPUImageMovieWriter *movieWriter;
@property (nonatomic,strong) GPUImageVideoCamera *videoCamera;

@end

@implementation MDGPUImage_006

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    GPUImageView *filterView = [[GPUImageView alloc] initWithFrame:self.view.bounds];
    self.view = filterView;
    
    self.mLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 100, 100)];
    self.mLabel.textColor = [UIColor redColor];
    [self.view addSubview:self.mLabel];
    
    self.filter = [[GPUImageDissolveBlendFilter alloc] init];
    [(GPUImageDissolveBlendFilter *)_filter setMix:0.5];
    
    //play
    NSURL *sampleURL = [[NSBundle bundleForClass:[self class]] URLForResource:@"abc" withExtension:@"mp4"];
    _movieFile = [[GPUImageMovie alloc] initWithURL:sampleURL];
    _movieFile.runBenchmark = YES;
    _movieFile.playAtActualSpeed = YES;
    
    //camera
    _videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionBack];
    _videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    
    NSString *pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Movie.m4v"];
    unlink([pathToMovie UTF8String]);
    NSURL *movieURL = [NSURL fileURLWithPath:pathToMovie];
    
    _movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(640.0F, 480.0)];
    BOOL audioFromFile = NO;
    [_movieWriter setAudioProcessingCallback:^(SInt16 **sampleRef, CMItemCount numSamplesInBuffer) {
        
    }];
    
    //
    if (audioFromFile) {
        [_movieFile addTarget:_filter];
        [_videoCamera addTarget:_filter];
        _movieWriter.shouldPassthroughAudio = YES;
        _movieFile.audioEncodingTarget = _movieWriter;
        [_movieFile enableSynchronizedEncodingUsingMovieWriter:_movieWriter];
    }
    else {
        [_videoCamera addTarget:_filter];
        [_movieFile addTarget:_filter];
        _movieWriter.shouldPassthroughAudio = NO;
        _videoCamera.audioEncodingTarget = _movieWriter;
        _movieWriter.encodingLiveVideo = NO;
    }
    
    //显示到界面
    [_filter addTarget:filterView];
    [_filter addTarget:_movieWriter];
    
    [_videoCamera startCameraCapture];
    [_movieWriter startRecording];
    [_movieFile startProcessing];
    
    CADisplayLink* dlink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateProgress)];
    [dlink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [dlink setPaused:NO];
    
    __weak typeof(self) weakSelf = self;
    [_movieWriter setCompletionBlock:^{
        __strong typeof(self) strongSelf = weakSelf;
        
        [strongSelf.filter removeTarget:strongSelf.movieWriter];
        [strongSelf.movieWriter finishRecording];
        
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
                                                                        delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                         [alert show];
                     }
                 });
             }];
        }
        else {
            NSLog(@"error mssg)");
        }
    }];
}

- (void)updateProgress
{
    self.mLabel.text = [NSString stringWithFormat:@"Progress:%d%%", (int)(_movieFile.progress * 100)];
    [self.mLabel sizeToFit];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
 

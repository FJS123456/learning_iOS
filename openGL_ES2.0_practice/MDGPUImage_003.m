//
//  MDGPUImage_003.m
//  openGL_ES2.0_practice
//
//  Created by 符吉胜 on 2017/10/19.
//  Copyright © 2017年 符吉胜. All rights reserved.
//

#import "MDGPUImage_003.h"
#import "GPUImageBeautifyFilter.h"
#import "GPUImage.h"

@interface MDGPUImage_003 ()

@property (nonatomic,strong) GPUImageVideoCamera *videoCamera;
@property (nonatomic,strong) GPUImageView *filterView;
@property (nonatomic,strong) UIButton *beautifyButton;

@end

@implementation MDGPUImage_003

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionFront];
    self.videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    //??
    self.videoCamera.horizontallyMirrorFrontFacingCamera = YES;
    self.filterView = [[GPUImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.filterView];
    
    [self.videoCamera addTarget:self.filterView];
    [self.videoCamera startCameraCapture];
    
    [self.view addSubview:self.beautifyButton];
}

- (UIButton *)beautifyButton
{
    if (!_beautifyButton) {
        _beautifyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _beautifyButton.frame = CGRectMake(150, 500, 40, 20);
        _beautifyButton.backgroundColor = [UIColor whiteColor];
        [_beautifyButton setTitle:@"开启" forState:UIControlStateNormal];
        [_beautifyButton setTitle:@"关闭" forState:UIControlStateSelected];
        [_beautifyButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_beautifyButton addTarget:self action:@selector(beautify) forControlEvents:UIControlEventTouchUpInside];
    }
    return _beautifyButton;
}

- (void)beautify
{
    if (self.beautifyButton.selected) {
        self.beautifyButton.selected = NO;
        [self.videoCamera removeAllTargets];
        [self.videoCamera addTarget:self.filterView];
    }
    else {
        self.beautifyButton.selected = YES;
        [self.videoCamera removeAllTargets];
        GPUImageBeautifyFilter *beautifyFilter = [[GPUImageBeautifyFilter alloc] init];
        [self.videoCamera addTarget:beautifyFilter];
        [beautifyFilter addTarget:self.filterView];
    }
}

@end

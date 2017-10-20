//
//  MDGPUImage_002.m
//  openGL_ES2.0_practice
//
//  Created by 符吉胜 on 2017/10/18.
//  Copyright © 2017年 符吉胜. All rights reserved.
//

#import "MDGPUImage_002.h"
#import "GPUImage.h"

@interface MDGPUImage_002 ()

@property (nonatomic,strong) UIImageView *mImageView;

@property (nonatomic,strong) GPUImageView *mGPUImageView;
@property (nonatomic,strong) GPUImageVideoCamera *mGPUVideoCamera;

@end

@implementation MDGPUImage_002

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //给一张图片加滤镜
//    [self handleAPicture];
    
    //test GPUImageVideoCamera
    [self handleVideoCamera];
}

- (void)handleAPicture
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:imageView];
    _mImageView = imageView;
    
    GPUImageFilter *imageFilter = [[GPUImageSepiaFilter alloc] init];
    UIImage *image = [UIImage imageNamed:@"face.png"];
    
    if (image) {
        self.mImageView.image = [imageFilter imageByFilteringImage:image];
    }
}

- (void)handleVideoCamera
{
    _mGPUImageView = [[GPUImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_mGPUImageView];
    
    _mGPUVideoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionBack];
    GPUImageSepiaFilter *filter = [[GPUImageSepiaFilter alloc] init];
    [_mGPUVideoCamera addTarget:filter];
    [filter addTarget:_mGPUImageView];
    
    [_mGPUVideoCamera startCameraCapture];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)deviceOrientationDidChange
{
    UIInterfaceOrientation orientation = (UIInterfaceOrientation)[UIDevice currentDevice].orientation;
    self.mGPUVideoCamera.outputImageOrientation = orientation;
}

@end

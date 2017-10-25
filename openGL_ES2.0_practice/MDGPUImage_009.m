//
//  MDGPUImage_009.m
//  openGL_ES2.0_practice
//
//  Created by 符吉胜 on 2017/10/22.
//  Copyright © 2017年 符吉胜. All rights reserved.
//

#import "MDGPUImage_009.h"
#import "GPUImage.h"
#import <AssetsLibrary/ALAssetsLibrary.h>

@interface MDGPUImage_009 ()

@property (nonatomic , strong) UILabel  *mLabel;
@property (nonatomic , strong) UIImageView *mImageView;
//可以接受响应链的图像信息，并且以二进制的格式返回数据
@property (nonatomic , strong) GPUImageRawDataOutput *mOutput;

@end

@implementation MDGPUImage_009
{
    GPUImageVideoCamera *videoCamera;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    GPUImageView *filterView = [[GPUImageView alloc] initWithFrame:self.view.frame];
//    self.view = filterView;
    
    self.mImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.mImageView];
    
    self.mLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 200, 100)];
    self.mLabel.textColor = [UIColor redColor];
    [self.view addSubview:self.mLabel];

    videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionFront];
    videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    videoCamera.horizontallyMirrorFrontFacingCamera = YES;
    
    self.mOutput = [[GPUImageRawDataOutput alloc] initWithImageSize:CGSizeMake(640, 480) resultsInBGRAFormat:YES];
    [videoCamera addTarget:self.mOutput];
    
    __weak typeof(self) wSelf = self;
    __weak typeof(self.mOutput) wOutput = self.mOutput;
    [self.mOutput setNewFrameAvailableBlock:^{
        __strong GPUImageRawDataOutput *strongOutput = wOutput;
        __strong typeof(wSelf) strongSelf = wSelf;
        
        [strongOutput lockFramebufferForReading];
        GLubyte *outputBytes = [strongOutput rawBytesForImage];
        NSInteger bytesPerRow = [strongOutput bytesPerRowInOutput];
        CVPixelBufferRef pixelBuffer = NULL;
        CVReturn ret = CVPixelBufferCreateWithBytes(kCFAllocatorDefault, 640, 480, kCVPixelFormatType_32BGRA, outputBytes, bytesPerRow, nil, nil, nil, &pixelBuffer);
        if (ret != kCVReturnSuccess) {
            NSLog(@"status %d",ret);
        }
        [strongOutput unlockFramebufferAfterReading];
        
        if (pixelBuffer == NULL) {
            return;
        }
        
        //CVPixelBuffer -> CGImage -> UIImage
        
        CGColorSpaceRef rbgColorSpace = CGColorSpaceCreateDeviceRGB();
        CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, strongOutput.rawBytesForImage, bytesPerRow * 480, NULL);
        
        CGImageRef cgImage = CGImageCreate(640, 480, 8, 32, bytesPerRow, rbgColorSpace, kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little, provider, NULL, true, kCGRenderingIntentDefault);
        UIImage *image = [UIImage imageWithCGImage:cgImage];
        
        [strongSelf updateWithImage:image];
        
        CGImageRelease(cgImage);
        CFRelease(pixelBuffer);
    }];
    
    [videoCamera startCameraCapture];
    
    
    CADisplayLink* dlink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateProgress)];
    [dlink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [dlink setPaused:NO];
    
}

- (void)updateWithImage:(UIImage *)image {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.mImageView.image = image;
    });
}

+ (void)convertBGRAtoRGBA:(unsigned char *)data withSize:(size_t)sizeOfData {
    for (unsigned char *p = data; p < data + sizeOfData; p += 4) {
        unsigned char r = *(p + 2);
        unsigned char b = *p;
        *p = r;
        *(p + 2) = b;
    }
}

- (void)updateProgress
{
    self.mLabel.text = [[NSDate dateWithTimeIntervalSinceNow:0] description];
    [self.mLabel sizeToFit];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end

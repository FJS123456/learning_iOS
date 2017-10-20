//
//  MDGPUImage_004.m
//  openGL_ES2.0_practice
//
//  Created by 符吉胜 on 2017/10/19.
//  Copyright © 2017年 符吉胜. All rights reserved.
//

#import "MDGPUImage_004.h"
#import "GPUImage.h"

@interface MDGPUImage_004 ()

@property (nonatomic,strong) GPUImagePicture *sourcePicture;
//模糊滤镜
@property (nonatomic,strong) GPUImageTiltShiftFilter *sepiaFilter;

@end

@implementation MDGPUImage_004

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    GPUImageView *primaryView = [[GPUImageView alloc] initWithFrame:self.view.frame];
    self.view = primaryView;
    
    UIImage *faceImage = [UIImage imageNamed:@"face.png"];
    
    _sourcePicture = [[GPUImagePicture alloc] initWithImage:faceImage];
    
    _sepiaFilter = [[GPUImageTiltShiftFilter alloc] init];
    _sepiaFilter.blurRadiusInPixels = 40.0f;
    [_sepiaFilter forceProcessingAtSize:primaryView.sizeInPixels];
    
    [_sourcePicture addTarget:_sepiaFilter];
    [_sepiaFilter addTarget:primaryView];
    [_sourcePicture processImage];
    
    //设备支持的纹理最大尺寸，超过会报错，glError()
    GLint size = [GPUImageContext maximumTextureSizeForThisDevice];
    //单个片段着色器能访问的纹理单元数
    GLint unit = [GPUImageContext maximumTextureUnitsForThisDevice];
    GLint vector = [GPUImageContext maximumVaryingVectorsForThisDevice];
    NSLog(@"%d %d %d", size, unit, vector);
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    float rate = point.y / self.view.frame.size.height;
    NSLog(@"Processing");
    [_sepiaFilter setTopFocusLevel:rate - 0.1];
    [_sepiaFilter setBottomFocusLevel:rate + 0.1];
    [_sourcePicture processImage];
}

@end

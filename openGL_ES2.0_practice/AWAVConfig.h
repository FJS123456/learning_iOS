//
//  AWAVConfig.h
//  openGL_ES2.0_practice
//
//  Created by 符吉胜 on 2018/8/17.
//  Copyright © 2018年 符吉胜. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "aw_all.h"

@interface AWAudioConfig : NSObject<NSCopying>

@property (nonatomic,assign) NSInteger bitrate;
@property (nonatomic,assign) NSInteger channelCount;
@property (nonatomic,assign) NSInteger sampleRate;
@property (nonatomic,assign) NSInteger sampleSize;  //采样精度，8 or 16

@property (nonatomic, readonly, assign) aw_faac_config faacConfig;

@end

@interface AWVideoConfig : NSObject<NSCopying>
@property (nonatomic, assign) NSInteger width;//可选，系统支持的分辨率，采集分辨率的宽
@property (nonatomic, assign) NSInteger height;//可选，系统支持的分辨率，采集分辨率的高
@property (nonatomic, assign) NSInteger bitrate;//自由设置
@property (nonatomic, assign) NSInteger fps;//自由设置
@property (nonatomic, assign) NSInteger dataFormat;//目前软编码只能是X264_CSP_NV12，硬编码无需设置

//推流方向
@property (nonatomic, assign) UIInterfaceOrientation orientation;

-(BOOL) shouldRotate;

// 推流分辨率宽高，目前不支持自由设置，只支持旋转。
// UIInterfaceOrientationLandscapeLeft 和 UIInterfaceOrientationLandscapeRight 为横屏，其他值均为竖屏。
@property (nonatomic, readonly, assign) NSInteger pushStreamWidth;
@property (nonatomic, readonly, assign) NSInteger pushStreamHeight;

@property (nonatomic, readonly, assign) aw_x264_config x264Config;

@end

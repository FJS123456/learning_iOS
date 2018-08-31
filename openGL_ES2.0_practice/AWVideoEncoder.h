//
//  AWVideoEncoder.h
//  openGL_ES2.0_practice
//
//  Created by 符吉胜 on 2018/8/17.
//  Copyright © 2018年 符吉胜. All rights reserved.
//

#import "AWEncoder.h"

@interface AWVideoEncoder : AWEncoder

@property (nonatomic, copy) AWVideoConfig *videoConfig;

//旋转
-(NSData *)rotateNV12Data:(NSData *)nv12Data;

//编码
-(aw_flv_video_tag *) encodeYUVDataToFlvTag:(NSData *)yuvData;

-(aw_flv_video_tag *) encodeVideoSampleBufToFlvTag:(CMSampleBufferRef)videoSample;

//根据flv，h264，aac协议，提供首帧需要发送的tag
//创建sps pps
-(aw_flv_video_tag *) createSpsPpsFlvTag;

//转换
-(NSData *) convertVideoSmapleBufferToYuvData:(CMSampleBufferRef) videoSample;

@end

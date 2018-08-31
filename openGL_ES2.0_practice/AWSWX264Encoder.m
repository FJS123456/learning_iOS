//
//  AWSWX264Encoder.m
//  openGL_ES2.0_practice
//
//  Created by 符吉胜 on 2018/8/29.
//  Copyright © 2018年 符吉胜. All rights reserved.
//

#import "AWSWX264Encoder.h"
#import "AWEncoderManager.h"

@implementation AWSWX264Encoder
-(aw_flv_video_tag *) encodeYUVDataToFlvTag:(NSData *)yuvData{
    return aw_sw_encoder_encode_x264_data((int8_t *)yuvData.bytes, yuvData.length, self.manager.timestamp + 1);
}

-(aw_flv_video_tag *)createSpsPpsFlvTag{
//    return aw_sw_encoder_create_x264_sps_pps_tag();
    return NULL;
}

-(void) open{
    aw_x264_config x264_config = self.videoConfig.x264Config;
    aw_sw_encoder_open_x264_encoder(&x264_config);
}

-(void)close{
    aw_sw_encoder_close_x264_encoder();
}

@end

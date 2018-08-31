//
//  AWEncoder.m
//  openGL_ES2.0_practice
//
//  Created by 符吉胜 on 2018/8/17.
//  Copyright © 2018年 符吉胜. All rights reserved.
//

#import "AWEncoder.h"

@implementation AWEncoder

-(void) open{
}

-(void)close{
}

-(void) onErrorWithCode:(AWEncoderErrorCode) code des:(NSString *) des{
    aw_log("[ERROR] encoder error code:%ld des:%s", (unsigned long)code, des.UTF8String);
}

@end

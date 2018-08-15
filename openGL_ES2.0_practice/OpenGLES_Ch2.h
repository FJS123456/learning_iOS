//
//  OpenGLES_Ch2.h
//  openGL_ES2.0_practice
//
//  Created by 符吉胜 on 2017/10/25.
//  Copyright © 2017年 符吉胜. All rights reserved.
//

#import <GLKit/GLKit.h>
#import "AGLKViewController.h"

@interface OpenGLES_Ch2 : AGLKViewController
{
    GLuint verteBufferID;
}

@property (nonatomic,strong) GLKBaseEffect *baseEffect;

@end

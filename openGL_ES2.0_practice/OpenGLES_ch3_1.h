//
//  OpenGLES_ch3_1.h
//  openGL_ES2.0_practice
//
//  Created by 符吉胜 on 2017/10/31.
//  Copyright © 2017年 符吉胜. All rights reserved.
//

#import <GLKit/GLKit.h>

@class AGLKVertexAttribArrayBuffer;

@interface OpenGLES_ch3_1 : GLKViewController

@property (strong, nonatomic) GLKBaseEffect
*baseEffect;
@property (strong, nonatomic) AGLKVertexAttribArrayBuffer
*vertexBuffer;

@end

//
//  OpenGLES_ch3_3.h
//  openGL_ES2.0_practice
//
//  Created by 符吉胜 on 2018/2/28.
//  Copyright © 2018年 符吉胜. All rights reserved.
//

#import <GLKit/GLKit.h>

@class AGLKVertexAttribArrayBuffer;

@interface OpenGLES_ch3_3 : GLKViewController

@property (strong, nonatomic) GLKBaseEffect
*baseEffect;
@property (strong, nonatomic) AGLKVertexAttribArrayBuffer
*vertexBuffer;
@property (nonatomic) BOOL
shouldUseLinearFilter;
@property (nonatomic) BOOL
shouldAnimate;
@property (nonatomic) BOOL
shouldRepeatTexture;
@property (nonatomic) GLfloat
sCoordinateOffset;

@end

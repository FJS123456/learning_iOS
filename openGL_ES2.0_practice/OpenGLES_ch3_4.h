//
//  OpenGLES_ch3_4.h
//  openGL_ES2.0_practice
//
//  Created by 符吉胜 on 2017/11/1.
//  Copyright © 2017年 符吉胜. All rights reserved.
//

#import <GLKit/GLKit.h>

@class AGLKVertexAttribArrayBuffer;

@interface OpenGLES_ch3_4 : GLKViewController

@property (strong, nonatomic) GLKBaseEffect *baseEffect;
@property (strong, nonatomic) AGLKVertexAttribArrayBuffer *vertexBuffer;
@property (strong, nonatomic) GLKTextureInfo *textureInfo0;
@property (strong, nonatomic) GLKTextureInfo *textureInfo1;

@end

//
//  OpenGLES_ch4_2.h
//  openGL_ES2.0_practice
//
//  Created by 符吉胜 on 2017/11/2.
//  Copyright © 2017年 符吉胜. All rights reserved.
//

#import <GLKit/GLKit.h>

@class AGLKVertexAttribArrayBuffer;

@interface OpenGLES_ch4_2 : GLKViewController

@property (strong, nonatomic) GLKBaseEffect *baseEffect;
@property (strong, nonatomic) AGLKVertexAttribArrayBuffer *vertexBuffer;
@property (strong, nonatomic) GLKTextureInfo *blandTextureInfo;
@property (strong, nonatomic) GLKTextureInfo *interestingTextureInfo;
@property (nonatomic) BOOL shouldUseDetailLighting;

@end

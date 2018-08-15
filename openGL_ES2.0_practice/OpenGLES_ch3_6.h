//
//  OpenGLES_ch3_6.h
//  openGL_ES2.0_practice
//
//  Created by 符吉胜 on 2017/11/1.
//  Copyright © 2017年 符吉胜. All rights reserved.
//

#import <GLKit/GLKit.h>

@class AGLKVertexAttribArrayBuffer;

@interface OpenGLES_ch3_6 : GLKViewController

@property (strong, nonatomic) GLKBaseEffect *baseEffect;
@property (strong, nonatomic) AGLKVertexAttribArrayBuffer *vertexBuffer;

@property (nonatomic,assign) GLuint program;
@property (nonatomic,assign) GLKMatrix4 modelViewProjectionMatrix;
@property (nonatomic,assign) GLKMatrix3 normalMatrix;
@property (nonatomic,assign) GLfloat rotation;

@property (nonatomic,assign) GLuint vertexArray;
@property (nonatomic,assign) GLuint texture0ID;
@property (nonatomic,assign) GLuint texture1ID;

@end

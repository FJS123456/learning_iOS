//
//  OpenGLES_ch3_1.m
//  openGL_ES2.0_practice
//
//  Created by 符吉胜 on 2017/10/31.
//  Copyright © 2017年 符吉胜. All rights reserved.
//

#import "OpenGLES_ch3_1.h"
#import "AGLKVertexAttribArrayBuffer.h"
#import "AGLKContext.h"

typedef struct{
    GLKVector3 positionCoords;
    GLKVector3 textureCoords;
}
SceneVertex;

// Define vertex data for a triangle to use in example
static const SceneVertex vertices[] =
{
    {{-1.0f, -1.0f, 0.0f}, {1.0f, 0.0f}}, // lower left corner
    {{ 1.0f, -1.0f, 0.0f}, {0.0f, 0.0f}}, // lower right corner
    {{-1.0f,  1.0f, 0.0f}, {0.0f, 1.0f}}, // upper left corner
};

@interface OpenGLES_ch3_1 ()

@end

@implementation OpenGLES_ch3_1

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    GLKView *view = (GLKView *)self.view;
    NSAssert([view isKindOfClass:[GLKView class]], @"fail");
    
    view.context = [[AGLKContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    [AGLKContext setCurrentContext:view.context];
    
    self.baseEffect = [[GLKBaseEffect alloc] init];
    self.baseEffect.useConstantColor = GL_TRUE;
    self.baseEffect.constantColor = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);
    // Set the background color stored in the current context
    ((AGLKContext *)view.context).clearColor = GLKVector4Make(
                                                              0.0f, // Red
                                                              0.0f, // Green
                                                              0.0f, // Blue
                                                              1.0f);// Alpha
    
    self.vertexBuffer = [[AGLKVertexAttribArrayBuffer alloc] initWithAttribStride:sizeof(SceneVertex) numberOfVertices:sizeof(vertices)/sizeof(SceneVertex) bytes:vertices usage:GL_STATIC_DRAW];
    
    //Setup texture
    CGImageRef imageRef = [[UIImage imageNamed:@"leaves.gif"] CGImage];
    GLKTextureInfo *textureInfo = [GLKTextureLoader textureWithCGImage:imageRef options:nil error:nil];
    self.baseEffect.texture2d0.name = textureInfo.name;
    self.baseEffect.texture2d0.target = textureInfo.target;
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    [self.baseEffect prepareToDraw];
    
    [(AGLKContext *)view.context clear:GL_COLOR_BUFFER_BIT];
    
    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribPosition numberOfCoordinates:3 attribOffset:offsetof(SceneVertex, positionCoords) shouldEnable:YES];
    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribTexCoord0 numberOfCoordinates:2 attribOffset:offsetof(SceneVertex, textureCoords) shouldEnable:YES];
    
    [self.vertexBuffer drawArrayWithMode:GL_TRIANGLES startVertexIndex:0 numberOfVertices:3];
}


@end

//
//  OpenGLES_ch3_4.m
//  openGL_ES2.0_practice
//
//  Created by 符吉胜 on 2017/11/1.
//  Copyright © 2017年 符吉胜. All rights reserved.
//

#import "OpenGLES_ch3_4.h"
#import "AGLKVertexAttribArrayBuffer.h"
#import "AGLKContext.h"

/////////////////////////////////////////////////////////////////
// This data type is used to store information for each vertex
typedef struct {
    GLKVector3  positionCoords;
    GLKVector2  textureCoords;
}
SceneVertex;

/////////////////////////////////////////////////////////////////
// Define vertex data for a triangle to use in example
static const SceneVertex vertices[] =
{
    {{-1.0f, -0.67f, 0.0f}, {0.0f, 0.0f}},  // first triangle
    {{ 1.0f, -0.67f, 0.0f}, {1.0f, 0.0f}},
    {{-1.0f,  0.67f, 0.0f}, {0.0f, 1.0f}},
    {{ 1.0f, -0.67f, 0.0f}, {1.0f, 0.0f}},  // second triangle
    {{-1.0f,  0.67f, 0.0f}, {0.0f, 1.0f}},
    {{ 1.0f,  0.67f, 0.0f}, {1.0f, 1.0f}},
};

@implementation OpenGLES_ch3_4

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Verify the type of view created automatically by the
    // Interface Builder storyboard
    GLKView *view = (GLKView *)self.view;
    NSAssert([view isKindOfClass:[GLKView class]],
             @"View controller's view is not a GLKView");
    
    // Create an OpenGL ES 2.0 context and provide it to the
    // view
    view.context = [[AGLKContext alloc]
                    initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    // Make the new context current
    [AGLKContext setCurrentContext:view.context];
    
    // Create a base effect that provides standard OpenGL ES 2.0
    // shading language programs and set constants to be used for
    // all subsequent rendering
    self.baseEffect = [[GLKBaseEffect alloc] init];
    self.baseEffect.useConstantColor = GL_TRUE;
    self.baseEffect.constantColor = GLKVector4Make(
                                                   1.0f, // Red
                                                   1.0f, // Green
                                                   1.0f, // Blue
                                                   1.0f);// Alpha
    
    // Set the background color stored in the current context
    ((AGLKContext *)view.context).clearColor = GLKVector4Make(
                                                              0.0f, // Red
                                                              0.0f, // Green
                                                              0.0f, // Blue
                                                              1.0f);// Alpha
    
    // Create vertex buffer containing vertices to draw
    self.vertexBuffer = [[AGLKVertexAttribArrayBuffer alloc]
                         initWithAttribStride:sizeof(SceneVertex)
                         numberOfVertices:sizeof(vertices) / sizeof(SceneVertex)
                         bytes:vertices
                         usage:GL_STATIC_DRAW];
    
    // Setup texture0
    CGImageRef imageRef0 =
    [[UIImage imageNamed:@"leaves.gif"] CGImage];
    
    //GLKTextureLoaderOriginBottomLeft : 命令GLKit的GLKTextureLoader类垂直翻转图像数据。这个翻转可以抵消图像的原点与OpenGL ES 标志原点之间的差异
    self.textureInfo0 = [GLKTextureLoader
                         textureWithCGImage:imageRef0
                         options:[NSDictionary dictionaryWithObjectsAndKeys:
                                  [NSNumber numberWithBool:YES],
                                  GLKTextureLoaderOriginBottomLeft, nil]
                         error:NULL];
    
    self.baseEffect.texture2d0.name = self.textureInfo0.name;
    self.baseEffect.texture2d0.target = self.textureInfo0.target;
    
    // Setup texture1
    CGImageRef imageRef1 =
    [[UIImage imageNamed:@"beetle.png"] CGImage];
    
    self.textureInfo1 = [GLKTextureLoader
                         textureWithCGImage:imageRef1
                         options:nil
                         error:NULL];
    
    self.baseEffect.texture2d1.name = self.textureInfo1.name;
    self.baseEffect.texture2d1.target = self.textureInfo1.target;
    self.baseEffect.texture2d1.envMode = GLKTextureEnvModeDecal;
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    // Clear back frame buffer (erase previous drawing)
    [(AGLKContext *)view.context clear:GL_COLOR_BUFFER_BIT];
    
    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribPosition
                           numberOfCoordinates:3
                                  attribOffset:offsetof(SceneVertex, positionCoords)
                                  shouldEnable:YES];
    
    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribTexCoord0
                           numberOfCoordinates:2
                                  attribOffset:offsetof(SceneVertex, textureCoords)
                                  shouldEnable:YES];
    
    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribTexCoord1
                           numberOfCoordinates:2
                                  attribOffset:offsetof(SceneVertex, textureCoords)
                                  shouldEnable:YES];
    
    [self.baseEffect prepareToDraw];
    
    // Draw triangles using currently bound vertex buffer
    [self.vertexBuffer drawArrayWithMode:GL_TRIANGLES
                        startVertexIndex:0
                        numberOfVertices:sizeof(vertices) / sizeof(SceneVertex)];
}

@end

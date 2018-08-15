//
//  OpenGLES_Ch2.m
//  openGL_ES2.0_practice
//
//  Created by 符吉胜 on 2017/10/25.
//  Copyright © 2017年 符吉胜. All rights reserved.
//

#import "OpenGLES_Ch2.h"
#import "AGLKContext.h"
#import "AGLKVertexAttribArrayBuffer.h"

typedef struct {
    GLKVector3 positionCoords;
}
SceneVertex;

// Define vertex data for a triangle to use in example
static const SceneVertex vertices[] =
{
    {{-1.0f, 1.0f, 0.0}}, // lower left corner
    {{ 1.0f, 1.0f, 0.0}}, // lower right corner
    {{1.0f,  -1.0f, 0.0}}  // upper left corner
};

@interface OpenGLES_Ch2()

@property (nonatomic,strong) AGLKVertexAttribArrayBuffer *vertexBuffer;

@end


@implementation OpenGLES_Ch2

@synthesize baseEffect;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    GLKView *view = (GLKView *)self.view;
    view.context = [[AGLKContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    [AGLKContext setCurrentContext:view.context];
    
    self.baseEffect = [[GLKBaseEffect alloc] init];
    self.baseEffect.useConstantColor = GL_TRUE;
    self.baseEffect.constantColor = GLKVector4Make(0.0, 1.0, 1.0, 1.0);
    
    // Set the background color stored in the current context
    ((AGLKContext *)view.context).clearColor = GLKVector4Make(
                                                              0.0f, // Red
                                                              0.0f, // Green
                                                              0.0f, // Blue
                                                              1.0f);// Alpha

    
    self.vertexBuffer = [[AGLKVertexAttribArrayBuffer alloc] initWithAttribStride:sizeof(SceneVertex)
                                                                 numberOfVertices:sizeof(vertices)/sizeof(SceneVertex)
                                                                            bytes:vertices
                                                                            usage:GL_STATIC_DRAW];
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    [self.baseEffect prepareToDraw];
    
    // Clear back frame buffer (erase previous drawing)
    [(AGLKContext *)view.context clear:GL_COLOR_BUFFER_BIT];
    
    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribPosition numberOfCoordinates:3 attribOffset:offsetof(SceneVertex, positionCoords) shouldEnable:YES];
    
    [self.vertexBuffer drawArrayWithMode:GL_TRIANGLES startVertexIndex:0 numberOfVertices:3];
}

- (void)dealloc
{
    // Make the view's context current
    GLKView *view = (GLKView *)self.view;
    [AGLKContext setCurrentContext:view.context];
    
    // Delete buffers that aren't needed when view is unloaded
    self.vertexBuffer = nil;
    
    // Stop using the context created in -viewDidLoad
    ((GLKView *)self.view).context = nil;
    [EAGLContext setCurrentContext:nil];}

@end

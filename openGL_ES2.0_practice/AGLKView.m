//
//  AGLKView.m
//  openGL_ES2.0_practice
//
//  Created by 符吉胜 on 2017/10/25.
//  Copyright © 2017年 符吉胜. All rights reserved.
//

#import "AGLKView.h"

@interface AGLKView()

@property (nonatomic,assign) GLuint defaultFrameBuffer;
@property (nonatomic,assign) GLuint colorRenderBuffer;
@property (nonatomic,assign) GLuint depthRenderBuffer;

@property (nonatomic,assign) NSInteger drawableWidth;
@property (nonatomic,assign) NSInteger drawableHeight;
@property (nonatomic,assign) AGLKViewDrawableDepthFormat drawableDepthFormat;

@end

@implementation AGLKView

+ (Class)layerClass
{
    return [CAEAGLLayer class];
}

// This method is designated initializer for the class
- (id)initWithFrame:(CGRect)frame context:(EAGLContext *)aContext;
{
    if ((self = [super initWithFrame:frame]))
    {
        CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
        
        eaglLayer.drawableProperties =
        [NSDictionary dictionaryWithObjectsAndKeys:
         [NSNumber numberWithBool:NO],
         kEAGLDrawablePropertyRetainedBacking,
         kEAGLColorFormatRGBA8,
         kEAGLDrawablePropertyColorFormat,
         nil];
        
        self.context = aContext;
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
        
        eaglLayer.drawableProperties =
        [NSDictionary dictionaryWithObjectsAndKeys:
         [NSNumber numberWithBool:NO],
         kEAGLDrawablePropertyRetainedBacking,
         kEAGLColorFormatRGBA8,
         kEAGLDrawablePropertyColorFormat,
         nil];
    }
    return self;
}

- (id)initWithCoder:(NSCoder*)coder
{
    if ((self = [super initWithCoder:coder]))
    {
        CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
        
        eaglLayer.drawableProperties =
        [NSDictionary dictionaryWithObjectsAndKeys:
         [NSNumber numberWithBool:NO],
         kEAGLDrawablePropertyRetainedBacking,
         kEAGLColorFormatRGBA8,
         kEAGLDrawablePropertyColorFormat,
         nil];
    }
    
    return self;
}

// Calling this method tells the receiver to redraw the contents
// of its associated OpenGL ES Frame Buffer. This method
// configures OpenGL ES and then calls -drawRect:
- (void)display
{
    [EAGLContext setCurrentContext:self.context];
    glViewport(0, 0, (GLint)self.drawableWidth, (GLint)self.drawableHeight);
    
    [self drawRect:[self bounds]];
    
    [self.context presentRenderbuffer:GL_RENDERBUFFER];
}

// This method is called automatically whenever the receiver
// needs to redraw the contents of its associated OpenGL ES
// Frame Buffer. This method should not be called directly. Call
// -display instead which configures OpenGL ES before calling
// -drawRect:
- (void)drawRect:(CGRect)rect
{
    if([self.delegate respondsToSelector:@selector(glkView:drawInRect:)])
    {
        [self.delegate glkView:self drawInRect:[self bounds]];
    }
}

- (void)setContext:(EAGLContext *)context
{
    if (_context != context) {
        [EAGLContext setCurrentContext:context];
        
        if (0 != _defaultFrameBuffer) {
            glDeleteFramebuffers(1, &_defaultFrameBuffer);
            _defaultFrameBuffer = 0;
        }
        
        if (0 != _colorRenderBuffer) {
            glDeleteRenderbuffers(1, &_colorRenderBuffer);
            _colorRenderBuffer = 0;
        }
        
        if (0 != _depthRenderBuffer) {
            glDeleteRenderbuffers(1, &_depthRenderBuffer);
            _depthRenderBuffer = 0;
        }
        
        _context = context;
        
        if (nil != context) {
            [EAGLContext setCurrentContext:context];
            
            glGenFramebuffers(1, &_defaultFrameBuffer);
            glBindFramebuffer(GL_FRAMEBUFFER, _defaultFrameBuffer);
            
            glGenRenderbuffers(1, &_colorRenderBuffer);
            glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);
            
            glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _colorRenderBuffer);
            
            [self layoutSubviews];
        }
    }
}

- (void)layoutSubviews
{
    CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
    
    [EAGLContext setCurrentContext:self.context];
    
    // Initialize the current Frame Buffer’s pixel color buffer
    // so that it shares the corresponding Core Animation Layer’s
    // pixel color storage.
    [self.context renderbufferStorage:GL_RENDERBUFFER fromDrawable:eaglLayer];
    
    if (0 != _depthRenderBuffer) {
        glDeleteRenderbuffers(1, &_depthRenderBuffer);
        _depthRenderBuffer = 0;
    }
    
    GLint currentDrawableWidth = (GLint)self.drawableWidth;
    GLint currentDrawableHeight = (GLint)self.drawableHeight;
    
    if (self.drawableDepthFormat !=
        AGLKViewDrawableDepthFormatNone &&
        0 < currentDrawableWidth &&
        0 < currentDrawableHeight) {
        
        glGenRenderbuffers(1, &_depthRenderBuffer);
        glBindRenderbuffer(GL_RENDERBUFFER,_depthRenderBuffer);
        //配置存储 ： 指定深度缓存的大小
        glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, currentDrawableWidth, currentDrawableHeight);
        //附加深度缓存到一个帧缓存
        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, _depthRenderBuffer);
    }
    
    GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    
    if (status != GL_FRAMEBUFFER_COMPLETE) {
        NSLog(@"failed to make complete frame buffer object %x", status);
    }
    
    // Make the Color Render Buffer the current buffer for display
    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);
}

#pragma mark - getter
// This method returns the width in pixels of current context's
// Pixel Color Render Buffer
- (NSInteger)drawableWidth
{
    GLint       backingWidth;
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &backingWidth);
    
    return (NSInteger)backingWidth;
}

// This method returns the height in pixels of current context's
// Pixel Color Render Buffer
- (NSInteger)drawableHeight
{
    GLint       backingHeight;
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &backingHeight);
    
    return (NSInteger)backingHeight;
}

// This method is called automatically when the reference count
// for a Cocoa Touch object reaches zero.
- (void)dealloc
{
    if ([EAGLContext currentContext] == _context) {
        [EAGLContext setCurrentContext:nil];
    }
    
    _context = nil;
}

@end

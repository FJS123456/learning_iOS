//
//  AGLKVertexAttribArrayBuffer.m
//  openGL_ES2.0_practice
//
//  Created by 符吉胜 on 2017/10/26.
//  Copyright © 2017年 符吉胜. All rights reserved.
//

#import "AGLKVertexAttribArrayBuffer.h"

@interface AGLKVertexAttribArrayBuffer ()

@property (nonatomic, assign) GLuint name;
@property (nonatomic, assign) GLsizeiptr bufferSizeBytes;
@property (nonatomic, assign) GLsizei stride;

@end

@implementation AGLKVertexAttribArrayBuffer

// This method creates a vertex attribute array buffer in
// the current OpenGL ES context for the thread upon which this
// method is called.
- (id)initWithAttribStride:(GLsizei)stride
          numberOfVertices:(GLsizei)count
                     bytes:(const GLvoid *)dataPtr
                     usage:(GLenum)usage
{
    NSParameterAssert(stride > 0);
    NSAssert((count > 0 && dataPtr != NULL) || (count == 0 && dataPtr == NULL), @"data must not be NULL or count > 0");
    
    if (nil != (self = [super init])) {
        _stride = stride;
        _bufferSizeBytes = stride * count;
        
        glGenBuffers(1, &_name);
        glBindBuffer(GL_ARRAY_BUFFER, _name);
        glBufferData(                  // STEP 3
                     GL_ARRAY_BUFFER,  // Initialize buffer contents
                     _bufferSizeBytes,  // Number of bytes to copy
                     dataPtr,          // Address of bytes to copy
                     usage);           // Hint: cache in GPU memory
        
        NSAssert(0 != _name, @"Failed to generate name");
        
    }
    
    return self;
}

- (void)reinitWithAttribStride:(GLsizei)stride
              numberOfVertices:(GLsizei)count
                         bytes:(const GLvoid *)dataPtr
{
    NSParameterAssert(stride > 0);
    NSParameterAssert(count > 0);
    NSParameterAssert(dataPtr != NULL);
    NSAssert(_name != 0, @"Invalide name");
    
    _stride = stride;
    _bufferSizeBytes = stride * count;
    
    glBindBuffer(GL_ARRAY_BUFFER, _name);
    glBufferData(                  // STEP 3
                 GL_ARRAY_BUFFER,  // Initialize buffer contents
                 _bufferSizeBytes,  // Number of bytes to copy
                 dataPtr,          // Address of bytes to copy
                 GL_DYNAMIC_DRAW);
}

// A vertex attribute array buffer must be prepared when your
// application wants to use the buffer to render any geometry.
// When your application prepares an buffer, some OpenGL ES state
// is altered to allow bind the buffer and configure pointers.
- (void)prepareToDrawWithAttrib:(GLuint)index
            numberOfCoordinates:(GLint)count
                   attribOffset:(GLsizeiptr)offset
                   shouldEnable:(BOOL)shouldEnable
{
    NSParameterAssert(count > 0 && count < 4);
    NSParameterAssert(self.stride > offset);
    NSAssert(_name != 0, @"Invalid name");
    
    glBindBuffer(GL_ARRAY_BUFFER, self.name);
    if (shouldEnable) {
        //启动顶点渲染操作，OpenGL ES 所支持的每一个渲染操作都可以单独地使用保存在当前OpenGL ES 上下文中的设置来开启或关闭
        glEnableVertexAttribArray(index);
    }
    
    glVertexAttribPointer(            // Step 5
                          index,               // Identifies the attribute to use
                          count,               // number of coordinates for attribute
                          GL_FLOAT,            // data is floating point
                          GL_FALSE,            // no fixed point scaling
                          (self.stride),       // total num bytes stored per vertex
                          NULL + offset);      // offset from start of each vertex to
    // first coord for attribute
#ifdef DEBUG
    {  // Report any errors
        GLenum error = glGetError();
        if(GL_NO_ERROR != error)
        {
            NSLog(@"GL Error: 0x%x", error);
        }
    }
#endif
}

// Submits the drawing command identified by mode and instructs
// OpenGL ES to use count vertices from the buffer starting from
// the vertex at index first. Vertex indices start at 0.
- (void)drawArrayWithMode:(GLenum)mode
         startVertexIndex:(GLint)first
         numberOfVertices:(GLsizei)count
{
    NSAssert(self.bufferSizeBytes >= (first + count) * self.stride,@"Attempt to draw more vertex data than available.");
    
    glDrawArrays(mode, first, count);
}

// Submits the drawing command identified by mode and instructs
// OpenGL ES to use count vertices from previously prepared
// buffers starting from the vertex at index first in the
// prepared buffers
+ (void)drawPreparedArraysWithMode:(GLenum)mode
                  startVertexIndex:(GLint)first
                  numberOfVertices:(GLsizei)count;
{
    glDrawArrays(mode, first, count); // Step 6
}

// This method deletes the receiver's buffer from the current
// Context when the receiver is deallocated.
- (void)dealloc
{
    // Delete buffer from current context
    if (0 != _name)
    {
        glDeleteBuffers (1, &_name); // Step 7
        _name = 0;
    }
}


@end

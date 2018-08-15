//
//  AGLKContext.h
//  openGL_ES2.0_practice
//
//  Created by 符吉胜 on 2017/10/26.
//  Copyright © 2017年 符吉胜. All rights reserved.
//

#import <GLKit/GLKit.h>

@interface AGLKContext : EAGLContext

@property (nonatomic,assign) GLKVector4 clearColor;

- (void)clear:(GLbitfield)mask;
- (void)enable:(GLenum)capability;
- (void)disable:(GLenum)capability;
- (void)setBlendSourceFunction:(GLenum)sfactor
           destinationFunction:(GLenum)dfactor;

@end

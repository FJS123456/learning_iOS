//
//  AGLKContext.m
//  openGL_ES2.0_practice
//
//  Created by 符吉胜 on 2017/10/26.
//  Copyright © 2017年 符吉胜. All rights reserved.
//

#import "AGLKContext.h"

@implementation AGLKContext

// This method sets the clear (background) RGBA color.
// The clear color is undefined until this method is called.
- (void)setClearColor:(GLKVector4)clearColor
{
    _clearColor = clearColor;
    
    NSAssert(self == [[self class] currentContext],
             @"Receiving context required to be current context");
    
    glClearColor(clearColor.r, clearColor.g, clearColor.b, clearColor.a);
}

- (void)clear:(GLbitfield)mask
{
    NSAssert(self == [[self class] currentContext],
             @"Receiving context required to be current context");
    
    glClear(mask);
}

- (void)enable:(GLenum)capability
{
    NSAssert(self == [[self class] currentContext],
             @"Receiving context required to be current context");
    
    glEnable(capability);
}

- (void)disable:(GLenum)capability
{
    NSAssert(self == [[self class] currentContext],
             @"Receiving context required to be current context");
    glDisable(capability);
}

- (void)setBlendSourceFunction:(GLenum)sfactor
           destinationFunction:(GLenum)dfactor;
{
    glBlendFunc(sfactor, dfactor);
}

@end

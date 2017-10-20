//
//  shaderUtil.h
//  openGL_ES2.0_practice
//
//  Created by 符吉胜 on 2017/10/16.
//  Copyright © 2017年 符吉胜. All rights reserved.
//

#ifndef shaderUtil_h
#define shaderUtil_h

#import <OpenGLES/ES2/gl.h>

/* Convenience wrapper that compiles, links, enumerates uniforms and attribs */
GLint glueCreateProgram(const GLchar *vertSource, const GLchar *fragSource,
                        GLsizei attribNameCt, const GLchar **attribNames,
                        const GLint *attribLocations,
                        GLsizei uniformNameCt, const GLchar **uniformNames,
                        GLint *uniformLocations,
                        GLuint *program);

#endif /* shaderUtil_h */

//
//  AGLKTextureLoader.h
//  openGL_ES2.0_practice
//
//  Created by 符吉胜 on 2017/10/31.
//  Copyright © 2017年 符吉胜. All rights reserved.
//

#import <GLKit/GLKit.h>

#pragma mark -AGLKTextureInfo

@interface AGLKTextureInfo : NSObject
{
@private
    GLuint name;
    GLenum target;
    GLuint width;
    GLuint height;
}

@property (readonly) GLuint name;
@property (readonly) GLenum target;
@property (readonly) GLuint width;
@property (readonly) GLuint height;

@end

#pragma mark -AGLKTextureLoader

@interface AGLKTextureLoader : NSObject

+ (AGLKTextureInfo *)textureWithCGImage:(CGImageRef)cgImage
                                options:(NSDictionary *)options
                                  error:(NSError **)outError;


@end

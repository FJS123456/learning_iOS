//
//  AGLKTextureLoader.m
//  openGL_ES2.0_practice
//
//  Created by 符吉胜 on 2017/10/31.
//  Copyright © 2017年 符吉胜. All rights reserved.
//

#import "AGLKTextureLoader.h"

/////////////////////////////////////////////////////////////////
// This data type is used specify power of 2 values.  OpenGL ES
// best supports texture images that have power of 2 dimensions.
typedef enum
{
    AGLK1 = 1,
    AGLK2 = 2,
    AGLK4 = 4,
    AGLK8 = 8,
    AGLK16 = 16,
    AGLK32 = 32,
    AGLK64 = 64,
    AGLK128 = 128,
    AGLK256 = 256,
    AGLK512 = 512,
    AGLK1024 = 1024,
}
AGLKPowerOf2;

static AGLKPowerOf2 AGLKCalculatePowerOf2ForDimension(GLuint dimension);

static NSData *AGLKDataWithResizedCGImageBytes(CGImageRef cgImage,size_t *widthPtr,size_t *heightPth);

/////////////////////////////////////////////////////////////////
// Instances of AGLKTextureInfo are immutable once initialized
@interface AGLKTextureInfo (AGLKTextureLoader)

- (id)initWithName:(GLuint)aName
            target:(GLenum)aTarget
             width:(GLuint)aWidth
            height:(GLuint)aHeight;

@end


@implementation AGLKTextureInfo (AGLKTextureLoader)

/////////////////////////////////////////////////////////////////
// This method is the designated initializer.
- (id)initWithName:(GLuint)aName
            target:(GLenum)aTarget
             width:(GLuint)aWidth
            height:(GLuint)aHeight
{
    if (nil != (self = [super init]))
    {
        name = aName;
        target = aTarget;
        width = aWidth;
        height = aHeight;
    }
    
    return self;
}

@end

@implementation AGLKTextureInfo

@synthesize name;
@synthesize target;
@synthesize width;
@synthesize height;

@end

@implementation AGLKTextureLoader

// This method generates a new OpenGL ES texture buffer and
// initializes the buffer contents using pixel data from the
// specified Core Graphics image, cgImage. This method returns an
// immutable AGLKTextureInfo instance initialized with
// information about the newly generated texture buffer.
//    The generated texture buffer has power of 2 dimensions. The
// provided image data is scaled (re-sampled) by Core Graphics as
// necessary to fit within the generated texture buffer.
+ (AGLKTextureInfo *)textureWithCGImage:(CGImageRef)cgImage
                                options:(NSDictionary *)options
                                  error:(NSError *__autoreleasing *)outError
{
    // Get the bytes to be used when copying data into new texture
    // buffer
    size_t width;
    size_t height;
    NSData *imageData = AGLKDataWithResizedCGImageBytes(
                                                        cgImage,
                                                        &width,
                                                        &height);
    
    // Generation, bind, and copy data into a new texture buffer
    GLuint      textureBufferID;
    
    glGenTextures(1, &textureBufferID);                  // Step 1
    glBindTexture(GL_TEXTURE_2D, textureBufferID);       // Step 2
    
    //复制图片的像素数据到绑定的纹理缓存中
    glTexImage2D(                                        // Step 3
                 GL_TEXTURE_2D,
                 0,                 //指定MIP贴图的初始细节级别
                 GL_RGBA,           //用于指定在纹理缓存内每个纹素需要保存的信息
                 (GLuint)width,
                 (GLuint)height,
                 0,                 //用来确定围绕纹理的纹素的一个边界大小，通常为0
                 GL_RGBA,           //用于指定初始化缓存所使用的图像数据中的每个像素所要保存的信息，通常与internalFormat参数相同
                 GL_UNSIGNED_BYTE,  //用于指定缓存中的纹素数据所使用的位编码类型，GL_UNSIGNED_BYTE提供最佳色彩质量
                 [imageData bytes]); //将要被复制到绑定的纹理缓存中的图片的像素颜色数据的指针
    
    // Set parameters that control texture sampling for the bound
    // texture
    glTexParameteri(GL_TEXTURE_2D,
                    GL_TEXTURE_MIN_FILTER,
                    GL_LINEAR);
    
    // Allocate and initialize the AGLKTextureInfo instance to be
    // returned
    AGLKTextureInfo *result = [[AGLKTextureInfo alloc]
                               initWithName:textureBufferID
                               target:GL_TEXTURE_2D
                               width:(GLuint)width
                               height:(GLuint)height];
    
    return result;
}

@end

/////////////////////////////////////////////////////////////////
// This function returns an NSData object that contains bytes
// loaded from the specified Core Graphics image, cgImage. This
// function also returns (by reference) the power of 2 width and
// height to be used when initializing an OpenGL ES texture buffer
// with the bytes in the returned NSData instance. The widthPtr
// and heightPtr arguments must be valid pointers.
static NSData *AGLKDataWithResizedCGImageBytes(
                                               CGImageRef cgImage,
                                               size_t *widthPtr,
                                               size_t *heightPtr)
{
    NSCParameterAssert(NULL != cgImage);
    NSCParameterAssert(NULL != widthPtr);
    NSCParameterAssert(NULL != heightPtr);
    
    GLuint originalWidth = (GLuint)CGImageGetWidth(cgImage);
    GLuint originalHeight = (GLuint)CGImageGetWidth(cgImage);
    
    NSCAssert(0 < originalWidth, @"Invalid image width");
    NSCAssert(0 < originalHeight, @"Invalid image width");
    
    // Calculate the width and height of the new texture buffer
    // The new texture buffer will have power of 2 dimensions.
    GLuint width = AGLKCalculatePowerOf2ForDimension(
                                                     originalWidth);
    GLuint height = AGLKCalculatePowerOf2ForDimension(
                                                      originalHeight);
    
    // Allocate sufficient storage for RGBA pixel color data with
    // the power of 2 sizes specified
    NSMutableData    *imageData = [NSMutableData dataWithLength:
                                   height * width * 4];  // 4 bytes per RGBA pixel
    
    NSCAssert(nil != imageData,
              @"Unable to allocate image storage");
    
    // Create a Core Graphics context that draws into the
    // allocated bytes
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef cgContext = CGBitmapContextCreate(
                                                   [imageData mutableBytes], width, height, 8,
                                                   4 * width, colorSpace,
                                                   kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(colorSpace);
    
    // Flip the Core Graphics Y-axis for future drawing
    CGContextTranslateCTM (cgContext, 0, height);
    CGContextScaleCTM (cgContext, 1.0, -1.0);
    
    // Draw the loaded image into the Core Graphics context
    // resizing as necessary
    CGContextDrawImage(cgContext, CGRectMake(0, 0, width, height),
                       cgImage);
    
    CGContextRelease(cgContext);
    
    *widthPtr = width;
    *heightPtr = height;
    
    return imageData;
}

/////////////////////////////////////////////////////////////////
// This function calculates and returns the nearest power of 2
// that is greater than or equal to the dimension argument and
// less than or equal to 1024.
static AGLKPowerOf2 AGLKCalculatePowerOf2ForDimension(
                                                      GLuint dimension)
{
    AGLKPowerOf2  result = AGLK1;
    
    if(dimension > (GLuint)AGLK512)
    {
        result = AGLK1024;
    }
    else if(dimension > (GLuint)AGLK256)
    {
        result = AGLK512;
    }
    else if(dimension > (GLuint)AGLK128)
    {
        result = AGLK256;
    }
    else if(dimension > (GLuint)AGLK64)
    {
        result = AGLK128;
    }
    else if(dimension > (GLuint)AGLK32)
    {
        result = AGLK64;
    }
    else if(dimension > (GLuint)AGLK16)
    {
        result = AGLK32;
    }
    else if(dimension > (GLuint)AGLK8)
    {
        result = AGLK16;
    }
    else if(dimension > (GLuint)AGLK4)
    {
        result = AGLK8;
    }
    else if(dimension > (GLuint)AGLK2)
    {
        result = AGLK4;
    }
    else if(dimension > (GLuint)AGLK1)
    {
        result = AGLK2;
    }
    
    return result;
}


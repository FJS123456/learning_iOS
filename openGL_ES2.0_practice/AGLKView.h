//
//  AGLKView.h
//  openGL_ES2.0_practice
//
//  Created by 符吉胜 on 2017/10/25.
//  Copyright © 2017年 符吉胜. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

@class EAGLContext;
@protocol AGLKViewDelegate;

// Type for depth buffer formats.
typedef enum
{
    AGLKViewDrawableDepthFormatNone = 0,
    AGLKViewDrawableDepthFormat16,
} AGLKViewDrawableDepthFormat;

@interface AGLKView : UIView

@property (nonatomic,weak) id<AGLKViewDelegate> delegate;
@property (nonatomic,strong) EAGLContext *context;
@property (nonatomic,assign,readonly) NSInteger drawableWidth;
@property (nonatomic,assign,readonly) NSInteger drawableHeight;

- (void)display;

@end

@protocol AGLKViewDelegate<NSObject>

@required
- (void)glkView:(AGLKView *)view drawInRect:(CGRect)rect;

@end

//
//  MDBaseDefine.h
//  openGL_ES2.0_practice
//
//  Created by 符吉胜 on 2018/8/15.
//  Copyright © 2018年 符吉胜. All rights reserved.
//

#ifndef MDBaseDefine_h
#define MDBaseDefine_h

#import "UIView+Utils.h"

#define RGBCOLOR(r,g,b)     [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define RGBACOLOR(r,g,b,a)  [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define MDScreenWidth     CGRectGetWidth([[UIScreen mainScreen] bounds])
#define MDScreenHeight    CGRectGetHeight([[[UIApplication sharedApplication].delegate window] bounds])

#endif /* MDBaseDefine_h */

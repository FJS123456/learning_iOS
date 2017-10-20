//
//  MDPaintingView.h
//  openGL_ES2.0_practice
//
//  Created by 符吉胜 on 2017/10/16.
//  Copyright © 2017年 符吉胜. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYPoint : NSObject

@property (nonatomic , strong) NSNumber* mY;
@property (nonatomic , strong) NSNumber* mX;

@end

@interface MDPaintingView : UIView

@property(nonatomic, readwrite) CGPoint location;
@property(nonatomic, readwrite) CGPoint previousLocation;

- (void)setBrushColorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;
- (void)erase;

@end

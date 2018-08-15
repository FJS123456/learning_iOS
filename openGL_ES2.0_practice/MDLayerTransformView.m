//
//  MDLayerTransformView.m
//  openGL_ES2.0_practice
//
//  Created by 符吉胜 on 2018/8/15.
//  Copyright © 2018年 符吉胜. All rights reserved.
//

#import "MDLayerTransformView.h"
#import "MDBaseDefine.h"

@interface MDLayerTransformView()

@end

@implementation MDLayerTransformView

- (instancetype)init
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        self.frame = CGRectMake(0, 0, MDScreenWidth, MDScreenHeight);
        
        //测试3D变换
        [self test3DTransform];
    }
    return self;
}

- (void)test3DTransform
{
//    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
//    view1.center = CGPointMake(self.width / 2.0, self.height / 2.0f);
//    view1.backgroundColor = [UIColor grayColor];
//    [self addSubview:view1];
    
    CALayer *layer1 = [CALayer layer];
    layer1.frame = CGRectMake(0, 0, 200, 200);
    layer1.position = CGPointMake(self.width/2.0, self.height/2.0);
    layer1.backgroundColor = [UIColor grayColor].CGColor;
    [self.layer addSublayer:layer1];
    
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -1.0/500.0;
    transform = CATransform3DRotate(transform, M_PI_4, 0, 1, 0);
    layer1.transform = transform;
}

@end

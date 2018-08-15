//
//  MDLayerPracticeController.m
//  openGL_ES2.0_practice
//
//  Created by 符吉胜 on 2018/8/14.
//  Copyright © 2018年 符吉胜. All rights reserved.
//

#import "MDLayerPracticeController.h"
#import "MDLayerTransformView.h"

@interface MDLayerPracticeController ()

@end

@implementation MDLayerPracticeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //视图变换
    MDLayerTransformView *view1 = [[MDLayerTransformView alloc] init];
    [self.view addSubview:view1];
}


@end

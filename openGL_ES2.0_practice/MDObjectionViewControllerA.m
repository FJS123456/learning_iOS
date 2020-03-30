//
//  MDObjectionViewControllerA.m
//  openGL_ES2.0_practice
//
//  Created by 符吉胜 on 2019/10/9.
//  Copyright © 2019 符吉胜. All rights reserved.
//

#import "MDObjectionViewControllerA.h"


@interface MDObjectionViewControllerA ()

@end

@implementation MDObjectionViewControllerA

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (UIColor *)backgroudColor
{
    return self.view.backgroundColor;
}

- (void)setBackgroudColor:(UIColor *)backgroudColor
{
    self.view.backgroundColor = backgroudColor;
}

@end

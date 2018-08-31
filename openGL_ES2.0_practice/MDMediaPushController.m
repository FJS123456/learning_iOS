//
//  MDMediaPushController.m
//  openGL_ES2.0_practice
//
//  Created by 符吉胜 on 2018/8/29.
//  Copyright © 2018年 符吉胜. All rights reserved.
//

#import "MDMediaPushController.h"
#import "TestAVCapture.h"

@interface MDMediaPushController ()

@property (nonatomic, strong) TestVideoCapture *testVideoCapture;

@end

@implementation MDMediaPushController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.testVideoCapture = [[TestVideoCapture alloc] initWithViewController:self];
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    [self.testVideoCapture onLayout];
}

@end

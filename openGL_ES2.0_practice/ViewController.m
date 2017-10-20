//
//  ViewController.m
//  openGL_ES2.0_practice
//
//  Created by 符吉胜 on 2017/10/12.
//  Copyright © 2017年 符吉胜. All rights reserved.
//

#import "ViewController.h"
#import "MDOpenGLBaseController.h"
#import "MDGPUImageBaseController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (IBAction)didClickOpenGLBtn:(id)sender
{
    MDOpenGLBaseController *openGLCtr = [[MDOpenGLBaseController alloc] init];
    
    UINavigationController *navCtr = [[UINavigationController alloc] initWithRootViewController:openGLCtr];
    [self presentViewController:navCtr animated:YES completion:nil];

}

- (IBAction)didClickGPUImageBtn:(id)sender
{
    MDGPUImageBaseController *gpuImageCtr = [[MDGPUImageBaseController alloc] init];
    
    UINavigationController *navCtr = [[UINavigationController alloc] initWithRootViewController:gpuImageCtr];
    [self presentViewController:navCtr animated:YES completion:nil];
}

@end

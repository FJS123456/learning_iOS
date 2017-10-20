//
//  MDESEentrance_002.m
//  openGL_ES2.0_practice
//
//  Created by 符吉胜 on 2017/10/12.
//  Copyright © 2017年 符吉胜. All rights reserved.
//

#import "MDESEentrance_002.h"
#import "MDLearnView_002.h"

@interface MDESEentrance_002 ()

@property (nonatomic,strong) MDLearnView_002 *myView;

@end

@implementation MDESEentrance_002

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.myView = [[MDLearnView_002 alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.myView];
}

@end

//
//  MDESEentrance_003.m
//  openGL_ES2.0_practice
//
//  Created by 符吉胜 on 2017/10/12.
//  Copyright © 2017年 符吉胜. All rights reserved.
//

#import "MDESEentrance_003.h"
#import "MDLearnView_003.h"

@interface MDESEentrance_003 ()

@property (nonatomic,strong) MDLearnView_003 *myView;

@end

@implementation MDESEentrance_003

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _myView = [[MDLearnView_003 alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_myView];
}

@end

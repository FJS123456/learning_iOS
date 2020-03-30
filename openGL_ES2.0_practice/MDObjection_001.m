//
//  MDObjection_001.m
//  openGL_ES2.0_practice
//
//  Created by 符吉胜 on 2019/10/9.
//  Copyright © 2019 符吉胜. All rights reserved.
//

#import "MDObjection_001.h"
#import <Objection/Objection.h>
#import "MDObjectionViewControllerA.h"

@interface MDObjection_001 ()

@end

@implementation MDObjection_001

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self testProtocolBind];
}

- (void)testProtocolBind
{
    JSObjectionInjector *injector = [JSObjection defaultInjector];
    UIViewController<ViewControllerAProtocol> *vc = [injector getObject:@protocol(ViewControllerAProtocol)];
    vc.backgroudColor = [UIColor lightGrayColor];
    [self.navigationController pushViewController:vc animated:YES];
}

@end

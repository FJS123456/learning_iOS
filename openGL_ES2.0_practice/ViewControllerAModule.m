//
//  ViewControllerAModule.m
//  openGL_ES2.0_practice
//
//  Created by 符吉胜 on 2019/10/9.
//  Copyright © 2019 符吉胜. All rights reserved.
//

#import "ViewControllerAModule.h"
#import <Objection/Objection.h>
#import "MDObjectionViewControllerA.h"

@implementation ViewControllerAModule

+ (void)load
{
    JSObjectionInjector *injector = [JSObjection defaultInjector];
    injector = injector ?: [JSObjection createInjector];
    injector = [injector withModule:[[ViewControllerAModule alloc] init]];
    [JSObjection setDefaultInjector:injector];
}

- (void)configure
{
    [self bindClass:[MDObjectionViewControllerA class] toProtocol:@protocol(ViewControllerAProtocol)];
}

@end

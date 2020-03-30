//
//  MDRunLoopTestController.m
//  openGL_ES2.0_practice
//
//  Created by 符吉胜 on 2020/3/9.
//  Copyright © 2020 符吉胜. All rights reserved.
//

#import "MDRunLoopTestController.h"

@interface MDRunLoopTestController ()

@property (nonatomic, strong) NSThread *bgThread;

@end

@implementation MDRunLoopTestController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
//    [self testBackThreadExecute];
//    [self testBlockVar];
    [self testDispatch_apply];
}

- (void)testBlockVar {
    __block int a = 1;
    void (^aBlock)(void) = ^(void) {
        NSLog(@"---a = %d", a);
    };
    
    ++a;
    
    aBlock();
}

- (void)testDispatch_apply {
    size_t count = 10;
    dispatch_queue_t queue = dispatch_queue_create("com.test", DISPATCH_QUEUE_SERIAL);
    dispatch_apply(count, queue, ^(size_t i) {
        NSLog(@"--- applay i = %zu", i);
    });
}

- (void)testBackThreadExecute {
    _bgThread = [[NSThread alloc] initWithTarget:self selector:@selector(doInBackThead) object:nil];
    [_bgThread start];
    
    [self performSelector:@selector(executeFunOne) onThread:_bgThread withObject:nil waitUntilDone:NO];
}

- (void)doInBackThead {
    NSLog(@"%@",[NSThread currentThread]);
    NSLog(@"AAAAAAAAAAA");
    
    [[NSThread currentThread] setName:@"fujishengThread"];
    NSRunLoop *runloop = [NSRunLoop currentRunLoop];
    [runloop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
    [runloop run];
}

- (void)executeFunOne {
    NSLog(@"executeFunOne");
}

@end

//
//  MDYYCacheTestController.m
//  openGL_ES2.0_practice
//
//  Created by 符吉胜 on 2020/3/18.
//  Copyright © 2020 符吉胜. All rights reserved.
//

#import "MDYYCacheTestController.h"
#import "YYKit.h"

@interface MDYYCacheTestController ()

@property (nonatomic, strong) YYCache *cache;

@end

@implementation MDYYCacheTestController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    
    [self test_1];
}

- (void)test_1 {
    _cache = [[YYCache alloc] initWithName:@"testCache"];
    [_cache setObject:@3 forKey:@"A"];
}

@end

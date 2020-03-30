//
//  MDKVOAndKVCTestController.m
//  openGL_ES2.0_practice
//
//  Created by 符吉胜 on 2020/3/23.
//  Copyright © 2020 符吉胜. All rights reserved.
//

#import "MDKVOAndKVCTestController.h"

@interface MDDog : NSObject
@property (nonatomic, assign) int age;
@property (nonatomic, assign) int level;
@end

@implementation MDDog

- (NSString *)description {
    return [@{
        @"age": @(_age),
        @"level": @(_level)
    } description];
}

@end

@interface MDPerson : NSObject
@property (nonatomic, strong) MDDog *dog;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSMutableArray<MDDog *> *arr;
@end

@implementation MDPerson

- (instancetype)init {
    if (self = [super init]) {
        _arr = [NSMutableArray array];
        MDDog *dog = [[MDDog alloc] init];
        dog.age = 10;
        dog.level = 1;
        [_arr addObject:dog];
    }
    return self;
}

+ (NSSet<NSString *> *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
    NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
    if ([key isEqualToString:@"dog"]) {
        keyPaths = [[NSSet alloc] initWithObjects:@"_dog.level",@"_dog.age", nil];
    }
    return keyPaths;
}

- (void)setNilValueForKey:(NSString *)key {
    NSLog(@"不能将%@设成nil", key);
}

- (id)valueForUndefinedKey:(NSString *)key {
    NSLog(@"valueForUndefinedKey --- %@找不到", key);
    
    return nil;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    NSLog(@"setValue --- %@找不到", key);
}

+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key {
    //关闭KVO监听
    return NO;
}

@end


@interface MDKVOAndKVCTestController ()

@property (nonatomic, strong) MDPerson *p;

@end

@implementation MDKVOAndKVCTestController

- (void)dealloc {
    [_p removeObserver:self forKeyPath:@"dog"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
//    [self testKVO_001];
    [self testKVC_001];
}

- (void)testKVO_001 {
    _p = [[MDPerson alloc] init];
    _p.dog = [[MDDog alloc] init];
    
    NSLog(@"befor -- %s", object_getClassName(_p));
    [_p addObserver:self forKeyPath:@"dog" options:NSKeyValueObservingOptionNew context:nil];
    [_p addObserver:self forKeyPath:@"arr" options:NSKeyValueObservingOptionNew context:nil];
    NSLog(@"after -- %s", object_getClassName(_p));
}

- (void)testKVC_001 {
    MDPerson *p1 = [[MDPerson alloc] init];
    [p1 setValue:nil forKey:@"name"];
    NSLog(@"p1的年龄是%@", [p1 valueForKey:@"name1"]);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    static int a;
//    _p.dog.age = a++;
//    _p.dog.level = a++;
    
    NSMutableArray *tempArray = [_p mutableArrayValueForKey:@"arr"];
    MDDog *dog = tempArray.firstObject;
    dog.level = 333;
    [tempArray replaceObjectAtIndex:0 withObject:dog];
//    [tempArray addObject:@"bje"];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
//    NSLog(@"change: %@, dog: %@",change, _p.dog);
    NSLog(@"change: %@, arr: %@",change, _p.arr);
}

@end

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
#import "MDOpenGLBookBaseController.h"
#import "MDBaseFoundationController.h"
#import "MDMediaBaseController.h"
#import "MDARKitBaseController.h"
#import "MDMetalBaseController.h"
#import "MDSourceCodeBaseController.h"
#import "MDYYKitBaseViewController.h"
#import "MDIMBaseViewController.h"
#import <objc/runtime.h>

const static NSString * const kClassName = @"kClassName";
const static NSString * const kTitleName = @"kTitleName";

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datas;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configUI];
    [self configData];
}

- (void)configUI {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)configData
{
    self.datas = [NSMutableArray array];
    
    NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
    [dict1 setObject:@"MDGPUImageBaseController" forKey:kClassName];
    [dict1 setObject:@"弹出GPUImage" forKey:kTitleName];
    
    NSMutableDictionary *dict2 = [NSMutableDictionary dictionary];
    [dict2 setObject:@"MDSourceCodeBaseController" forKey:kClassName];
    [dict2 setObject:@"源码实践" forKey:kTitleName];
    
    NSMutableDictionary *dict3 = [NSMutableDictionary dictionary];
    [dict3 setObject:@"MDOpenGLBaseController" forKey:kClassName];
    [dict3 setObject:@"弹出openGL" forKey:kTitleName];
    
    NSMutableDictionary *dict4 = [NSMutableDictionary dictionary];
    [dict4 setObject:@"MDOpenGLBookBaseController" forKey:kClassName];
    [dict4 setObject:@"弹出openGL_book" forKey:kTitleName];
    
    NSMutableDictionary *dict5 = [NSMutableDictionary dictionary];
    [dict5 setObject:@"MDMediaBaseController" forKey:kClassName];
    [dict5 setObject:@"实时音视频推送" forKey:kTitleName];
    
    NSMutableDictionary *dict6 = [NSMutableDictionary dictionary];
    [dict6 setObject:@"MDBaseFoundationController" forKey:kClassName];
    [dict6 setObject:@"Foundation 实践" forKey:kTitleName];
    
    NSMutableDictionary *dict7 = [NSMutableDictionary dictionary];
    [dict7 setObject:@"MDARKitBaseController" forKey:kClassName];
    [dict7 setObject:@"ARKit增强现实" forKey:kTitleName];
    
    NSMutableDictionary *dict8 = [NSMutableDictionary dictionary];
    [dict8 setObject:@"MDMetalBaseController" forKey:kClassName];
    [dict8 setObject:@"metal练习" forKey:kTitleName];
    
    NSMutableDictionary *dict9 = [NSMutableDictionary dictionary];
    [dict9 setObject:@"MDYYKitBaseViewController" forKey:kClassName];
    [dict9 setObject:@"YYKit练习" forKey:kTitleName];
    
    NSMutableDictionary *dict10 = [NSMutableDictionary dictionary];
    [dict10 setObject:@"MDIMBaseViewController" forKey:kClassName];
    [dict10 setObject:@"IM即时通信练习" forKey:kTitleName];
    
    [self.datas addObject:dict1];
    [self.datas addObject:dict2];
    [self.datas addObject:dict3];
    [self.datas addObject:dict4];
    [self.datas addObject:dict5];
    [self.datas addObject:dict6];
    [self.datas addObject:dict7];
    [self.datas addObject:dict8];
    [self.datas addObject:dict9];
    [self.datas addObject:dict10];
    
    NSArray *tempArray = [self.datas copy];
    NSLog(@"first : %@, second: %@", self.datas.firstObject, tempArray.firstObject);

    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * const identifier = @"transition";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        NSDictionary *dict = [self.datas objectAtIndex:indexPath.row];
        cell.textLabel.text = [dict objectForKey:kTitleName];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *className = [[self.datas objectAtIndex:indexPath.row] objectForKey:kClassName];
    UIViewController *selectedCtr = [[NSClassFromString(className) alloc] init];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:selectedCtr];
    [self presentViewController:navController animated:YES completion:nil];
}

#pragma mark - simple test
- (void)testDispatch_barrier {
    dispatch_queue_t concurrentQueue = dispatch_queue_create("test", DISPATCH_QUEUE_CONCURRENT);
    for (int i = 0; i < 1; ++i) {
        dispatch_async(concurrentQueue, ^{
            NSLog(@"first -- %d", i);
        });
    }
    
    dispatch_barrier_async(concurrentQueue, ^{
        for (int i = 0; i < 109; ++i) {
            NSLog(@"barrier -- %d", i);
        }
    });
    
    for (int i = 10; i < 11; ++i) {
        dispatch_async(concurrentQueue, ^{
            NSLog(@"second -- %d", i);
        });
    }
}

@end

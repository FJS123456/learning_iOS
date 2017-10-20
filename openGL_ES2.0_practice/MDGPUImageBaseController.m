//
//  MDGPUImageBaseController.m
//  openGL_ES2.0_practice
//
//  Created by 符吉胜 on 2017/10/16.
//  Copyright © 2017年 符吉胜. All rights reserved.
//

#import "MDGPUImageBaseController.h"
#import "MDGPUImage_002.h"
#import "MDGPUImage_003.h"
#import "MDGPUImage_004.h"
#import "MDGPUimage_005.h"
#import "MDGPUImage_006.h"

const static NSString * const kClassName = @"kClassName";
const static NSString * const kTitleName = @"kTitleName";

@interface MDGPUImageBaseController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *datas;

@end

@implementation MDGPUImageBaseController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self configUI];
    [self configData];
}

- (void)configUI
{
    [self.view addSubview:self.tableView];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(didClickBackBtn)];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSMutableArray *)datas
{
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}

- (void)configData
{
    NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
    [dict1 setObject:@"MDGPUImage_002" forKey:kClassName];
    [dict1 setObject:@"GPUImage详细解析（二）" forKey:kTitleName];
    
    NSMutableDictionary *dict2 = [NSMutableDictionary dictionary];
    [dict2 setObject:@"MDGPUImage_003" forKey:kClassName];
    [dict2 setObject:@"GPUImage详细解析（三）- 实时美颜滤镜" forKey:kTitleName];
    
    NSMutableDictionary *dict3 = [NSMutableDictionary dictionary];
    [dict3 setObject:@"MDGPUImage_004" forKey:kClassName];
    [dict3 setObject:@"GPUImage详细解析（四）模糊图片处理" forKey:kTitleName];
    
    NSMutableDictionary *dict4 = [NSMutableDictionary dictionary];
    [dict4 setObject:@"MDGPUimage_005" forKey:kClassName];
    [dict4 setObject:@"GPUImage详细解析（五）滤镜视频录制" forKey:kTitleName];
    
    NSMutableDictionary *dict5 = [NSMutableDictionary dictionary];
    [dict5 setObject:@"MDGPUImage_006" forKey:kClassName];
    [dict5 setObject:@"GPUImage详细解析（六）-用视频做视频水印" forKey:kTitleName];
    
    [self.datas addObject:dict1];
    [self.datas addObject:dict2];
    [self.datas addObject:dict3];
    [self.datas addObject:dict4];
    [self.datas addObject:dict5];
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
    [self.navigationController pushViewController:selectedCtr animated:YES];
}

- (void)didClickBackBtn
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

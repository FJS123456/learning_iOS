//
//  MDOpenGLBookBaseController.m
//  openGL_ES2.0_practice
//
//  Created by 符吉胜 on 2017/10/25.
//  Copyright © 2017年 符吉胜. All rights reserved.
//

#import "MDOpenGLBookBaseController.h"
//#import "OpenGLES_Ch2.h"
//#import "OpenGLES_ch3_1.h"
//#import "OpenGLES_ch3_2.h"
//#import "OpenGLES_ch3_4.h"
//#import "OpenGLES_ch3_6.h"
//#import "OpenGLES_ch4_2.h"
//#import "OpenGLES_ch5_1.h"
//#import "OpenGLES_ch5_4.h"

const static NSString * const kClassName = @"kClassName";
const static NSString * const kTitleName = @"kTitleName";

@interface MDOpenGLBookBaseController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *datas;

@end

@implementation MDOpenGLBookBaseController

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
    [dict1 setObject:@"OpenGLES_Ch2" forKey:kClassName];
    [dict1 setObject:@"OpenGLES_Ch2.1" forKey:kTitleName];
    
    NSMutableDictionary *dict2 = [NSMutableDictionary dictionary];
    [dict2 setObject:@"OpenGLES_ch3_1" forKey:kClassName];
    [dict2 setObject:@"OpenGLES_ch3_1" forKey:kTitleName];

    NSMutableDictionary *dict3 = [NSMutableDictionary dictionary];
    [dict3 setObject:@"OpenGLES_ch3_2" forKey:kClassName];
    [dict3 setObject:@"OpenGLES_ch3_2----GLKTextureLoader" forKey:kTitleName];
    
    NSMutableDictionary *dict3_3 = [NSMutableDictionary dictionary];
    [dict3_3 setObject:@"OpenGLES_ch3_3" forKey:kClassName];
    [dict3_3 setObject:@"OpenGLES_ch3_3---纹理属性调整" forKey:kTitleName];
    
    NSMutableDictionary *dict4 = [NSMutableDictionary dictionary];
    [dict4 setObject:@"OpenGLES_ch3_4" forKey:kClassName];
    [dict4 setObject:@"OpenGLES_ch3_4----纹理混合" forKey:kTitleName];

    NSMutableDictionary *dict5 = [NSMutableDictionary dictionary];
    [dict5 setObject:@"OpenGLES_ch3_6" forKey:kClassName];
    [dict5 setObject:@"OpenGLES_ch3_6----自定义纹理" forKey:kTitleName];
    
    NSMutableDictionary *dict6 = [NSMutableDictionary dictionary];
    [dict6 setObject:@"OpenGLES_ch4_2" forKey:kClassName];
    [dict6 setObject:@"OpenGLES_ch4_2---- 光线与纹理" forKey:kTitleName];
    
    NSMutableDictionary *dict7 = [NSMutableDictionary dictionary];
    [dict7 setObject:@"OpenGLES_ch5_1" forKey:kClassName];
    [dict7 setObject:@"OpenGLES_ch5_1---- Depth Render Buffer" forKey:kTitleName];
    
//    OpenGLES_ch5_4
    NSMutableDictionary *dict8 = [NSMutableDictionary dictionary];
    [dict8 setObject:@"OpenGLES_ch5_4" forKey:kClassName];
    [dict8 setObject:@"OpenGLES_ch5_4---- 基本变换（translate、scale、rotate）" forKey:kTitleName];

    [self.datas addObject:dict1];
    [self.datas addObject:dict2];
    [self.datas addObject:dict3];
    [self.datas addObject:dict3_3];
    [self.datas addObject:dict4];
    [self.datas addObject:dict5];
    [self.datas addObject:dict6];
    [self.datas addObject:dict7];
    [self.datas addObject:dict8];
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

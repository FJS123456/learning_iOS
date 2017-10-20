//
//  MDOpenGLBaseController.m
//  openGL_ES2.0_practice
//
//  Created by 符吉胜 on 2017/10/12.
//  Copyright © 2017年 符吉胜. All rights reserved.
//

#import "MDOpenGLBaseController.h"

#import "MDESEentrance_001.h"
#import "MDESEentrance_002.h"
#import "MDESEentrance_003.h"
#import "MDGLPaintController.h"

const static NSString * const kClassName = @"kClassName";
const static NSString * const kTitleName = @"kTitleName";

@interface MDOpenGLBaseController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *datas;

@end

@implementation MDOpenGLBaseController

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
    [dict1 setObject:@"MDESEentrance_001" forKey:kClassName];
    [dict1 setObject:@"OpenGL ES入门教程1" forKey:kTitleName];
    
    NSMutableDictionary *dict2 = [NSMutableDictionary dictionary];
    [dict2 setObject:@"MDESEentrance_002" forKey:kClassName];
    [dict2 setObject:@"OpenGL ES入门教程2" forKey:kTitleName];
    
    NSMutableDictionary *dict3 = [NSMutableDictionary dictionary];
    [dict3 setObject:@"MDESEentrance_003" forKey:kClassName];
    [dict3 setObject:@"OpenGL ES入门教程3" forKey:kTitleName];
    
    NSMutableDictionary *dict4 = [NSMutableDictionary dictionary];
    [dict4 setObject:@"MDGLPaintController" forKey:kClassName];
    [dict4 setObject:@"苹果画图应用" forKey:kTitleName];
    
    [self.datas addObject:dict1];
    [self.datas addObject:dict2];
    [self.datas addObject:dict3];
    [self.datas addObject:dict4];
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

//
//  MDBaseFoundationController.m
//  openGL_ES2.0_practice
//
//  Created by 符吉胜 on 2018/8/14.
//  Copyright © 2018年 符吉胜. All rights reserved.
//

#import "MDBaseFoundationController.h"
#import "MDLayerPracticeController.h"


const static NSString * const kClassName = @"kClassName";
const static NSString * const kTitleName = @"kTitleName";

@interface MDBaseFoundationController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *datas;

@end

@implementation MDBaseFoundationController

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
    [dict1 setObject:@"MDLayerPracticeController" forKey:kClassName];
    [dict1 setObject:@"图层实践" forKey:kTitleName];
    
    [self.datas addObject:dict1];
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

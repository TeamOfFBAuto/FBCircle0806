//
//  HotTopicViewController.m
//  FBCircle
//
//  Created by lichaowei on 14-8-6.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "HotTopicViewController.h"
#import "LTools.h"
#import "HotTopicCell.h"

@interface HotTopicViewController ()<UITableViewDataSource,RefreshDelegate>
{
    RefreshTableView *_table;
    NSArray *_dataArray;
}

@end

@implementation HotTopicViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleLabel.text = self.navigationTitle;
    
    //数据展示table
    _table = [[RefreshTableView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.height - 44 - 20)];
    _table.refreshDelegate = self;
    _table.dataSource = self;
    _table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _table.separatorInset = UIEdgeInsetsMake(0, 1, 0, 0);
    [self.view addSubview:_table];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 事件处理

//进入我的论坛

- (void)clickToMyBBS:(UIButton *)sender
{
    
}

/**
 *  添加论坛
 */
- (void)clickToAddBBS
{
    
}


#pragma mark - 网络请求
#pragma mark - 视图创建


#pragma mark - delegate

#pragma - mark RefreshDelegate <NSObject>

- (void)loadNewData
{
    NSLog(@"loadNewData");
}

- (void)loadMoreData
{
    NSLog(@"loadMoreData");
}

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}


#pragma mark - UITableViewDelegate

#pragma mark - UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"HotTopicCell";
    
    HotTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"HotTopicCell" owner:self options:nil]objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}
@end

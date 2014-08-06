//
//  MyBBSViewController.m
//  FBCircle
//
//  Created by lichaowei on 14-8-6.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "MyBBSViewController.h"
#import "MyBBSCell.h"
#import "LTools.h"

@interface MyBBSViewController ()<RefreshDelegate,UITableViewDataSource>
{
    RefreshTableView *_table;
    NSArray *_dataArray;
}

@end

@implementation MyBBSViewController

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
    self.titleLabel.text = @"我的论坛";
    
    self.rightImageName = @"+";
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeNull WithRightButtonType:MyViewControllerRightbuttonTypeOther];
    
    //数据展示table
    _table = [[RefreshTableView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.height - 44 - 20)];
    _table.backgroundColor = [UIColor clearColor];
    _table.refreshDelegate = self;
    _table.dataSource = self;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    return 45;
}

-(CGFloat)heightForHeaderInSection:(NSInteger)section
{
    return 32;
}

-(UIView *)viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 32)];
    header.backgroundColor = [UIColor colorWithHexString:@"f6f7f9"];
    
    NSString *title = [NSString stringWithFormat:@"%@(%d)",(section == 0) ? @"我创建的论坛":@"我加入的论坛",50];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, 150, header.height)];
    titleLabel.text = title;
    titleLabel.font = [UIFont boldSystemFontOfSize:12];
    titleLabel.textColor = [UIColor lightGrayColor];
    [header addSubview:titleLabel];
    
    return header;
}

#pragma mark - UITableViewDelegate

#pragma mark - UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 5;
    }
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"MyBBSCell";
    
    MyBBSCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MyBBSCell" owner:self options:nil]objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}


@end

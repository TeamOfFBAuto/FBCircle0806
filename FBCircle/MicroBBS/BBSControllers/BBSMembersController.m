//
//  BBSMembersController.m
//  FBCircle
//
//  Created by lichaowei on 14-8-11.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "BBSMembersController.h"
#import "PraiseMemberCell.h"

@interface BBSMembersController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_table;
}

@end

@implementation BBSMembersController

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
    self.view.backgroundColor = [UIColor colorWithHexString:@"d3d6db"];
    
    self.titleLabel.text = @"论坛成员列表";
    
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeNull WithRightButtonType:MyViewControllerRightbuttonTypeNull];
    
    //数据展示table
    _table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.height - 44 - 20) style:UITableViewStylePlain];
    _table.backgroundColor = [UIColor clearColor];
    _table.delegate = self;
    _table.dataSource = self;
    _table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _table.separatorInset = UIEdgeInsetsMake(0, 10, 0, 0);
    [self.view addSubview:_table];
    
    _table.tableHeaderView = [self createTableHeaderView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 事件处理

//添加成员
- (void)clickToAddMember:(LButtonView *)sender
{
    
}

#pragma mark - 网络请求
#pragma mark - 视图创建

- (UIView *)createTableHeaderView
{
    UIView *header = [[UIView alloc]init];
    
    LButtonView *btn = [[LButtonView alloc]initWithFrame:CGRectMake(12, 15, 320 - 24, 43) leftImage:Nil rightImage:[UIImage imageNamed:@"jiantou"] title:@"添加成员" target:self action:@selector(clickToAddMember:) lineDirection:Line_No];
    btn.layer.cornerRadius = 3.f;
    [header addSubview:btn];
    
    NSString *title = [NSString stringWithFormat:@"成员(%d)",2];
    LButtonView *btn2 = [[LButtonView alloc]initWithFrame:CGRectMake(12, btn.bottom + 15, 320 - 24, 43) leftImage:Nil rightImage:Nil title:title target:Nil action:Nil lineDirection:Line_No];
    [header addSubview:btn2];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(12, btn2.bottom - 1, 320 - 24, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [header addSubview:line];
    
    header.frame = CGRectMake(0, 0, 320, btn2.bottom);
    
    return header;
}

#pragma mark - delegate

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier= @"cell1";
    
    PraiseMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        
        cell = [[PraiseMemberCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    CGRect imageFrame = cell.aImageView.frame;
    imageFrame.origin.x += 10;
    cell.aImageView.frame = imageFrame;
    
    CGRect lFrame = cell.aTitleLabel.frame;
    lFrame.origin.x = cell.aImageView.right + 5;
    cell.aTitleLabel.frame = lFrame;
    
    [cell.aImageView sd_setImageWithURL:[NSURL URLWithString:nil] placeholderImage:[UIImage imageNamed:@"Picture_default_image"]];
    
    cell.aTitleLabel.text = @"越野狂人";
    
    return cell;
    
}


@end

//
//  MicroBBSViewController.m
//  FBCircle
//
//  Created by soulnear on 14-8-4.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "MicroBBSViewController.h"
#import "MyBBSViewController.h"
#import "HotTopicViewController.h"
#import "ClassifyBBSController.h"

#import "LTools.h"
#import "LSecionView.h"
#import "BBSTableCell.h"

@interface MicroBBSViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_table;
}

@end

@implementation MicroBBSViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"d3d6db"];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
    self.title = @"微论坛";
    self.titleLabel.text = @"微论坛";
    self.rightImageName = @"+";
    self.leftString = @"分类论坛";
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeText WithRightButtonType:MyViewControllerRightbuttonTypeOther];
    [self.my_right_button addTarget:self action:@selector(clickToAddBBS) forControlEvents:UIControlEventTouchUpInside];
    [self.left_button addTarget:self action:@selector(clickToClassifyBBS) forControlEvents:UIControlEventTouchUpInside];

    //搜索
    [self createSearchView];
    
    //数据展示table
    _table = [[UITableView alloc]initWithFrame:CGRectMake(0, 45, 320, self.view.height - 44 - 45 - 49 - 20) style:UITableViewStylePlain];
    _table.backgroundColor = [UIColor clearColor];
    _table.delegate = self;
    _table.dataSource = self;
    
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_table];
    
    _table.tableHeaderView = [self createTableHeaderView];
    
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
    MyBBSViewController *myBBS = [[MyBBSViewController alloc]init];
    myBBS.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:myBBS animated:YES];
}

- (void)clickToMore:(UIButton *)sender
{
    NSString *title = nil;
    if (sender.tag == 101) {
        
        title = @"热门推荐";
    }else
    {
        title = @"热门帖子";
    }
    HotTopicViewController *hotTopic = [[HotTopicViewController alloc]init];
    hotTopic.navigationTitle = title;
    hotTopic.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:hotTopic animated:YES];
}
/**
 *  进入分类论坛
 */
- (void)clickToClassifyBBS
{
    ClassifyBBSController *classify = [[ClassifyBBSController alloc]init];
    classify.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:classify animated:YES];
}

/**
 *  添加论坛
 */
- (void)clickToAddBBS
{
    
}

/**
 *  搜索页
 */
- (void)clickToSearch:(UIButton *)sender
{
    NSLog(@"searchPage");
}

#pragma mark - 网络请求
#pragma mark - 视图创建

- (void)createLeftBtn
{
    UIButton *leftButton =[[UIButton alloc]initWithFrame:CGRectMake(0,8,60,21.5)];
    [leftButton addTarget:self action:@selector(clickToClassifyBBS) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setTitle:@"分类论坛" forState:UIControlStateNormal];
    [leftButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    UIBarButtonItem *left_item=[[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = left_item;
}

- (void)createRightBtn
{
    UIButton *rightButton =[[UIButton alloc]initWithFrame:CGRectMake(0,12,19,19)];
    [rightButton addTarget:self action:@selector(clickToAddBBS) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setImage:[UIImage imageNamed:@"+"] forState:UIControlStateNormal];
    UIBarButtonItem *right_item=[[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = right_item;
}

/**
 *  搜索view
 */
- (void)createSearchView
{
    UIView *search_bgview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 45)];
    search_bgview.backgroundColor = [UIColor colorWithHexString:@"cac9ce"];
    [self.view addSubview:search_bgview];

    UISearchBar *bar = [[UISearchBar alloc]initWithFrame:CGRectMake(5, 0, 310, 45)];
    bar.placeholder = @"搜索";
    bar.backgroundColor = [UIColor clearColor];
    bar.delegate = self;
    [search_bgview addSubview:bar];
}

- (UIView *)createTableHeaderView
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 100)];
    headerView.backgroundColor = [UIColor clearColor];
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(8, 20, 304, 80)];
    bgView.layer.cornerRadius = 3.f;
//    bgView.layer.borderWidth = 10;
    bgView.clipsToBounds = YES;
    [headerView addSubview:bgView];
    
    LSecionView *section = [[LSecionView alloc]initWithFrame:CGRectMake(0, 0, 304, 40) title:@"我的论坛" target:self action:@selector(clickToMyBBS:)];
    [bgView addSubview:section];
    
    UIView *secondBgView = [[UIView alloc]initWithFrame:CGRectMake(section.left, section.bottom ,section.width, 40)];
    secondBgView.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:secondBgView];
    
    NSArray *titles = @[@"运动",@"旅行",@"赛事"];
    for (int i = 0 ; i < 3; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btn setTitle:[titles objectAtIndex:i] forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
        btn.frame = CGRectMake(100 * i, 0, 100, 40);
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [secondBgView addSubview:btn];
        
        if (i != 2) {
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(btn.right, 10, 1, 20)];
            line.backgroundColor = [UIColor colorWithHexString:@"dfdfdf"];
            [secondBgView addSubview:line];
        }
        
    }
    
    return headerView;
}


#pragma mark - delegate

#pragma - mark UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [self clickToSearch:nil];
    return NO;
}

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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 || indexPath.row == 4) {
        
        return 16;
        
    }else if (indexPath.row == 1 || indexPath.row == 5)
    {
        return 40;
    }
    return 75;
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
    static NSString * identifier1= @"cell1";
    static NSString * identifier2 = @"cell2";
    static NSString * identifier3 = @"BBSTableCell";
    
    if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 4 || indexPath.row == 5) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:(indexPath.row == 0 || indexPath.row == 4) ? identifier1 : identifier2];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:(indexPath.row == 0 || indexPath.row == 4) ? identifier1 : identifier2 ];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (indexPath.row == 0 || indexPath.row == 4) {
            cell.contentView.backgroundColor = [UIColor colorWithHexString:@"d3d6db"];
            return cell;
            
        }else
        {
            cell.contentView.backgroundColor = [UIColor clearColor];
            cell.backgroundColor = [UIColor clearColor];
            
            NSString *title = (indexPath.row == 1) ? @"热门推荐" : @"我关注的论坛的热门话题";
            LSecionView *section = [[LSecionView alloc]initWithFrame:CGRectMake(8, 0, 304, 40) title:title target:self action:@selector(clickToMore:)];
            section.rightBtn.tag = 100 + indexPath.row;
            [cell addSubview:section];
            
            section.layer.cornerRadius = 3.f;
            
            return cell;
        }
    }
    
    BBSTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier3];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"BBSTableCell" owner:self options:nil]objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 3) {
        
        cell.bgView.layer.cornerRadius = 3.f;
    }else
    {
        cell.bgView.layer.cornerRadius = 0.f;
    }
    
    return cell;
    
}


@end


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
#import "BBSListViewController.h"
#import "BBSTopicController.h"
#import "BBSSearchController.h"

#import "LTools.h"
#import "LSecionView.h"
#import "BBSTableCell.h"
#import "CreateNewBBSViewController.h"
#import "LBBSCellView.h"

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
    
    NSLog(@"auteykey %@",[SzkAPI getAuthkey]);
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
    [self PushToViewController:myBBS WithAnimation:YES];
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
    [self PushToViewController:hotTopic WithAnimation:YES];
}
/**
 *  进入分类论坛
 */
- (void)clickToClassifyBBS
{
    ClassifyBBSController *classify = [[ClassifyBBSController alloc]init];
    [self PushToViewController:classify WithAnimation:YES];
}

/**
 *  添加论坛
 */
- (void)clickToAddBBS
{
    CreateNewBBSViewController * sendPostVC = [[CreateNewBBSViewController alloc] init];
    [self PushToViewController:sendPostVC WithAnimation:YES];
}
/**
 *  论坛帖子列表
 */
- (void)clickToBBSList
{
    BBSListViewController *list = [[BBSListViewController alloc]init];
    [self PushToViewController:list WithAnimation:YES];
}

/**
 *  帖子详情
 */
- (void)clickToTopicInfo:(LBBSCellView *)sender
{
    BBSTopicController *topic = [[BBSTopicController alloc]init];
    [self PushToViewController:topic WithAnimation:YES];
}

/**
 *  搜索页
 */
- (void)clickToSearch:(UIButton *)sender
{
    NSLog(@"searchPage");
    BBSSearchController *search = [[BBSSearchController alloc]init];
    [self PushToViewController:search WithAnimation:YES];
}

#pragma mark - 网络请求
#pragma mark - 视图创建

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
    
    //我的论坛
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(8, 20, 304, 80)];
    bgView.layer.cornerRadius = 3.f;
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
        [btn addTarget:self action:@selector(clickToBBSList) forControlEvents:UIControlEventTouchUpInside];
        
        if (i != 2) {
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(btn.right, 10, 1, 20)];
            line.backgroundColor = [UIColor colorWithHexString:@"dfdfdf"];
            [secondBgView addSubview:line];
        }
        
    }
    
    //热门推荐
    
    UIView *bgView2 = [[UIView alloc]init];
    bgView2.layer.cornerRadius = 3.f;
    bgView2.clipsToBounds = YES;
    [headerView addSubview:bgView2];
    
    LSecionView *section2 = [[LSecionView alloc]initWithFrame:CGRectMake(0, 0, 304, 40) title:@"热门推荐" target:self action:@selector(clickToMore:)];
    section2.rightBtn.tag = 101;
    [bgView2 addSubview:section2];
    
    
    //推荐列表
    for (int i = 0; i < 2; i ++) {
        LBBSCellView *cell_view = [[LBBSCellView alloc]initWithFrame:CGRectMake(0, section2.bottom + 75 * i, 320, 75) target:self action:@selector(clickToTopicInfo:)];
        cell_view.backgroundColor = [UIColor whiteColor];
        [bgView2 addSubview:cell_view];
        
        if (i < 1) {
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, cell_view.bottom - 1, 304, 0.5)];
            line.backgroundColor = [UIColor lightGrayColor];
            [bgView2 addSubview:line];
        }
    }
    
    bgView2.frame = CGRectMake(8, bgView.bottom + 15, 304, section2.height + 75 * 2);
    headerView.frame = CGRectMake(0, 0, 320, bgView2.bottom + 15);
    
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
    BBSTopicController *topic = [[BBSTopicController alloc]init];
    [self PushToViewController:topic WithAnimation:YES];
}
- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
        return 40;
    }
    return 75;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BBSTopicController *topic = [[BBSTopicController alloc]init];
    [self PushToViewController:topic WithAnimation:YES];
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
    static NSString * identifier3 = @"BBSTableCell";
    
    if (indexPath.row == 0) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier1];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier1];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
        
        NSString *title = @"我关注的论坛的热门话题";
        LSecionView *section = [[LSecionView alloc]initWithFrame:CGRectMake(8, 0, 304, 40) title:title target:self action:@selector(clickToMore:)];
        section.rightBtn.tag = 100 + indexPath.row;
        [cell addSubview:section];
        
        section.layer.cornerRadius = 3.f;
        
        return cell;
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


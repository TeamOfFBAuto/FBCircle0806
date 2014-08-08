//
//  BBSTopicController.m
//  FBCircle
//
//  Created by lichaowei on 14-8-7.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "BBSTopicController.h"
#import "MyBBSViewController.h"
#import "HotTopicViewController.h"
#import "ClassifyBBSController.h"
#import "PraiseMemberController.h"

#import "LTools.h"
#import "LSecionView.h"
#import "BBSRecommendCell.h"
#import "SendPostsViewController.h"

@interface BBSTopicController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_table;
    LInputView *inputView;
}

@end

@implementation BBSTopicController

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
    
    self.titleLabel.text = @"主题帖";
    
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeNull WithRightButtonType:MyViewControllerRightbuttonTypeNull];
    
    [self.my_right_button addTarget:self action:@selector(clickToAddBBS) forControlEvents:UIControlEventTouchUpInside];
    
    //数据展示table
    _table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.height - 44 - 20 - 45) style:UITableViewStylePlain];
    _table.backgroundColor = [UIColor clearColor];
    _table.delegate = self;
    _table.dataSource = self;
    
    _table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _table.separatorInset = UIEdgeInsetsMake(0, 8, 0, 8);
    [self.view addSubview:_table];
    
    _table.tableHeaderView = [self createTableHeaderView];
    _table.tableFooterView = [self createTableFooterView];
    
    [self createInputView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 事件处理

//进入称赞者页
- (void)clickTOPraiseMember:(UIGestureRecognizer *)tap
{
    PraiseMemberController *praise = [[PraiseMemberController alloc]init];
    self.title = @"";
    [self PushToViewController:praise WithAnimation:YES];
}

//弹出赞视图
- (void)clickToZan:(UIButton *)sender
{
    NSLog(@"zan");
}
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
    SendPostsViewController * sendPostVC = [[SendPostsViewController alloc] init];
    [self PushToViewController:sendPostVC WithAnimation:YES];
}

/**
 *  进入置顶帖子
 */
- (void)clickToRecommend:(LButtonView *)btn
{
    
}

- (void)clickJoinBBS:(UIButton *)sender
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

- (void)createInputView
{
    inputView = [[LInputView alloc]initWithFrame:CGRectMake(0, self.view.height - 45 - 20 - 44, 320, 45)inView:self.view inputText:^(NSString *inputText) {

        NSLog(@"inputText %@",inputText);
        
    }];
    inputView.clearInputWhenSend = YES;
    inputView.resignFirstResponderWhenSend = YES;
    
    [self.view addSubview:inputView];
}

/**
 *  论坛基本信息部分
 */
- (UIView *)createBBSInfoViewFrame:(CGRect)aFrame
{
    UIView *basic_view = [[UIView alloc]initWithFrame:aFrame];
    basic_view.layer.cornerRadius = 3.f;
    
    //论坛name
    UILabel *nameLabel = [LTools createLabelFrame:CGRectMake(10, 0, 150, 40) title:@"汽车联赛" font:14 align:NSTextAlignmentLeft textColor:[UIColor blackColor]];
    [basic_view addSubview:nameLabel];
    
    //帖子数
    UILabel *numLabel = [LTools createLabelFrame:CGRectMake(nameLabel.right, 0, aFrame.size.width - nameLabel.width - 10 * 2, 40) title:@"5678帖子" font:13 align:NSTextAlignmentRight textColor:[UIColor colorWithHexString:@"90a1cd"]];
    [basic_view addSubview:numLabel];
    
    //精 帖
    
    NSArray *titles = @[@"改装商最好的广告 雪佛兰创酷",@"改装商雪佛兰创酷"];
    
    for (int i = 0; i < titles.count; i ++) {
        
        NSString *title = [titles objectAtIndex:i];

        LButtonView *btnV = [[LButtonView alloc]initWithFrame:CGRectMake(0, 40 + 40 * i, aFrame.size.width, 40) leftImage:[UIImage imageNamed:@"jing"] rightImage:[UIImage imageNamed:@"jiantou"] title:title target:self action:@selector(clickToRecommend:) lineDirection:Line_Up];
        [basic_view addSubview:btnV];
    }
    
    
    basic_view.backgroundColor = [UIColor whiteColor];
    aFrame.size.height = 40 * titles.count + 40;
    basic_view.frame = aFrame;
    return basic_view;
}

/**
 *  置顶帖子部分
 */
- (UIView *)createRecommendViewFrame:(CGRect)aFrame
{
    
    UIView *recommed_view = [[UIView alloc]init];
    recommed_view.backgroundColor = [UIColor whiteColor];
    recommed_view.layer.cornerRadius = 3.f;
    recommed_view.clipsToBounds = YES;
    
    //头像
    UIImageView *headImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 40, 40)];
    [headImage sd_setImageWithURL:[NSURL URLWithString:@"<#string#>"] placeholderImage:[UIImage imageNamed:@"Picture_default_image"]];
    [recommed_view addSubview:headImage];
    
    //楼主
    NSString *name = @"楼主名a奥";
    
    UILabel *nameLabel = [LTools createLabelFrame:CGRectMake(headImage.right + 10, headImage.top, [LTools widthForText:name font:14], 15) title:name font:14 align:NSTextAlignmentLeft textColor:[UIColor blackColor]];
    [recommed_view addSubview:nameLabel];
    
    UIButton *hintBtn = [LTools createButtonWithType:UIButtonTypeCustom frame:CGRectMake(nameLabel.right + 5, headImage.top, 35, 15) normalTitle:@"楼主" backgroudImage:nil superView:recommed_view target:nil action:nil];
    hintBtn.backgroundColor = [UIColor colorWithHexString:@"5c7bbe"];
    hintBtn.layer.cornerRadius = 3.f;
    [hintBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    
    //时间
    NSString *time = @"07-16";
    UILabel *timeLabel = [LTools createLabelFrame:CGRectMake(aFrame.size.width - 10 - [LTools widthForText:time font:12], nameLabel.top, [LTools widthForText:time font:12], nameLabel.height) title:time font:12 align:NSTextAlignmentRight textColor:[UIColor lightGrayColor]];
    [recommed_view addSubview:timeLabel];
    
    //正文
    
    NSString *text = @"这是一个帖子,不知道有多长呢，请多少准备呢，卡机是肯定就安静SD卡垃圾阿三空间打开垃圾抗衰老的阿克苏经典款垃圾是考虑到啊开始打开了家SD卡垃圾啊卡三季度可";
    UILabel *textLabel = [LTools createLabelFrame:CGRectMake(nameLabel.left, nameLabel.bottom + 2, aFrame.size.width - headImage.right - 20, [LTools heightForText:text width:aFrame.size.width - headImage.right - 20 font:12]) title:text font:12 align:NSTextAlignmentLeft textColor:[UIColor blackColor]];
    textLabel.numberOfLines = 0;
    [recommed_view addSubview:textLabel];
    
    //图片
    
    NSArray *imageUrls = @[@"ll",@"ok",@"ok",@"ok",@"ok"];
    LNineImagesView *nineView = [[LNineImagesView alloc]initWithFrame:CGRectMake(textLabel.left, textLabel.bottom + 5, textLabel.width, 0) images:imageUrls imageIndex:^(int index) {
        NSLog(@"slectIndex %d",index);
    }];
    [recommed_view addSubview:nineView];
    
    //赞
    
    UIView *zan_view = [[UIView alloc]initWithFrame:CGRectMake(-1, nineView.bottom + 10, aFrame.size.width + 2, 40)];
    zan_view.backgroundColor = [UIColor whiteColor];
    zan_view.layer.borderWidth = 1.f;
    zan_view.layer.borderColor = [UIColor colorWithHexString:@"f0f0f0"].CGColor;
    zan_view.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
    [recommed_view addSubview:zan_view];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickTOPraiseMember:)];
    [zan_view addGestureRecognizer:tap];
    
    UIImageView *zanImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, (40 - 16)/2.0, 16, 16)];
    zanImage.image = [UIImage imageNamed:@"zhiding"];
    [zan_view addSubview:zanImage];
    
    NSString *numberSter = @"112";
    UILabel *zan_num_label = [LTools createLabelFrame:CGRectMake(zanImage.right + 5, 0, [LTools widthForText:numberSter font:12], zan_view.height) title:numberSter font:12 align:NSTextAlignmentLeft textColor:[UIColor colorWithHexString:@"7083ad"]];
    [zan_view addSubview:zan_num_label];
    
    NSString *names = @"越野小豆、胡桃、小猴玩、猴子请来的逗比、卡卡拉卡拉";
    UILabel *zan_names_label = [LTools createLabelFrame:CGRectMake(zan_num_label.right + 5, 0, 240, zan_view.height) title:names font:12 align:NSTextAlignmentLeft textColor:[UIColor colorWithHexString:@"7083ad"]];
    [zan_view addSubview:zan_names_label];
    
    //时间
    UIView *time_view = [[UIView alloc]initWithFrame:CGRectMake(-1, zan_view.bottom, aFrame.size.width + 2, 40)];
    time_view.backgroundColor = [UIColor whiteColor];
    time_view.layer.borderWidth = 0.5f;
    time_view.layer.borderColor = [UIColor colorWithHexString:@"f0f0f0"].CGColor;
    [recommed_view addSubview:time_view];
    
    NSString *time_str = @"今天";
    UILabel *time_Label = [LTools createLabelFrame:CGRectMake(10, 0, 100, time_view.height) title:time_str font:14 align:NSTextAlignmentLeft textColor:[UIColor blackColor]];
    [time_view addSubview:time_Label];
    
    UIButton *zan_btn = [LTools createButtonWithType:UIButtonTypeCustom frame:CGRectMake(time_view.width - 10 - 30, 5, 30, 30) normalTitle:@"赞" backgroudImage:nil superView:time_view target:self action:@selector(clickToZan:)];
    [zan_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    aFrame.size.height = time_view.bottom;
    recommed_view.frame = aFrame;
    
    
    return recommed_view;
}

/**
 *  创建tableView的 headerView
 */
- (UIView *)createTableHeaderView
{
    UIView *headerView = [[UIView alloc]init];
    headerView.backgroundColor = [UIColor clearColor];
    //基本信息部分
    
    UIView *basic_view = [self createBBSInfoViewFrame:CGRectMake(8, 15, 304, 0)];
    [headerView addSubview:basic_view];
    
    UIView *recommed_view = [self createRecommendViewFrame:CGRectMake(8, basic_view.bottom + 15, 304, 0)];
    [headerView addSubview:recommed_view];
    
    headerView.frame = CGRectMake(0, 0, 320, basic_view.height + recommed_view.height + 15 + 15 +1);
    
    UIView *hh_view = [[UIView alloc]initWithFrame:CGRectMake(8, headerView.height - 10, 304, 10)];
    hh_view.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:hh_view];
    
    
    UIView *line_view = [[UIView alloc]initWithFrame:CGRectMake(8, headerView.height - 1, 304, 1)];
    line_view.backgroundColor = [UIColor colorWithHexString:@"f0f0f0"];
    [headerView addSubview:line_view];

    
    return headerView;
}

- (UIView *)createTableFooterView
{
    UIView *footer_view = [[UIView alloc]initWithFrame:CGRectMake(8, 0, 304, 45 + 15)];
    footer_view.backgroundColor = [UIColor clearColor];
    
    UIView *bg_view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 304, 45)];
    bg_view.backgroundColor = [UIColor whiteColor];
    bg_view.layer.cornerRadius = 3.f;
    [footer_view addSubview:bg_view];
    
    UIView *hh_view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 304, 10)];
    hh_view.backgroundColor = [UIColor whiteColor];
    [footer_view addSubview:hh_view];
    
    UIView *line_view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 304, 1)];
    line_view.backgroundColor = [UIColor colorWithHexString:@"f0f0f0"];
    [footer_view addSubview:line_view];

    
    
    UIButton *moreBtn = [LTools createButtonWithType:UIButtonTypeCustom frame:CGRectMake(10, 0, 150, footer_view.height) normalTitle:@"查看更多评论..." backgroudImage:nil superView:footer_view target:self action:@selector(clickToMore:)];
    [moreBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    moreBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    moreBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    return footer_view;
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
    return 75;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier3 = @"BBSRecommendCell";
    
    BBSRecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier3];
    if (cell == nil) {
        cell = [[BBSRecommendCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier3];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
   
    
    return cell;
    
}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    return footer_view;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 45;
//}

@end

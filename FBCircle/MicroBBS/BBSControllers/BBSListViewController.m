//
//  BBSListViewController.m
//  FBCircle
//
//  Created by lichaowei on 14-8-7.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "BBSListViewController.h"
#import "MyBBSViewController.h"
#import "HotTopicViewController.h"
#import "ClassifyBBSController.h"
#import "MicroBBSInfoController.h"
#import "SendPostsViewController.h"
#import "BBSTopicController.h"

#import "LTools.h"
#import "LSecionView.h"
#import "BBSListCell.h"
#import "SendPostsViewController.h"

#import "BBSInfoModel.h"
#import "TopicModel.h"

@interface BBSListViewController ()<UITableViewDataSource,UITableViewDelegate,RefreshDelegate>
{
    RefreshTableView *_table;
    BBSInfoModel *_aBBSModel;
}

@end

@implementation BBSListViewController

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
    
    self.titleLabel.text = self.navigationTitle;
    self.rightImageName = @"pen";

    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeNull WithRightButtonType:MyViewControllerRightbuttonTypeOther];
    
    [self.my_right_button addTarget:self action:@selector(clickToAddBBS) forControlEvents:UIControlEventTouchUpInside];
    
    //数据展示table
    _table = [[RefreshTableView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.height - 44 - 20) showLoadMore:NO];
    _table.backgroundColor = [UIColor clearColor];
    _table.refreshDelegate = self;
    _table.dataSource = self;
    
    _table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:_table];
    
    //获取论坛基本信息
    [self getBBSInfoId:self.bbsId];
    
    //帖子列表
    
    [self getBBSTopicList:self.bbsId];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 事件处理

//论坛信息页
- (void)clickToBBSInfo:(UIGestureRecognizer *)tap
{
    MicroBBSInfoController *bbsInfo = [[MicroBBSInfoController alloc]init];
    bbsInfo.bbsId = @"1";
    [self PushToViewController:bbsInfo WithAnimation:YES];
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
    HotTopicViewController *hotTopic = [[HotTopicViewController alloc]init];
    hotTopic.data_Style = sender.tag - 100;
    hotTopic.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:hotTopic animated:YES];
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
 *  添加帖子
 */
- (void)clickToAddBBS
{//张少南 这里需要论坛id
    SendPostsViewController * sendPostVC = [[SendPostsViewController alloc] init];
    sendPostVC.fid = self.bbsId;
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


#pragma mark - 网络请求

- (void)getBBSInfoId:(NSString *)bbsId
{
    __weak typeof(self)weakSelf = self;
    __weak typeof(UITableView *)weakTable = _table;
    
    NSString *url = [NSString stringWithFormat:FBCIRCLE_BBS_INFO,bbsId];
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        NSLog(@"result %@",result);
        NSDictionary *dataInfo = [result objectForKey:@"datainfo"];
        
        if ([dataInfo isKindOfClass:[NSDictionary class]]) {
            
            _aBBSModel = [[BBSInfoModel alloc]initWithDictionary:dataInfo];
            
            weakTable.tableHeaderView = [weakSelf createTableHeaderView];
            weakTable.tableFooterView = [weakSelf createTableFooterView];
            
            weakSelf.titleLabel.text = _aBBSModel.name;
            
        }
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        NSLog(@"result %@",failDic);
        
        [LTools showMBProgressWithText:[failDic objectForKey:@"ERRO_INFO"] addToView:self.view];
        
    }];
}

/**
 *  获取帖子列表
 *
 *  @param bbsId 论坛id
 */
- (void)getBBSTopicList:(NSString *)bbsId
{
    __weak typeof(RefreshTableView *)weakTable = _table;
    
    NSString *url = [NSString stringWithFormat:FBCIRCLE_TOPIC_LIST,bbsId];
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        NSLog(@"result %@",result);
        NSDictionary *dataInfo = [result objectForKey:@"datainfo"];
        
        if ([dataInfo isKindOfClass:[NSDictionary class]]) {
            
            NSArray *data = [dataInfo objectForKey:@"data"];
            NSMutableArray *arr = [NSMutableArray arrayWithCapacity:data.count];
            for (NSDictionary *aDic in data) {
                TopicModel *aModel = [[TopicModel alloc]initWithDictionary:aDic];
                [arr addObject:aModel];
            }
            
//            [weakTable reloadData];
            [weakTable reloadData:arr total:0];
        }
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        NSLog(@"result %@",failDic);
        
        [LTools showMBProgressWithText:[failDic objectForKey:@"ERRO_INFO"] addToView:self.view];
        [weakTable loadFail];
        
    }];
}



#pragma mark - 视图创建

/**
 *  论坛基本信息部分
 */
- (UIView *)createBBSInfoViewFrame:(CGRect)aFrame
{
    //论坛
    UIView *basic_view = [[UIView alloc]initWithFrame:aFrame];
    basic_view.backgroundColor = [UIColor whiteColor];
    
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 12, 53, 53)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:_aBBSModel.headpic] placeholderImage:[UIImage imageNamed:@"Picture_default_image"]];
    [basic_view addSubview:imageView];
    
    UILabel *titleLabel = [LTools createLabelFrame:CGRectMake(imageView.right + 10, imageView.top,150, 25) title:_aBBSModel.name font:14 align:NSTextAlignmentLeft textColor:[UIColor blackColor]];
    [basic_view addSubview:titleLabel];
    
    UILabel *memberLabel = [LTools createLabelFrame:CGRectMake(titleLabel.left, titleLabel.bottom,25, 25) title:@"成员" font:12 align:NSTextAlignmentLeft textColor:[UIColor lightGrayColor]];
    [basic_view addSubview:memberLabel];
    
    UILabel *memberLabel_num = [LTools createLabelFrame:CGRectMake(memberLabel.right, titleLabel.bottom,50, 25) title:_aBBSModel.member_num font:12 align:NSTextAlignmentLeft textColor:[UIColor colorWithHexString:@"91a2ce"]];
    [basic_view addSubview:memberLabel_num];
    
    
    UIImageView *line_h = [[UIImageView alloc]initWithFrame:CGRectMake(memberLabel_num.right + 5, memberLabel_num.top + memberLabel_num.height / 4.f, 1, memberLabel_num.height / 2.f)];
    line_h.backgroundColor = [UIColor lightGrayColor];
    [basic_view addSubview:line_h];
    
    
    UILabel *topicLabel = [LTools createLabelFrame:CGRectMake(line_h.right + 5, titleLabel.bottom,25, 25) title:@"成员" font:12 align:NSTextAlignmentLeft textColor:[UIColor lightGrayColor]];
    [basic_view addSubview:topicLabel];
    
    UILabel *topicLabel_num = [LTools createLabelFrame:CGRectMake(topicLabel.right, titleLabel.bottom,50, 25) title:_aBBSModel.thread_num font:12 align:NSTextAlignmentLeft textColor:[UIColor colorWithHexString:@"91a2ce"]];
    [basic_view addSubview:topicLabel_num];
    
    UIImageView *arrow_image = [[UIImageView alloc]initWithFrame:CGRectMake(320 - 12 - 8, basic_view.height/2.f - 13/2.f, 8, 13)];
    arrow_image.image = [UIImage imageNamed:@"jiantou"];
    [basic_view addSubview:arrow_image];
    
    return basic_view;
}

/**
 *  置顶帖子部分
 */
- (UIView *)createRecommendViewFrame:(CGRect)aFrame
{
    NSArray *titles = @[@"改装商最好的广告 雪佛兰创酷",@"阿喀琉斯就打开啦"];
    
    UIView *recommed_view = [[UIView alloc]init];
    recommed_view.backgroundColor = [UIColor whiteColor];
    recommed_view.layer.cornerRadius = 3.f;
    
    for (int i = 0; i < titles.count; i ++) {
       
        NSString *title = [titles objectAtIndex:i];
        
        LButtonView *btnV = [[LButtonView alloc]initWithFrame:CGRectMake(0, 40 * i, 304, 40) leftImage:[UIImage imageNamed:@"qi"] title:title target:self action:@selector(clickToRecommend:)];
        [recommed_view addSubview:btnV];
    }
    
    aFrame.size.height = 40 * titles.count;
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
    
    UIView *basic_view = [self createBBSInfoViewFrame:CGRectMake(0, 0, 320, 75)];
    [headerView addSubview:basic_view];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickToBBSInfo:)];
    [basic_view addGestureRecognizer:tap];
    
    
    UIView *recommed_view = [self createRecommendViewFrame:CGRectMake(8, basic_view.bottom + 15, 304, 80)];
    [headerView addSubview:recommed_view];
    
    UIButton *btn = [LTools createButtonWithType:UIButtonTypeCustom frame:CGRectMake(8, recommed_view.bottom + 15, 304, 93 / 2.f) normalTitle:nil backgroudImage:[UIImage imageNamed:@"jiaruluntan"] superView:headerView target:self action:@selector(clickJoinBBS:)];
    
    headerView.frame = CGRectMake(0, 0, 320, basic_view.height + recommed_view.height + 15 + 15 + btn.height + 15);
    
    return headerView;
}

/**
 *  创建tableView的 headerView
 */
- (UIView *)createTableFooterView
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 10)];
    headerView.backgroundColor = [UIColor clearColor];
    
    return headerView;
}


#pragma mark - delegate


#pragma - mark RefreshDelegate <NSObject>

- (void)loadNewData
{
    NSLog(@"loadNewData");
    //获取论坛基本信息
    [self getBBSInfoId:self.bbsId];
    
    //帖子列表
    
    [self getBBSTopicList:self.bbsId];
}

- (void)loadMoreData
{
    NSLog(@"loadMoreData");
}

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TopicModel *aModel = [_table.dataArray objectAtIndex:indexPath.row];
    BBSTopicController *topic = [[BBSTopicController alloc]init];
    topic.fid = aModel.fid;
    topic.tid = aModel.tid;
    [self PushToViewController:topic WithAnimation:YES];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _table.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier3 = @"BBSListCell";
    
    BBSListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier3];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"BBSListCell" owner:self options:nil]objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    if (indexPath.row == 0 || indexPath.row == _table.dataArray.count - 1) {
        
        cell.bgView.layer.cornerRadius = 3.f;
        
        if (indexPath.row == 0) {
            cell.upMask.hidden = YES;
        }else
        {
            cell.downMask.hidden = YES;
        }
        
    }else
    {
        cell.bgView.layer.cornerRadius = 0.f;
    }
    
    cell.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
    TopicModel *aModel = [_table.dataArray objectAtIndex:indexPath.row];
    [cell setCellDataWithModel:aModel];
    
    return cell;
    
}

@end

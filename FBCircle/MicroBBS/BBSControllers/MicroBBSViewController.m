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
#import "BBSInfoModel.h"
#import "TopicModel.h"

#define CACHE_MY_BBS @"mybbs" //我的论坛
#define CACHE_HOT_TOPIC @"hotTopic" //热门推荐
#define CACHE_CONCERN_HOT @"concern_hot" //关注热门

@interface MicroBBSViewController ()<UISearchBarDelegate,RefreshDelegate,UITableViewDataSource>
{
    RefreshTableView *_table;
    NSArray *_myBBSArray;//我的论坛
    NSArray *_concern_hot_array;//关注热门
    NSArray *_hot_array;//热门
    
    
    BOOL my_bbs_success;//我的论坛
    BOOL hot_recommend;//热门推荐
    
    UIView *headerView;
    UIView *_mybbsView;
    UIView *_recommendView;
    
    BOOL _needRefresh;
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
    
    NSLog(@"auteykey %@",[SzkAPI getAuthkey]);
    
    if (_needRefresh) {
        
        
        [_table showRefreshNoOffset];
        
        
        _needRefresh = NO;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"d3d6db"];
    
    self.title = @"微论坛";
    self.titleLabel.text = @"微论坛";
    self.rightImageName = @"+";
    self.leftString = @"分类论坛";
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeText WithRightButtonType:MyViewControllerRightbuttonTypeOther];
    [self.my_right_button addTarget:self action:@selector(clickToAddBBS) forControlEvents:UIControlEventTouchUpInside];
    [self.left_button addTarget:self action:@selector(clickToClassifyBBS) forControlEvents:UIControlEventTouchUpInside];
    
    //数据展示table
    _table = [[RefreshTableView alloc]initWithFrame:CGRectMake(0,0, 320, self.view.height - 44 - 49 - 20) showLoadMore:NO];
    _table.backgroundColor = [UIColor clearColor];
    _table.refreshDelegate = self;
    _table.dataSource = self;
    
    _table.hiddenLoadMore = YES;
    
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_table];
    
    UIView *footer_view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 15)];
    footer_view.backgroundColor = [UIColor clearColor];
    _table.tableFooterView = footer_view;
    
    //缓存数据
    
    NSDictionary *dataInfo = [LTools cacheForKey:CACHE_MY_BBS];
    
    if (dataInfo) {
        
        _myBBSArray = [self parseForMyBBS:dataInfo];
        _table.tableHeaderView = [self createTableHeaderView];
        
        
        dataInfo = [LTools cacheForKey:CACHE_HOT_TOPIC];
        
        if (dataInfo) {
            _hot_array = [self parseTopic:dataInfo dataStyle:0];
        }
        
        [self createSecond];
    }
    
    dataInfo = [LTools cacheForKey:CACHE_CONCERN_HOT];
    if (dataInfo) {
        _concern_hot_array = [self parseTopic:dataInfo dataStyle:1];
        [_table reloadData];
    }
    
    [self loadNewData];
    
    //更新数据
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateBBS:) name:NOTIFICATION_UPDATE_TOPICLIST object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateBBS:) name:NOTIFICATION_UPDATE_BBS_JOINSTATE object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateBBS:) name:SUCCESSLOGIN object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 事件处理

- (void)updateBBS:(NSNotification *)sender
{
    _needRefresh = YES;
}

//进入我的论坛

- (void)clickToMyBBS:(UIButton *)sender
{
    MyBBSViewController *myBBS = [[MyBBSViewController alloc]init];
    [self PushToViewController:myBBS WithAnimation:YES];
}

- (void)clickToMore:(UIButton *)sender
{
    HotTopicViewController *hotTopic = [[HotTopicViewController alloc]init];
    hotTopic.data_Style = sender.tag - 100;
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
- (void)clickToBBSList:(UIButton *)sender
{
    BBSInfoModel *aModel = [_myBBSArray objectAtIndex:sender.tag - 100];
    BBSListViewController *list = [[BBSListViewController alloc]init];
    list.bbsId = aModel.fid;
    [self PushToViewController:list WithAnimation:YES];
}

/**
 *  帖子详情(从热门推荐进入)
 */
- (void)clickToTopicInfo:(LBBSCellView *)sender
{
    TopicModel *aModel = [_hot_array objectAtIndex:sender.tag - 1000];
    BBSTopicController *topic = [[BBSTopicController alloc]init];
    
    topic.fid = aModel.fid;
    topic.tid = aModel.tid;
    
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

#pragma mark - 数据解析

/**
 *  我的论坛
 */
- (NSArray *)parseForMyBBS:(NSDictionary *)dataInfo
{
    NSArray *create = [dataInfo objectForKey:@"create"];
    
    NSMutableArray *arr_mine = [NSMutableArray arrayWithCapacity:create.count];
    
    for (NSDictionary *aDic in create) {
        
        //status:论坛状态（0:正常   1:删除    2:审核中）
            
        int status = [[aDic objectForKey:@"forum_status"]integerValue];
        if (status == 0) {
            
            [arr_mine addObject:[[BBSInfoModel alloc]initWithDictionary:aDic]];
        }
        
        if (arr_mine.count == 3) {
            return arr_mine;
        }
    }
    
    NSArray *join = [dataInfo objectForKey:@"join"];
    for (NSDictionary *aDic in join) {
        
        int status = [[aDic objectForKey:@"forum_status"]integerValue];
        if (status == 0) {
            
            BBSInfoModel *info = [[BBSInfoModel alloc]initWithDictionary:aDic];
            
            if (info.name.length > 0) {
                [arr_mine addObject:info];
            }
            
        }
        
        if (arr_mine.count == 3) {
            return arr_mine;
        }
    }
    
    return arr_mine;
}

/**
 *  推荐热门和关注热门
 *  @param dataStyle 区分
 */
- (NSArray *)parseTopic:(NSDictionary *)result dataStyle:(int)dataStyle
{
    NSArray *dataInfo;
    
    if (dataStyle == 0) {
        dataInfo = [result objectForKey:@"datainfo"];
    }else if (dataStyle == 1){
        dataInfo = [result objectForKey:@"data"];
    }
    
    
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:dataInfo.count];
    for (NSDictionary *aDic in dataInfo) {
        
        if ([aDic isKindOfClass:[NSDictionary class]]) {
            int max = (dataStyle == 0) ? 2 : 15;
            
            if (arr.count < max) {
                TopicModel *aModel = [[TopicModel alloc]initWithDictionary:aDic];
                [arr addObject:aModel];
            }
        }
        
    }
    return arr;
}

#pragma mark - 网络请求

/**
 *  我创建和加入的论坛
 */
- (void)getMyBBS
{
    //先读取缓存数据
    
    __weak typeof(self)weakSelf = self;
    __weak typeof(RefreshTableView *)weakTable = _table;
    
    NSString *url = [NSString stringWithFormat:FBCIRCLE_BBS_MINE,[SzkAPI getAuthkey],1,L_PAGE_SIZE];
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
    
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        NSLog(@"result %@",result);
        NSDictionary *dataInfo = [result objectForKey:@"datainfo"];
        
        if ([dataInfo isKindOfClass:[NSDictionary class]]) {
            
//            NSDictionary *oldDataInfo = [LTools cacheForKey:CACHE_MY_BBS];
            
            my_bbs_success = YES;
            
//            if ([dataInfo JSONString].length != [oldDataInfo JSONString].length) {
            
                NSLog(@"CACHE_MY_BBS 有更新");
                
                [LTools cache:dataInfo ForKey:CACHE_MY_BBS];
                
                //一共需要三个,优先“创建的论坛”,不够再用“加入的论坛”
                
                _myBBSArray = [weakSelf parseForMyBBS:dataInfo];
                
                weakTable.tableHeaderView = [weakSelf createTableHeaderView];
                
                if (hot_recommend) {
                    [weakSelf createSecond];
                }
//            }
        }
     
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        NSLog(@"result %@",failDic);
        
        [LTools showMBProgressWithText:[failDic objectForKey:ERROR_INFO] addToView:self.view];
        _myBBSArray = nil;
        
        weakTable.tableHeaderView = [weakSelf createTableHeaderView];
        if (hot_recommend) {
            [weakSelf createSecond];
        }
    }];
}

/**
 *  获取热门推荐和 关注热门
 *
 *  @param dataStyle 0 热门推荐、1 关注热门
 */
- (void)getTopic:(int)dataStyle
{
    __weak typeof(self)weakSelf = self;
    __weak typeof(RefreshTableView *)weakTable = _table;
    
    NSString *url;
    if (dataStyle == 0) {
        
        url = [NSString stringWithFormat:FBCIRCLE_TOPIC_LIST_HOT];//热门帖子(最多两个)
    }else
    {
        url = [NSString stringWithFormat:FBCIRCLE_TOPIC_LIST_MYJOIN,[SzkAPI getAuthkey],1,15];//关注热门帖子(最多15个)
        
        NSLog(@"---->concern %@",url);
    }
    
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
        
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        NSLog(@"result %@",result);
        
        if (dataStyle == 0) {
            //热门帖子
            
            hot_recommend = YES;

//            NSDictionary *oldDataInfo = [LTools cacheForKey:CACHE_HOT_TOPIC];
            
//            if ([result JSONString].length != [oldDataInfo JSONString].length)
//            {
                NSLog(@"CACHE_HOT_TOPIC 有更新");
                
                [LTools cache:result ForKey:CACHE_HOT_TOPIC];
                
                _hot_array = [self parseTopic:result dataStyle:dataStyle];
                
                if (my_bbs_success) {
                    [weakSelf createSecond];
                }
//            }
            
        }else if (dataStyle == 1)
        {
            //关注帖子
//            NSDictionary *oldDataInfo = [LTools cacheForKey:CACHE_CONCERN_HOT];
//            
//            if ([result JSONString].length != [oldDataInfo JSONString].length)
//            {
                NSLog(@"CACHE_CONCERN_HOT 有更新");
            
            NSDictionary *datainfo = [result objectForKey:@"datainfo"];
            
                @try{
                    
                    [LTools cache:datainfo ForKey:CACHE_CONCERN_HOT];
                    
                    _concern_hot_array = [self parseTopic:datainfo dataStyle:dataStyle];

                }
                @catch(NSException *exception) {
                    NSLog(@"异常错误是:%@", exception);
                }  
                @finally {  
                    
                }
                
                
//            }
            
            [weakTable reloadData:nil total:0];
        }
        
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        NSLog(@"result %@",failDic);
        
        
        if (dataStyle == 1)
        {
//            [LTools showMBProgressWithText:[failDic objectForKey:ERROR_INFO] addToView:self.view];
            int errcode = [[failDic objectForKey:@"errcode"]integerValue];
            if (errcode == 2) {
                
                [LTools cache:nil ForKey:CACHE_CONCERN_HOT];
                _concern_hot_array = nil;
                
            }
        }
        
        [weakTable loadFail];
        
        
    }];
}



#pragma mark - 视图创建

/**
 *  搜索view
 */
- (UIView *)createSearchView
{
    UIView *search_bgview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 45)];
    search_bgview.backgroundColor = [UIColor colorWithHexString:@"cac9ce"];
    [self.view addSubview:search_bgview];

    UISearchBar *bar = [[UISearchBar alloc]initWithFrame:CGRectMake(5, 0, 310, 45)];
    bar.placeholder = @"搜索";
    bar.backgroundColor = [UIColor clearColor];
    bar.delegate = self;
    [search_bgview addSubview:bar];
    return search_bgview;
}

/**
 *  计算我的论坛最佳宽度
 */
- (CGFloat)fitWidth:(NSArray *)arr
{
    if (arr.count <= 1) {
        return 300.f;
    }
    NSString *title1 = ((BBSInfoModel *)[arr objectAtIndex:0]).name;
    NSString *title2 = ((BBSInfoModel *)[arr objectAtIndex:1]).name;
    
    NSString *title3 = @"";
    if (arr.count == 3) {
        title3 = ((BBSInfoModel *)[arr objectAtIndex:2]).name;
    }
    
    if (title1.length <= 6 && title2.length <= 6 && title3.length <= 6) {
        return 100.f;
    }
    
    return 150.f;
}

- (UIView *)createTableHeaderView
{
    if (headerView) {
        [headerView removeFromSuperview];
        headerView = nil;
    }
    
    headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 100)];
    headerView.backgroundColor = [UIColor clearColor];
    
    //搜索view
    
    UIView *search = [self createSearchView];
    [headerView addSubview:search];
    
    //我的论坛
    
    _mybbsView = [[UIView alloc]initWithFrame:CGRectMake(8, 20 + 45, 304, 80)];
    _mybbsView.layer.cornerRadius = 3.f;
    _mybbsView.clipsToBounds = YES;
    [headerView addSubview:_mybbsView];
    
    LSecionView *section = [[LSecionView alloc]initWithFrame:CGRectMake(0, 0, 304, 40) title:@"我的论坛" target:self action:@selector(clickToMyBBS:)];
    [_mybbsView addSubview:section];
    
    UIView *secondBgView = [[UIView alloc]initWithFrame:CGRectMake(section.left, section.bottom ,section.width, 40)];
    secondBgView.backgroundColor = [UIColor whiteColor];
    [_mybbsView addSubview:secondBgView];
    
    CGFloat aWidth = [self fitWidth:_myBBSArray];
    
    for (int i = 0 ; i < _myBBSArray.count; i ++) {
        
        if ((i + 1) * aWidth <= 300) {
            NSString *title = ((BBSInfoModel *)[_myBBSArray objectAtIndex:i]).name;
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [btn setTitle:title forState:UIControlStateNormal];
            [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
            btn.frame = CGRectMake(aWidth * i, 0, aWidth, 40);
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [secondBgView addSubview:btn];
            btn.tag = 100 + i;
            [btn addTarget:self action:@selector(clickToBBSList:) forControlEvents:UIControlEventTouchUpInside];
            
            if (i != 2 && i != (300 / aWidth - 1)) {
                UIView *line = [[UIView alloc]initWithFrame:CGRectMake(btn.right, 10, 1, 20)];
                line.backgroundColor = [UIColor colorWithHexString:@"dfdfdf"];
                [secondBgView addSubview:line];
            }
        }
    }
    
    headerView.frame = CGRectMake(0, 0, 320, _mybbsView.bottom + 15);
    
    return headerView;
}

/**
 *  创建热门推荐部分
 */
- (void)createSecond
{
    //热门推荐
    
    if (_recommendView) {
        [_recommendView removeFromSuperview];
        _recommendView = nil;
    }
    
    _recommendView = [[UIView alloc]init];
    _recommendView.layer.cornerRadius = 3.f;
    _recommendView.clipsToBounds = YES;
    [headerView addSubview:_recommendView];
    
    LSecionView *section2 = [[LSecionView alloc]initWithFrame:CGRectMake(0, 0, 304, 40) title:@"热门推荐" target:self action:@selector(clickToMore:)];
    section2.rightBtn.tag = 100;
    [_recommendView addSubview:section2];
    
    
    //推荐列表
    for (int i = 0; i < _hot_array.count; i ++) {
        
        TopicModel *aModel = [_hot_array objectAtIndex:i];
        
        LBBSCellView *cell_view = [[LBBSCellView alloc]initWithFrame:CGRectMake(0, section2.bottom + 75 * i, 320, 75) target:self action:@selector(clickToTopicInfo:)];
        cell_view.backgroundColor = [UIColor whiteColor];
        [_recommendView addSubview:cell_view];
        cell_view.tag = 1000 + i;
        
        [cell_view setCellWithModel:aModel];
        
        if (i < 1) {
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, cell_view.bottom - 1, 304, 1)];
            line.backgroundColor = [UIColor colorWithHexString:@"dfdfdf"];
            [_recommendView addSubview:line];
        }
    }
    
    _recommendView.frame = CGRectMake(8, _mybbsView.bottom + 15, 304, section2.height + 75 * _hot_array.count);
    
    headerView.frame = CGRectMake(0, 0, 320, _recommendView.bottom + 15);
    
    _table.tableHeaderView = headerView;
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
    
    //我的论坛
    
    [self getMyBBS];
    
    [self getTopic:0];
    
    //我的关注热门
    
    [self getTopic:1];
}

- (void)loadMoreData
{
    NSLog(@"loadMoreData");
}

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= 1) {
        TopicModel *aModel = [_concern_hot_array objectAtIndex:indexPath.row - 1];
        BBSTopicController *topic = [[BBSTopicController alloc]init];
        
        topic.fid = aModel.fid;
        topic.tid = aModel.tid;
        
        [self PushToViewController:topic WithAnimation:YES];
    }
    
}
- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
        return 40;
    }
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
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_concern_hot_array.count > 0) {
        return _concern_hot_array.count + 1;
    }
    return _concern_hot_array.count;
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
        section.rightBtn.tag = 101;
        [cell addSubview:section];
        
        section.layer.cornerRadius = 3.f;
        
        return cell;
    }
    
    BBSTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier3];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"BBSTableCell" owner:self options:nil]objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == _concern_hot_array.count) {
        
        cell.bgView.layer.cornerRadius = 3.f;
    }else
    {
        cell.bgView.layer.cornerRadius = 0.f;
    }
    TopicModel *aModel = [_concern_hot_array objectAtIndex:indexPath.row - 1];
    [cell setCellWithModel:aModel];
    
    return cell;
    
}


@end


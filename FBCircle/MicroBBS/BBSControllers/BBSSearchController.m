//
//  BBSSearchController.m
//  FBCircle
//
//  Created by lichaowei on 14-8-12.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "BBSSearchController.h"

@interface BBSSearchController ()<UITableViewDataSource,RefreshDelegate>
{
    RefreshTableView *_table;
    NSArray *_dataArray;
    UIView *navigationView;
    LSearchView *searchView;
    
    NSString *keyword;
    
    int search_tag;// 1 搜索论坛 2 搜索帖子
}

@end

@implementation BBSSearchController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [navigationView removeFromSuperview];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController.navigationBar addSubview:navigationView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.rightString = @"取消";
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeText WithRightButtonType:MyViewControllerRightbuttonTypeText];
    
    [self.my_right_button addTarget:self action:@selector(clickToBack:) forControlEvents:UIControlEventTouchUpInside];
    self.my_right_button.titleLabel.font = [UIFont systemFontOfSize:14];
    
    //搜索
    [self createSearchView];
    
    //切换
    
    [self createSwapView];
    
    //数据展示table
    _table = [[RefreshTableView alloc]initWithFrame:CGRectMake(0, 45, 320, self.view.height - 44 - 20)];
    _table.refreshDelegate = self;
    _table.dataSource = self;
    _table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _table.separatorInset = UIEdgeInsetsMake(0, 1, 0, 0);
    [self.view addSubview:_table];
    
    //创建清空按钮
    
    [self createMoveView];
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

- (void)clickToBack:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickToSwap:(LButtonView *)sender
{
    sender.selected = YES;
    if (sender.tag == 100) {
        NSLog(@"微论坛");
        LButtonView *btn = (LButtonView *)[self.view viewWithTag:101];
        btn.selected = NO;
        search_tag = 1;
        
    }else
    {
        NSLog(@"搜帖子");
        LButtonView *btn = (LButtonView *)[self.view viewWithTag:100];
        btn.selected = NO;
        search_tag = 2;
    }
    //只要切换 pageNum置为 1
    _table.pageNum = 1;
}

- (void)clickToClearHistory:(UIButton *)sender
{
    NSLog(@"clear");
}

#pragma mark - 网络请求

- (void)searchKeyword:(NSString *)aKeyword
{
    keyword = aKeyword;
    
    NSString *url;
    if (search_tag == 1) {
        NSLog(@"论坛");
        url = [NSString stringWithFormat:FBCIRCLE_SEARCH_BBS,keyword,_table.pageNum,PAGE_SIZE];
    }else
    {
        url = [NSString stringWithFormat:FBCIRCLE_SEARCH_BBS,keyword,_table.pageNum,PAGE_SIZE];
        NSLog(@"帖子");
    }
    
    __weak typeof(self)weakSelf = self;
    
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        NSLog(@"result %@",result);
        NSArray *dataInfo = [result objectForKey:@"datainfo"];
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:dataInfo.count];
//        for (NSDictionary *aDic in dataInfo) {
//            
//            [arr addObject:[[BBSModel alloc]initWithDictionary:aDic]];
//        }
//        
//        [weakSelf createFirstViewWithTitles:arr];
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        NSLog(@"result %@",failDic);
    }];
}

#pragma mark - 视图创建

- (void)createSearchView
{
    navigationView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320 - 50, 44)];
    navigationView.backgroundColor = [UIColor clearColor];
    
    [self.navigationController.navigationBar addSubview:navigationView];
    
    __weak typeof(self)weakSelf = self;
    //搜索
    searchView = [[LSearchView alloc]initWithFrame:CGRectMake(10, (44 - 30)/2.0, 530/2.f, 30) placeholder:@"请输入关键词搜索微论坛" logoImage:[UIImage imageNamed:@"search"] maskViewShowInView:nil searchBlock:^(SearchStyle actionStyle, NSString *searchText) {
        if (actionStyle == Search_Search) {
            [weakSelf searchKeyword:searchText];
        }
        
    }];
    
    [navigationView addSubview:searchView];
}

- (void)createSwapView
{
    UIImageView *bgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    bgView.image = [UIImage imageNamed:@"BBS-kuang"];
    [self.view addSubview:bgView];
    
    LButtonView *btn = [[LButtonView alloc]initWithFrame:CGRectMake(0, 0, 160, 43) leftImage:nil rightImage:nil title:@"搜微论坛" target:self action:@selector(clickToSwap:) lineDirection:Line_No];
    [self.view addSubview:btn];
    btn.layer.cornerRadius = 0.f;
    btn.backgroundColor = [UIColor colorWithHexString:@"f0f0f3"];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    btn.selcted_TitleColor = [UIColor colorWithHexString:@"627bbd"];
    btn.selected = YES;
    
    search_tag = 1;//默认初始值
    
    
    btn.tag = 100;
    
    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(btn.right, 0, 0.5, 43)];
    line.image = [UIImage imageNamed:@"line"];
    line.contentMode = UIViewContentModeCenter;
    [self.view addSubview:line];
    
    LButtonView *btn2 = [[LButtonView alloc]initWithFrame:CGRectMake(line.right, 0, 160, 43) leftImage:nil rightImage:nil title:@"搜帖子" target:self action:@selector(clickToSwap:) lineDirection:Line_No];
    [self.view addSubview:btn2];
    btn2.layer.cornerRadius = 0.f;
    btn2.backgroundColor = [UIColor colorWithHexString:@"f0f0f3"];
    btn2.titleLabel.textAlignment = NSTextAlignmentCenter;
    btn2.tag = 101;
    btn2.selcted_TitleColor = [UIColor colorWithHexString:@"627bbd"];
}

- (void)createMoveView
{
    LMoveView *move = [[LMoveView alloc]initWithFrame:CGRectMake(0, self.view.height - 45 - 20 - 44, 320, 44)];
    [self.view addSubview:move];
    
    UIImageView *bgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    bgView.image = [UIImage imageNamed:@"BBS-kuang-up"];
    [move addSubview:bgView];
    
    LButtonView *btn = [[LButtonView alloc]initWithFrame:CGRectMake(0, 1, move.width, move.height - 1) leftImage:Nil rightImage:Nil title:@"清空历史记录" target:self action:@selector(clickToClearHistory:) lineDirection:Line_Up];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    btn.backgroundColor = [UIColor clearColor];
    
    [move addSubview:btn];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn.titleLabel setTextColor:[UIColor colorWithHexString:@"b7b7b7"]];
    
    [searchView.searchField becomeFirstResponder];
    
}

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
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString * identifier = @"HotTopicCell";
//    
//    HotTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//    if (cell == nil) {
//        cell = [[[NSBundle mainBundle]loadNibNamed:@"HotTopicCell" owner:self options:nil]objectAtIndex:0];
//    }
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    
    return nil;
    
}

@end

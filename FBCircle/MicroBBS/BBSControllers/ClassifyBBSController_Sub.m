//
//  ClassifyBBSController_Sub.m
//  FBCircle
//
//  Created by lichaowei on 14-8-6.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "ClassifyBBSController_Sub.h"
#import "MicroBBSInfoController.h"
#import "BBSSearchController.h"
#import "JoinBBSCell.h"
#import "BBSInfoModel.h"

@interface ClassifyBBSController_Sub ()<UISearchBarDelegate,RefreshDelegate,UITableViewDataSource>
{
    RefreshTableView *_table;
    NSArray *_dataArray;
}

@end

@implementation ClassifyBBSController_Sub

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
    
    //搜索
    [self createSearchView];
    
    //数据展示table
    _table = [[RefreshTableView alloc]initWithFrame:CGRectMake(0, 45, 320, self.view.height - 44 - 45 - 20)];
    _table.backgroundColor = [UIColor clearColor];
    _table.refreshDelegate = self;
    _table.dataSource = self;
    
    _table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _table.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view addSubview:_table];
    
    [_table showRefreshHeader:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    _table.refreshDelegate = nil;
}

#pragma mark - 事件处理

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

- (void)getDataWithClassId:(NSString *)classId
{
    __weak typeof(_table)weakTable = _table;
    
    NSString *url = [NSString stringWithFormat:FBCIRCLE_CLSSIFYBBS_SUB,[SzkAPI getAuthkey],_table.pageNum,L_PAGE_SIZE,classId];
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        NSLog(@"result %@",result);
        NSDictionary *dataInfo = [result objectForKey:@"datainfo"];
        
        if ([dataInfo isKindOfClass:[NSDictionary class]]) {
            
            int total = [[dataInfo objectForKey:@"total"]integerValue];
            NSArray *data = [dataInfo objectForKey:@"data"];
            
            NSMutableArray *arr = [NSMutableArray arrayWithCapacity:dataInfo.count];
            for (NSDictionary *aDic in data) {
                
                [arr addObject:[[BBSInfoModel alloc]initWithDictionary:aDic]];
            }
            
            [weakTable reloadData:arr total:total];
        }
        
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        NSLog(@"result %@",failDic);
        
        [LTools showMBProgressWithText:[failDic objectForKey:@"ERRO_INFO"] addToView:self.view];
        
        [weakTable loadFail];
    }];
}

/**
 *  加入论坛
 *
 *  @param bbsId 论坛id
 */
- (void)JoinBBSId:(NSString *)bbsId
{
    __weak typeof(self)weakSelf = self;
    
    NSString *url = [NSString stringWithFormat:FBCIRCLE_BBS_MEMBER_JOIN,[SzkAPI getAuthkey],bbsId];
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        NSLog(@"result %@",result);
        NSDictionary *dataInfo = [result objectForKey:@"datainfo"];
        
        if ([dataInfo isKindOfClass:[NSDictionary class]]) {
            
            [LTools showMBProgressWithText:[result objectForKey:@"ERRO_INFO"] addToView:self.view];
        }
        
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        NSLog(@"result %@",failDic);
        
        [LTools showMBProgressWithText:[failDic objectForKey:@"ERRO_INFO"] addToView:self.view];
    }];
    
}


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
    
    //请求单个分类下所有论坛
    [self getDataWithClassId:self.class_id];
}

- (void)loadMoreData
{
    NSLog(@"loadMoreData");
    [self getDataWithClassId:self.class_id];
}

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    BBSSubModel *aModel = [_table.dataArray objectAtIndex:indexPath.row];
//
//    MicroBBSInfoController *bbsInfo = [[MicroBBSInfoController alloc]init];
//    bbsInfo.bbsId = aModel.id;
//    [self PushToViewController:bbsInfo WithAnimation:YES];
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
    return [_table.dataArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier= @"JoinBBSCell";
    
    JoinBBSCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"JoinBBSCell" owner:self options:nil]objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    __weak typeof(self)weakSelf = self;
    __weak typeof(JoinBBSCell *)weakCell = cell;
    BBSSubModel *aModel = [_table.dataArray objectAtIndex:indexPath.row];
    [cell setCellDataWithModel:aModel cellBlock:^(NSString *topicId) {
        NSLog(@"join topic id %@",topicId);
        [weakSelf JoinBBSId:topicId];
        
        weakCell.joinButton.selected = YES;
    }];
    return cell;
    
}

@end

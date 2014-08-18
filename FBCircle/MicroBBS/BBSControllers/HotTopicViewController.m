//
//  HotTopicViewController.m
//  FBCircle
//
//  Created by lichaowei on 14-8-6.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "HotTopicViewController.h"
#import "BBSTopicController.h"
#import "LTools.h"
#import "HotTopicCell.h"
#import "TopicModel.h"

@interface HotTopicViewController ()<UITableViewDataSource,RefreshDelegate>
{
    RefreshTableView *_table;
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
    
    NSString *title;
    if (self.data_Style == 0) {
        
        title = @"热门推荐";
    }else
    {
        title = @"热门帖子";
    }
    
    self.titleLabel.text = title;
    
    //数据展示table
    _table = [[RefreshTableView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.height - 44 - 20)];
    _table.refreshDelegate = self;
    _table.dataSource = self;
    _table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _table.separatorInset = UIEdgeInsetsMake(0, 1, 0, 0);
    [self.view addSubview:_table];
    
//    [self getTopic];
    
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

//进入我的论坛

- (void)clickToMyBBS:(UIButton *)sender
{
    
}


#pragma mark - 网络请求

- (void)getTopic
{
    __weak typeof(self)weakSelf = self;
    __weak typeof(RefreshTableView *)weakTable = _table;

    NSString *url;
    if (self.data_Style == 0) {
        
        url = [NSString stringWithFormat:FBCIRCLE_TOPIC_LIST_HOT];//热门帖子
    }else
    {
        url = [NSString stringWithFormat:FBCIRCLE_TOPIC_LIST_MYJOIN,[SzkAPI getAuthkey]];//关注热门帖子
    }
    
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        NSLog(@"result %@",result);
        NSArray *dataInfo = [result objectForKey:@"datainfo"];
        
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:dataInfo.count];
        for (NSDictionary *aDic in dataInfo) {
            
            if ([aDic isKindOfClass:[NSDictionary class]]) {
                TopicModel *aModel = [[TopicModel alloc]initWithDictionary:aDic];
                [arr addObject:aModel];
            }
        }
        [weakTable reloadData:arr total:0];
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        NSLog(@"result %@",failDic);
        
        [LTools showMBProgressWithText:[failDic objectForKey:@"ERRO_INFO"] addToView:self.view];
        
        [weakTable loadFail];
    }];
}


#pragma mark - 视图创建


#pragma mark - delegate

#pragma - mark RefreshDelegate <NSObject>

- (void)loadNewData
{
    NSLog(@"loadNewData");
    
    [self getTopic];
}

- (void)loadMoreData
{
    NSLog(@"loadMoreData");
}
/**
 *  帖子详情(从热门推荐进入)
 */

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
    static NSString * identifier = @"HotTopicCell";
    
    HotTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"HotTopicCell" owner:self options:nil]objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    TopicModel *aModel = [_table.dataArray objectAtIndex:indexPath.row];
    
    [cell setCellWithModel:aModel];
    
    return cell;
    
}
@end

//
//  MyBBSViewController.m
//  FBCircle
//
//  Created by lichaowei on 14-8-6.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "MyBBSViewController.h"
#import "SendPostsViewController.h"
#import "MicroBBSInfoController.h"
#import "CreateNewBBSViewController.h"
#import "MyBBSCell.h"
#import "LTools.h"
#import "BBSInfoModel.h"

@interface MyBBSViewController ()<RefreshDelegate,UITableViewDataSource>
{
    RefreshTableView *_table;
    NSArray *joinArray;//加入的论坛
    NSArray *createArray;//创建的论坛
    int createNum;
    int joinNum;
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
-(void)viewWillDisappear:(BOOL)animated
{
    _table.refreshDelegate = nil;
    _table = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLabel.text = @"我的论坛";
    
    self.rightImageName = @"+";
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeNull WithRightButtonType:MyViewControllerRightbuttonTypeOther];
    [self.my_right_button addTarget:self action:@selector(clickToAddBBS) forControlEvents:UIControlEventTouchUpInside];
    
    //数据展示table
    _table = [[RefreshTableView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.height - 44 - 20)];
    _table.backgroundColor = [UIColor clearColor];
    _table.refreshDelegate = self;
    _table.dataSource = self;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    _table = nil;
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
    CreateNewBBSViewController * sendPostVC = [[CreateNewBBSViewController alloc] init];
    [self PushToViewController:sendPostVC WithAnimation:YES];
}


#pragma mark - 网络请求

- (void)getDataWithClass
{
    __weak typeof(_table)weakTable = _table;
    __weak typeof(self)weakSelf = self;
//    @"BDBWMVMwUTUFOgNvVi1TPVYkBnsPMVtnCWtZew8+AG9WOQ=="
    NSString *url = [NSString stringWithFormat:FBCIRCLE_BBS_MINE,[SzkAPI getAuthkey],_table.pageNum,L_PAGE_SIZE];
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
    
    [cancelArray addObject:tool];
    
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        NSLog(@"result %@",result);
        NSDictionary *dataInfo = [result objectForKey:@"datainfo"];
        
        if ([dataInfo isKindOfClass:[NSDictionary class]]) {
            
            int total = [[dataInfo objectForKey:@"total"]integerValue];
            createNum = [[dataInfo objectForKey:@"createnum" ]integerValue];
            joinNum = [[dataInfo objectForKey:@"joinnum" ]integerValue];
            
            NSArray *join = [dataInfo objectForKey:@"join"];
            NSArray *create = [dataInfo objectForKey:@"create"];
            
            NSMutableArray *arr_join = [NSMutableArray arrayWithCapacity:join.count];
            NSMutableArray *arr_create = [NSMutableArray arrayWithCapacity:create.count];
            for (NSDictionary *aDic in join) {
                
                [arr_join addObject:[[BBSInfoModel alloc]initWithDictionary:aDic]];
            }
            
            for (NSDictionary *aDic in create) {
                
                [arr_create addObject:[[BBSInfoModel alloc]initWithDictionary:aDic]];
            }
            
            [weakSelf reloadDataWithCreateArr:arr_create joinArr:arr_join total:total];
        }
        
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        NSLog(@"result %@",failDic);
        
        [LTools showMBProgressWithText:[failDic objectForKey:@"ERRO_INFO"] addToView:self.view];
        
        [weakTable loadFail];
    }];
}

//成功加载
- (void)reloadDataWithCreateArr:(NSArray *)arr_create joinArr:(NSArray *)arr_join total:(int)totalPage
{
    if (_table.pageNum < totalPage) {
        
        _table.isHaveMoreData = YES;
    }else
    {
        _table.isHaveMoreData = NO;
    }
    
    if (_table.isReloadData) {
        
        createArray = arr_create;
        joinArray = arr_join;
        
    }else
    {
        NSMutableArray *newArr_create = [NSMutableArray arrayWithArray:createArray];
        [newArr_create addObjectsFromArray:arr_create];
        createArray = newArr_create;
        
        NSMutableArray *newArr_join = [NSMutableArray arrayWithArray:joinArray];
        [newArr_join addObjectsFromArray:arr_join];
        joinArray = newArr_join;
    }
    
    [_table performSelector:@selector(finishReloadigData) withObject:nil afterDelay:1.0];
}

#pragma mark - 视图创建


#pragma mark - delegate

#pragma - mark RefreshDelegate <NSObject>

- (void)loadNewData
{
    NSLog(@"loadNewData");
    
    [self getDataWithClass];
}

- (void)loadMoreData
{
    NSLog(@"loadMoreData");
    [self getDataWithClass];
}

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BBSInfoModel *aModel;
    if (indexPath.section == 0) {
        
        aModel = [createArray objectAtIndex:indexPath.row];
        
    }else
    {
        aModel = [joinArray objectAtIndex:indexPath.row];
    }
    MicroBBSInfoController *bbsInfo = [[MicroBBSInfoController alloc]init];
    bbsInfo.bbsId = aModel.fid;
    [self PushToViewController:bbsInfo WithAnimation:YES];
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
    
    NSString *title1 = [NSString stringWithFormat:@"%@(%d)",@"我创建的论坛",createNum];
    NSString *title2 = [NSString stringWithFormat:@"%@(%d)",@"我加入的论坛",joinNum];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, 150, header.height)];
    titleLabel.text = (section == 0) ? title1 : title2;
    titleLabel.font = [UIFont boldSystemFontOfSize:12];
    titleLabel.textColor = [UIColor lightGrayColor];
    titleLabel.tag = 100 + section;
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
        return createArray.count;
    }
    return joinArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"MyBBSCell";
    
    MyBBSCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MyBBSCell" owner:self options:nil]objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    BBSInfoModel *aModel;
    if (indexPath.section == 0) {
        
        aModel = [createArray objectAtIndex:indexPath.row];
        
    }else
    {
        aModel = [joinArray objectAtIndex:indexPath.row];
    }
    
    [cell setCellWithModel:aModel];
    
    return cell;
    
}


@end

//
//  GnearbyPersonViewController.m
//  FBCircle
//
//  Created by gaomeng on 14-8-11.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "GnearbyPersonViewController.h"
#import "GpersonInfoViewController.h"//用户信息界面
#import "GmPrepareNetData.h"//网络请求类
#import "GnearbyPersonCell.h"//自定义cell


@interface GnearbyPersonViewController ()
{
    int _page;//第几页
    int _pageCapacity;//一页请求几条数据
    NSArray *_dataArray;//数据源
}
@end

@implementation GnearbyPersonViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any addi
    
    
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(62, 158, 210, 14)];
    titleLabel1.font = [UIFont systemFontOfSize:14];
    titleLabel1.textColor = RGBCOLOR(106, 113, 128);
    titleLabel1.text = @"在这里可以找到附近e族的族友，";
    
    UILabel *titleLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(80, CGRectGetMaxY(titleLabel1.frame)+7, 172, 14)];
    titleLabel2.font = [UIFont systemFontOfSize:14];
    titleLabel2.textColor = RGBCOLOR(106, 113, 128);
    titleLabel2.text = @"这需要使用您当前的位置。";
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(16, CGRectGetMaxY(titleLabel2.frame)+35, 320-16-16, 43);
    btn.backgroundColor = RGBCOLOR(36, 192, 38);
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [btn setTitle:@"进入附近的人" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(fujinderen) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:titleLabel1];
    [self.view addSubview:titleLabel2];
    [self.view addSubview:btn];
    
    
    _pageCapacity = 20;
}


-(void)fujinderen{
    _tableView = [[RefreshTableView alloc]initWithFrame:CGRectMake(0, 0, 320, 568-64-44)];
    _tableView.refreshDelegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    [_tableView showRefreshHeader:YES];
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
    }
    return cell;
    
}






//请求网络数据
-(void)prepareNetData{
    
    NSString *api = [NSString stringWithFormat:FBFOUND_NEARBYPERSON,[SzkAPI getAuthkey]];
    
    //请求用户通知接口
    NSLog(@"请求用户通知接口:%@",api);
    
    __weak typeof (self)bself = self;
    
    GmPrepareNetData *cc = [[GmPrepareNetData alloc]initWithUrl:api isPost:NO postData:nil];
    [cc requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        
        NSDictionary *datainfo = [result objectForKey:@"datainfo"];
        
        NSArray *dataArray = [datainfo objectForKey:@"data"];
        
        if (dataArray.count < _pageCapacity) {
            
            _tableView.isHaveMoreData = NO;
        }else
        {
            _tableView.isHaveMoreData = YES;
        }
        
        
        [bself reloadData:dataArray isReload:_tableView.isReloadData];
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        if (_tableView.isReloadData) {
            
            _page --;
            
            [_tableView performSelector:@selector(finishReloadigData) withObject:nil afterDelay:1.0];
        }
    }];
}


#pragma mark - 下拉刷新上提加载更多
/**
 *  刷新数据列表
 *
 *  @param dataArr  新请求的数据
 *  @param isReload 判断在刷新或者加载更多
 */
- (void)reloadData:(NSArray *)dataArr isReload:(BOOL)isReload
{
    if (isReload) {
        
        _dataArray = dataArr;
        
    }else
    {
        NSMutableArray *newArr = [NSMutableArray arrayWithArray:_dataArray];
        [newArr addObjectsFromArray:dataArr];
        _dataArray = newArr;
    }
    
    [_tableView performSelector:@selector(finishReloadigData) withObject:nil afterDelay:1.0];
}



#pragma - mark RefreshDelegate <NSObject>

- (void)loadNewData
{
    _page = 1;
    
    [self prepareNetData];
}

- (void)loadMoreData
{
    NSLog(@"loadMoreData");
    
    _page ++;
    
    [self prepareNetData];
}

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s",__FUNCTION__);
}

- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

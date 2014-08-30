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
    
    self.titleLabel.text = @"附近的人";
    
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
    btn.layer.cornerRadius = 4;
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [btn setTitle:@"进入附近的人" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(fujinderen) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:titleLabel1];
    [self.view addSubview:titleLabel2];
    [self.view addSubview:btn];
    
    
    //定位
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    [_locService startUserLocationService];//启动LocationService
    
    _pageCapacity = 20;
    
    
    
    
}


-(void)fujinderen{

    
    //每隔一段时间 更新用户位置
    timer = [NSTimer scheduledTimerWithTimeInterval:300 target:self selector:@selector(updateMyLocalNear) userInfo:nil repeats:YES];
    [timer fire];

}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"identifier";
    GnearbyPersonCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[GnearbyPersonCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
    }
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    cell.separatorInset = UIEdgeInsetsZero;
    [cell loadCustomViewWithIndexPath:indexPath];//加载控件
    [cell configNetDataWithIndexPath:indexPath dataArray:_dataArray];//填充数据
    
    __weak typeof (self)bself = self;
    __block NSString *celluserid = cell.userId;
    [cell setSendMessageBlock:^{
        GpersonInfoViewController *gp = [[GpersonInfoViewController alloc]init];
        gp.passUserid = celluserid;
        [bself.navigationController pushViewController:gp  animated:YES];
    }];
    
    return cell;
    
}






//请求网络数据
-(void)prepareNetData{
    
    NSString *api = [NSString stringWithFormat:FBFOUND_NEARBYPERSON,[SzkAPI getAuthkey]];
    
    //请求附近的人接口
    NSLog(@"请求附近的人接口:%@",api);
    
    __weak typeof (self)bself = self;
    
    GmPrepareNetData *cc = [[GmPrepareNetData alloc]initWithUrl:api isPost:NO postData:nil];
    [cc requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"%@",result);
        
        NSArray *dataInfoArray = [result objectForKey:@"datainfo"];
        _userids = [NSArray arrayWithArray:dataInfoArray];
        
        
        NSLog(@"%d",_userids.count);
//        if (dataInfoArray.count < _pageCapacity) {
//            
//            _tableView.isHaveMoreData = NO;
//        }else
//        {
//            _tableView.isHaveMoreData = YES;
//        }
        
        
        [bself reloadData:dataInfoArray isReload:_tableView.isReloadData];
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
//        if (_tableView.isReloadData) {
//            
//            _page --;
//            
//            [_tableView performSelector:@selector(finishReloadigData) withObject:nil afterDelay:1.0];
//        }
    }];
}



//通过多个uid获取用户信息
-(void)getUsersInfoWithUids:(NSArray *)userids{
    
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



#pragma mark - 上传自己的经纬度
-(void)updateMyLocalNear{
    NSString *api = [NSString stringWithFormat:FBFOUND_UPDATAUSERLOCAL,[SzkAPI getAuthkey],_guserLocation.location.coordinate.latitude,_guserLocation.location.coordinate.longitude];
    
    NSLog(@"%@",api);
    
    NSURL *url = [NSURL URLWithString:api];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        NSLog(@"%@",dic);
        
        _tableView = [[RefreshTableView alloc]initWithFrame:CGRectMake(0, 0, 320, 568-64-44)];
        _tableView.refreshDelegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
        
        [_tableView showRefreshHeader:YES];
    }];
    
    
    
}


#pragma mark - 定位代理方法

//在地图View将要启动定位时，会调用此函数
- (void)mapViewWillStartLocatingUser:(BMKMapView *)mapView
{
	NSLog(@"start locate");
}


//用户方向更新后，会调用此函数
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
//    [_mapView updateLocationData:userLocation];
    _guserLocation = userLocation;
    NSLog(@"heading is %@",userLocation.heading);
}


//用户位置更新后，会调用此函数
- (void)didUpdateUserLocation:(BMKUserLocation *)userLocation
{
//    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    _guserLocation = userLocation;
    
//    [_mapView updateLocationData:userLocation];
    
    if (!_isFire) {
        _isFire = YES;
        [timer fire];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

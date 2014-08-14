//
//  GuseCarViewController.m
//  FBCircle
//
//  Created by gaomeng on 14-8-5.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "GuseCarViewController.h"
#import "GcustomUseCarDownInfoCell.h"//底层view自定义cell

@interface GuseCarViewController ()

@end

@implementation GuseCarViewController



- (void)dealloc
{
    
    NSLog(@"%s",__FUNCTION__);
}




-(void)viewWillAppear:(BOOL)animated {
    [_mapView viewWillAppear];
    
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    
    
    _mapView.delegate = nil; // 不用时，置nil
    
    _poisearch.delegate = nil; // 不用时，置nil
    
    _locService.delegate = nil;
    
    
    
    
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    _isShowDownInfoView = NO;
    
    //导航栏
    UIView *navigationbar = [[UIView alloc]initWithFrame:CGRectMake(0, 20, 320, 44)];
    navigationbar.backgroundColor = [UIColor blackColor];
    [self.view addSubview:navigationbar];
    
    //导航栏上的返回按钮和titile
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 70, 44);
    [backBtn addTarget:self action:@selector(gBackBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    backBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [navigationbar addSubview:backBtn];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(125, 0, 70, 44)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font =  [UIFont boldSystemFontOfSize:16.0f];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"用车服务";
    [navigationbar addSubview:titleLabel];
    
    
    
    //按钮下面的背景view
    UIView *btnBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, 320, 44)];
    btnBackView.backgroundColor = RGBCOLOR(240, 241, 243);
    [self.view addSubview:btnBackView];
    
    //分配内存
    self.btnArray = [NSMutableArray arrayWithCapacity:1];
    
    //按钮
    NSArray *array  = @[@"停车场",@"加油站",@"维修厂"];
    for (int i = 0; i<3; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0+107*i, 64, 106, 44);
        btn.tag = 10+i;
        [btn setTitle:array[i] forState:UIControlStateNormal];
        [btn setTitleColor:RGBCOLOR(106, 114, 126) forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn addTarget:self action:@selector(FoundBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        [self.btnArray addObject:btn];
    }
    
    //地图
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 88+20, 320, iPhone5?568-88-20:480-88-20)];
    [_mapView setZoomLevel:13];// 设置地图级别
    _mapView.isSelectedAnnotationViewFront = YES;
    _mapView.delegate = self;//设置代理
    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
    
    [self.view addSubview:_mapView];
    
    //搜索类
    _poisearch = [[BMKPoiSearch alloc]init];
    _poisearch.delegate = self;
    
    
    
    //定位
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    [_locService startUserLocationService];//启动LocationService
    
    
   
    
    //下面信息view
    _downInfoView = [[UIView alloc]initWithFrame:CGRectMake(0, 568, 320, 206)];
    _downInfoView.backgroundColor = RGBCOLOR(211, 214, 219);
    
    //底层view
    UIView *downBackView = [[UIView alloc]initWithFrame:CGRectMake(10, 12, 300, 150)];
    downBackView.backgroundColor = [UIColor whiteColor];
    downBackView.layer.borderWidth = 0.5;
    downBackView.layer.borderColor = [RGBCOLOR(200, 199, 204)CGColor];
    downBackView.layer.cornerRadius = 5;
    [_downInfoView addSubview:downBackView];
    
//    //自定义downInfoView
//    for (int i = 0; i<3; i++) {
//        UIImageView *imv = [[UIImageView alloc]init];
//        if (i == 0) {
//            imv.frame = CGRectMake(18, 15, 15, 15);
//            [imv setImage:[UIImage imageNamed:@"fhome.png"]];
//        }else if (i == 1){
//            imv.frame = CGRectMake(18, 59, 15, 15);
//            [imv setImage:[UIImage imageNamed:@"fearth.png"]];
//        }else if (i == 2){
//            imv.frame = CGRectMake(18, 120, 15, 15);
//            [imv setImage:[UIImage imageNamed:@"ftel.png"]];
//        }
//        [downBackView addSubview:imv];
//        
//    }
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 300, 150) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.layer.borderWidth = 0.5;
    _tableView.layer.borderColor = [RGBCOLOR(200, 199, 204)CGColor];
    _tableView.layer.cornerRadius = 5;
//    _tableView.separatorColor = [UIColor clearColor];
    [downBackView addSubview:_tableView];
    
    
    
    [self.view addSubview:_downInfoView];
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"dd";
    GcustomUseCarDownInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[GcustomUseCarDownInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
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
    [_mapView updateLocationData:userLocation];
    _guserLocation = userLocation;
    NSLog(@"heading is %@",userLocation.heading);
}


//用户位置更新后，会调用此函数
- (void)didUpdateUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    _guserLocation = userLocation;
    
    [_mapView updateLocationData:userLocation];
}


//定位失败后，会调用此函数
- (void)mapView:(BMKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"提示" message:@"定位失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [al show];
}



#pragma mark - 按钮点击方法  搜索周边
-(void)FoundBtnClicked:(UIButton *)sender{
    NSLog(@"%d",sender.tag);
    
    //改变字体和背景颜色
    for (UIButton *btn in self.btnArray) {
        
        if (btn.tag == sender.tag) {
            [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        }else{
            [btn setTitleColor:RGBCOLOR(106, 114, 126) forState:UIControlStateNormal];
        }
        
    }
    
    //进行地图搜索相关操作
    if (sender.tag == 10) {//停车场
        
        //初始化检索对象
        _poisearch =[[BMKPoiSearch alloc]init];
        _poisearch.delegate = self;
        //发起检索
        BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc]init];
        option.pageIndex = curPage;
        option.pageCapacity = 100;
        option.location =CLLocationCoordinate2DMake(_guserLocation.location.coordinate.latitude, _guserLocation.location.coordinate.longitude);
            option.keyword = @"停车场";
            BOOL flag = [_poisearch poiSearchNearBy:option];
            if(flag)
            {
                NSLog(@"周边检索发送成功");
            }  
            else  
            {  
                NSLog(@"周边检索发送失败");  
            }
        
        
    }else if (sender.tag == 11){//加油站
        //初始化检索对象
        _poisearch =[[BMKPoiSearch alloc]init];
        _poisearch.delegate = self;
        //发起检索
        BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc]init];
        option.pageIndex = curPage;
        option.pageCapacity = 100;
        option.location =CLLocationCoordinate2DMake(_guserLocation.location.coordinate.latitude, _guserLocation.location.coordinate.longitude);
        option.keyword = @"加油站";
        BOOL flag = [_poisearch poiSearchNearBy:option];
        if(flag)
        {
            NSLog(@"周边检索发送成功");
        }
        else
        {
            NSLog(@"周边检索发送失败");
        }
        
    }else if (sender.tag == 12){//维修厂
        //初始化检索对象
        _poisearch =[[BMKPoiSearch alloc]init];
        _poisearch.delegate = self;
        //发起检索
        BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc]init];
        option.pageIndex = curPage;
        option.pageCapacity = 100;
        option.location =CLLocationCoordinate2DMake(_guserLocation.location.coordinate.latitude, _guserLocation.location.coordinate.longitude);
        option.keyword = @"维修厂";
        BOOL flag = [_poisearch poiSearchNearBy:option];
        if(flag)
        {
            NSLog(@"周边检索发送成功");
        }
        else
        {
            NSLog(@"周边检索发送失败");
        }
    }
    
    
}


//周边搜索回调结果
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResultList errorCode:(BMKSearchErrorCode)error
{
    
    // 清楚屏幕中所有的annotation
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
	[_mapView removeAnnotations:array];
    
    if (error == BMK_SEARCH_NO_ERROR) {
        
        
		for (int i = 0; i < poiResultList.poiInfoList.count; i++) {
            BMKPoiInfo* poi = [poiResultList.poiInfoList objectAtIndex:i];
            BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
            item.coordinate = poi.pt;
            item.title = poi.name;
            [_mapView addAnnotation:item];//addAnnotation方法会掉BMKMapViewDelegate的-mapView:viewForAnnotation:函数来生成标注对应的View
            if(i == 0)
            {
                //将第一个点的坐标移到屏幕中央
                _mapView.centerCoordinate = poi.pt;
            }
		}
	} else if (error == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR){
        
        
        NSLog(@"起始点有歧义");
    } else {
        
        // 各种情况的判断。。。
    }
}


#pragma mark - 地图view代理方法 BMKMapViewDelegate
/**
 *根据anntation生成对应的View
 *@param annotation 指定的标注
 *@return 生成的标注View
 */
- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    // 生成重用标示identifier
    NSString *AnnotationViewID = @"xidanMark";

    // 检查是否有重用的缓存
    BMKAnnotationView* annotationView = [view dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];

    // 缓存没有命中，自己构造一个，一般首次添加annotation代码会运行到此处
    if (annotationView == nil) {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
		((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
		// 设置重天上掉下的效果(annotation)
        ((BMKPinAnnotationView*)annotationView).animatesDrop = YES;
    }

    // 设置位置
	annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
    annotationView.annotation = annotation;
    // 单击弹出泡泡，弹出泡泡前提annotation必须实现title属性
	annotationView.canShowCallout = YES;
    // 设置是否可以拖拽
    annotationView.draggable = NO;

    return annotationView;
}
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    [mapView bringSubviewToFront:view];
    [mapView setNeedsDisplay];
}


- (void)mapView:(BMKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    NSLog(@"didAddAnnotationViews");
}



#pragma mark - 弹出框点击代理方法
// 当点击annotation view弹出的泡泡时，调用此接口
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view;
{
    NSLog(@"paopaoclick");
    
    if (!_isShowDownInfoView) {
        [UIView animateWithDuration:0.3 animations:^{
            _downInfoView.frame = CGRectMake(0, 568-206, 320, 206);
        } completion:^(BOOL finished) {
            _isShowDownInfoView = !_isShowDownInfoView;
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            _downInfoView.frame = CGRectMake(0, 568, 320, 206);
        } completion:^(BOOL finished) {
            _isShowDownInfoView = !_isShowDownInfoView;
        }];
    }
    
}






//左上角返回按钮
-(void)gBackBtnClicked{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}




@end

//
//  GuseCarViewController.m
//  FBCircle
//
//  Created by gaomeng on 14-8-5.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "GuseCarViewController.h"

@interface GuseCarViewController ()

@end

@implementation GuseCarViewController



- (void)dealloc
{
    NSLog(@"%s",__FUNCTION__);
}




-(void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    
    
    
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _searcher.delegate = nil; 
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    
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
    [self.view addSubview:_mapView];
    
    //定位
    _locService = [[BMKLocationService alloc]init];
    NSLog(@"进入普通定位态");
    [_locService startUserLocationService];//启动LocationService
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
    
    
    ////设置地图缩放级别
    [_mapView setZoomLevel:11];
    //添加内置覆盖物
    [self addOverlayView];
    
    
    
    
    
    
    
    
}

//添加内置覆盖物
- (void)addOverlayView
{
    // 添加圆形覆盖物
    if (circle == nil) {
        CLLocationCoordinate2D coor;
//        coor.latitude = _guserLocation.location.coordinate.latitude;
//        coor.longitude = _guserLocation.location.coordinate.longitude;
        
        coor.latitude = 39.915;
        coor.longitude = 116.404;
        
        circle = [BMKCircle circleWithCenterCoordinate:coor radius:3000];
        [_mapView addOverlay:circle];
    }
//    // 添加多边形覆盖物
//    if (polygon == nil) {
//        CLLocationCoordinate2D coords[4] = {0};
//        coords[0].latitude = 39.915;
//        coords[0].longitude = 116.404;
//        coords[1].latitude = 39.815;
//        coords[1].longitude = 116.404;
//        coords[2].latitude = 39.815;
//        coords[2].longitude = 116.504;
//        coords[3].latitude = 39.915;
//        coords[3].longitude = 116.504;
//        polygon = [BMKPolygon polygonWithCoordinates:coords count:4];
//        [_mapView addOverlay:polygon];
//    }
//    // 添加多边形覆盖物
//    if (polygon2 == nil) {
//        CLLocationCoordinate2D coords[5] = {0};
//        coords[0].latitude = 39.965;
//        coords[0].longitude = 116.604;
//        coords[1].latitude = 39.865;
//        coords[1].longitude = 116.604;
//        coords[2].latitude = 39.865;
//        coords[2].longitude = 116.704;
//        coords[3].latitude = 39.905;
//        coords[3].longitude = 116.654;
//        coords[4].latitude = 39.965;
//        coords[4].longitude = 116.704;
//        polygon2 = [BMKPolygon polygonWithCoordinates:coords count:5];
//        [_mapView addOverlay:polygon2];
//    }
//    //添加折线覆盖物
//    if (polyline == nil) {
//        CLLocationCoordinate2D coors[2] = {0};
//        coors[0].latitude = 39.895;
//        coors[0].longitude = 116.354;
//        coors[1].latitude = 39.815;
//        coors[1].longitude = 116.304;
//        polyline = [BMKPolyline polylineWithCoordinates:coors count:2];
//        [_mapView addOverlay:polyline];
//    }
}

//添加标注
- (void)addPointAnnotation
{
    pointAnnotation = [[BMKPointAnnotation alloc]init];
    CLLocationCoordinate2D coor;
    coor.latitude = 39.915;
    coor.longitude = 116.404;
    pointAnnotation.coordinate = coor;
    pointAnnotation.title = @"test";
    pointAnnotation.subtitle = @"此Annotation可拖拽!";
    [_mapView addAnnotation:pointAnnotation];
    
}
//根据overlay生成对应的View
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay
{
	if ([overlay isKindOfClass:[BMKCircle class]])
    {
        BMKCircleView* circleView = [[BMKCircleView alloc] initWithOverlay:overlay];
        circleView.fillColor = [[UIColor redColor] colorWithAlphaComponent:0.5];
        circleView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
        circleView.lineWidth = 5.0;
		return circleView;
    }
    
    if ([overlay isKindOfClass:[BMKPolyline class]])
    {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:1];
        polylineView.lineWidth = 3.0;
		return polylineView;
    }
	
	if ([overlay isKindOfClass:[BMKPolygon class]])
    {
        BMKPolygonView* polygonView = [[BMKPolygonView alloc] initWithOverlay:overlay];
        polygonView.strokeColor = [[UIColor purpleColor] colorWithAlphaComponent:1];
        polygonView.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:0.2];
        polygonView.lineWidth =2.0;
		return polygonView;
    }
    if ([overlay isKindOfClass:[BMKGroundOverlay class]])
    {
        BMKGroundOverlayView* groundView = [[BMKGroundOverlayView alloc] initWithOverlay:overlay];
		return groundView;
    }
	return nil;
}


#pragma mark implement BMKMapViewDelegate

// 根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    NSString *AnnotationViewID = @"renameMark";
    if (newAnnotation == nil) {
        newAnnotation = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        // 设置颜色
		((BMKPinAnnotationView*)newAnnotation).pinColor = BMKPinAnnotationColorPurple;
        // 从天上掉下效果
		((BMKPinAnnotationView*)newAnnotation).animatesDrop = YES;
        // 设置可拖拽
		((BMKPinAnnotationView*)newAnnotation).draggable = YES;
    }
    return newAnnotation;
    
}

// 当点击annotation view弹出的泡泡时，调用此接口
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view;
{
    NSLog(@"paopaoclick");
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - 实现相关delegate 处理位置信息更新
/**
 *在地图View将要启动定位时，会调用此函数
 *@param mapView 地图View
 */
- (void)mapViewWillStartLocatingUser:(BMKMapView *)mapView
{
	NSLog(@"start locate");
}

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
    
    _guserLocation = userLocation;
    NSLog(@"heading is %@",userLocation.heading);
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserLocation:(BMKUserLocation *)userLocation
{
    
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    _guserLocation = userLocation;
    
    [_mapView updateLocationData:userLocation];
}

/**
 *定位失败后，会调用此函数
 *@param mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)mapView:(BMKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"提示" message:@"定位失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [al show];
}



#pragma mark - 按钮点击方法
-(void)FoundBtnClicked:(UIButton *)sender{
    
    NSLog(@"%d",sender.tag);
    
    for (UIButton *btn in self.btnArray) {
        
        if (btn.tag == sender.tag) {
            [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        }else{
            [btn setTitleColor:RGBCOLOR(106, 114, 126) forState:UIControlStateNormal];
        }
        
    }
    
    
    
    
//    option.location = CLLocationCoordinate=={==.==== ========;
//        option.keyword = @"加油站";
//        BOOL flag = [_searcher poiSearchNearBy:option];
//        if(flag)
//        {
//            NSLog(@"周边检索发送成功");
//        }
//        else
//        {
//            NSLog(@"周边检索发送失败");
//        }
    
    
    
    
    
}



#pragma mark - 周边搜索

//实现PoiSearchDeleage处理回调结果
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResultList errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
    }
    else if (error == BMK_SEARCH_AMBIGUOUS_KEYWORD){
        //当在设置城市未找到结果，但在其他城市找到结果时，回调建议检索城市列表
        // result.cityList;
        NSLog(@"起始点有歧义");
    } else {
        NSLog(@"抱歉，未找到结果");
    }
}





-(void)gBackBtnClicked{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}




@end

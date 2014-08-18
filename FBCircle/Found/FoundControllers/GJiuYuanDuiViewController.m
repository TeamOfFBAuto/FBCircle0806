//
//  GJiuYuanDuiViewController.m
//  FBCircle
//
//  Created by gaomeng on 14-8-15.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "GJiuYuanDuiViewController.h"
#import "GJiuYuanCell.h"



@interface GJiuYuanDuiViewController ()

@end

@implementation GJiuYuanDuiViewController

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
    
//    for (UIView * view in _mapView.subviews) {
//        [view removeFromSuperview];
//    }
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
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
    titleLabel.text = @"救援队";
    [navigationbar addSubview:titleLabel];
    
    
    
    //地图
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 64, 320, iPhone5?568-64:480-64)];
    [_mapView setZoomLevel:13];// 设置地图级别
    _mapView.isSelectedAnnotationViewFront = YES;
    _mapView.delegate = self;//设置代理
    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
    
    [self.view addSubview:_mapView];
    
    //定位
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    [_locService startUserLocationService];//启动LocationService
    
    
    
    
    //下面信息view
    _downInfoView = [[UIView alloc]initWithFrame:CGRectMake(0, 568-206, 320, 206)];
    _downInfoView.backgroundColor = RGBCOLOR(211, 214, 219);
    
    //底层view
    UIView *downBackView = [[UIView alloc]initWithFrame:CGRectMake(10, 12, 300, 150)];
    downBackView.backgroundColor = [UIColor whiteColor];
    downBackView.layer.borderWidth = 0.5;
    downBackView.layer.borderColor = [RGBCOLOR(200, 199, 204)CGColor];
    downBackView.layer.cornerRadius = 5;
    [_downInfoView addSubview:downBackView];
    
    
    
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


#pragma mark - UITableViewDelegate && UITableViewDataSource
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"dd";
    GJiuYuanCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[GJiuYuanCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.separatorInset = UIEdgeInsetsMake(0,53,0,0);
    
    
    [cell loadViewWithIndexPath:indexPath];
    
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


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%d",indexPath.row);
    if (indexPath.row == 2) {
        UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"拨号" message:@"13301072337" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [al show];
    }
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"%d",buttonIndex);
    
    //0取消    1确定
    if (buttonIndex == 1) {
        
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

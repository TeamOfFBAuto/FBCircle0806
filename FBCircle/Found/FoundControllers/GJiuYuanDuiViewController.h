//
//  GJiuYuanDuiViewController.h
//  FBCircle
//
//  Created by gaomeng on 14-8-15.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//


//e族救援队

#import <UIKit/UIKit.h>

@interface GJiuYuanDuiViewController : UIViewController<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKPoiSearchDelegate,BMKAnnotation,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    BMKMapView *_mapView;//地图
    BMKLocationService *_locService;//定位服务
    
    
    //定位相关
    BMKUserLocation *_guserLocation;
    
    //检索相关
    BMKNearbySearchOption *_option;
    BMKPoiSearch* _poisearch;
    int curPage;
    
    
    //下面详细信息的view
    UIView *_downInfoView;
    UITableView *_tableView;
    BOOL _isShowDownInfoView;
}
@end

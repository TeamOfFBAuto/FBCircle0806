//
//  GuseCarViewController.h
//  FBCircle
//
//  Created by gaomeng on 14-8-5.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//


//用车服务
#import <UIKit/UIKit.h>
@interface GuseCarViewController : UIViewController<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKPoiSearchDelegate,BMKAnnotation>
{
    BMKMapView *_mapView;//地图
    BMKLocationService *_locService;//定位服务
    
    
    //定位相关
    BMKUserLocation *_guserLocation;
    BMKCircle* circle;
    BMKPolygon* polygon;
    BMKPolygon* polygon2;
    BMKPolyline* polyline;
    BMKGroundOverlay* ground;
    BMKGroundOverlay* ground2;
    BMKPointAnnotation* pointAnnotation;
    BMKAnnotationView* newAnnotation;
    
    //检索相关
    BMKNearbySearchOption *_option;
    BMKPoiSearch* _poisearch;
    int curPage;
}

@property(nonatomic,strong)NSMutableArray *btnArray;//上面三个按钮的数组


//协议属性
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

@end

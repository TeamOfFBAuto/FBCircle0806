//
//  GnearbyPersonViewController.h
//  FBCircle
//
//  Created by gaomeng on 14-8-11.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//


//附近的人
#import <UIKit/UIKit.h>

@interface GnearbyPersonViewController : UIViewController<RefreshDelegate,UITableViewDataSource,BMKLocationServiceDelegate>
{
    RefreshTableView *_tableView;//主tableview
    
    //定位相关
    BMKUserLocation *_guserLocation;//用户当前位置
    BMKLocationService *_locService;//定位服务
    
    
    NSTimer * timer;
    BOOL _isFire;
}
@end

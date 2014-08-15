//
//  GnearbyPersonViewController.h
//  FBCircle
//
//  Created by gaomeng on 14-8-11.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//


//附近的人
#import <UIKit/UIKit.h>

@interface GnearbyPersonViewController : UIViewController<RefreshDelegate,UITableViewDataSource>
{
    RefreshTableView *_tableView;//主tableview
}
@end

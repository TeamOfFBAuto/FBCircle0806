//
//  CreateBBSChooseTypeViewController.h
//  FBCircle
//
//  Created by soulnear on 14-8-14.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateBBSChooseTypeViewController : MyViewController<UITableViewDelegate,UITableViewDataSource>
{
    
}


@property(nonatomic,strong)UITableView * myTableView;

@property(nonatomic,strong)NSMutableArray * data_array;

@property(nonatomic,strong)UILabel * name_Label;


@end

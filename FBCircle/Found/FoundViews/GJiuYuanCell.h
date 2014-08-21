//
//  GJiuYuanCell.h
//  FBCircle
//
//  Created by gaomeng on 14-8-15.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//


//救援队界面 下面弹出框内的tableview 自定义cell
#import <UIKit/UIKit.h>

@interface GJiuYuanCell : UITableViewCell

@property(nonatomic,strong)UIImageView *titielImav;//图标

-(void)loadViewWithIndexPath:(NSIndexPath*)theIndexPath;

@end

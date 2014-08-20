//
//  GcustomUseCarDownInfoCell.h
//  FBCircle
//
//  Created by gaomeng on 14-8-14.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GcustomUseCarDownInfoCell : UITableViewCell



@property(nonatomic,strong)UIImageView *titielImav;//图标


-(void)loadViewWithIndexPath:(NSIndexPath*)theIndexPath;

-(CGFloat)configDataWithIndexPath:(NSIndexPath *)indexPath;


@end

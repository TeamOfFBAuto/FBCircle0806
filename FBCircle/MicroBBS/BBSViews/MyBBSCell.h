//
//  MyBBSCell.h
//  FBCircle
//
//  Created by lichaowei on 14-8-6.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  我的论坛
 */
@class BBSSubModel;
@interface MyBBSCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *aImageView;

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *numLabel;

-(void)setCellWithModel:(BBSSubModel *)aModel;

@end

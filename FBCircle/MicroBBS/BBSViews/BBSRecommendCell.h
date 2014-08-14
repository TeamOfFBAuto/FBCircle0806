//
//  BBSRecommendCell.h
//  FBCircle
//
//  Created by lichaowei on 14-8-8.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTLabel.h"
/**
 *  评论cell
 */
@interface BBSRecommendCell : UITableViewCell
@property (nonatomic,retain)UIImageView *aImageView;
@property (nonatomic,retain)UILabel *nameLabel;
@property (nonatomic,retain)UILabel *timeLabel;
@property(nonatomic,retain)UIView * content_label;

- (void)setCellData:(NSString *)aModel OHLabel:(UIView *)OHLabel;


@end

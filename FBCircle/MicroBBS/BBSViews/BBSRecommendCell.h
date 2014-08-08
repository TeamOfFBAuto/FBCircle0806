//
//  BBSRecommendCell.h
//  FBCircle
//
//  Created by lichaowei on 14-8-8.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  评论cell
 */
@interface BBSRecommendCell : UITableViewCell
@property (nonatomic,retain)UIImageView *aImageView;
@property (nonatomic,retain)UILabel *nameLabel;
@property (nonatomic,retain)UILabel *timeLabel;
@property (nonatomic,retain)UILabel *contentLabel;

- (void)setCellData:(id)aModel;
@end

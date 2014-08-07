//
//  HotTopicCell.h
//  FBCircle
//
//  Created by lichaowei on 14-8-6.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  热门推荐帖子
 */
@interface HotTopicCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *aImageView;
@property (strong, nonatomic) IBOutlet UILabel *aTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *subTitleLabel;

@end

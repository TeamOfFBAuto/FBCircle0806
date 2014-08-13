//
//  SearchBBSCell.h
//  FBCircle
//
//  Created by lichaowei on 14-8-13.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BBSInfoModel;
@interface SearchBBSCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *aImageView;
@property (strong, nonatomic) IBOutlet UILabel *aTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *memberNumLabel;
@property (strong, nonatomic) IBOutlet UILabel *topicNumLabel;
@property (strong, nonatomic) IBOutlet UIView *line;
@property (strong, nonatomic) IBOutlet UILabel *tieziLable;

- (void)setCellDataWithModel:(BBSInfoModel *)aModel;
- (void)resetFrame:(NSString *)text;

@end

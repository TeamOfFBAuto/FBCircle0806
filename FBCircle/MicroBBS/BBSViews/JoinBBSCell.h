//
//  JoinBBSCell.h
//  FBCircle
//
//  Created by lichaowei on 14-8-6.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JoinBBSCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *aImageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *memeberLabel;
@property (strong, nonatomic) IBOutlet UILabel *topicLabel;
- (IBAction)clickToJoin:(id)sender;

@end

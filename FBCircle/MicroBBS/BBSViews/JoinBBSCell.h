//
//  JoinBBSCell.h
//  FBCircle
//
//  Created by lichaowei on 14-8-6.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  分类论坛二级 （加入）
 */
typedef void(^CellBlock)(NSString *topicId);

@class BBSSubModel;
@interface JoinBBSCell : UITableViewCell
{
    CellBlock cellBlock;
    NSString *topicId;
}
@property (strong, nonatomic) IBOutlet UIImageView *aImageView;
@property (strong, nonatomic) IBOutlet UILabel *aTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *memeberLabel;
@property (strong, nonatomic) IBOutlet UILabel *topicLabel;
@property (strong, nonatomic) IBOutlet UIButton *joinButton;


- (IBAction)clickToJoin:(id)sender;

- (void)setCellDataWithModel:(BBSSubModel *)aModel cellBlock:(CellBlock)aBlock;

@end

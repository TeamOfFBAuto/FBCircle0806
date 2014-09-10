//
//  JoinBBSCell.m
//  FBCircle
//
//  Created by lichaowei on 14-8-6.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "JoinBBSCell.h"
#import "BBSInfoModel.h"

@implementation JoinBBSCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)clickToJoin:(id)sender {
    
    cellBlock(topicId);
}


- (void)setCellDataWithModel:(BBSInfoModel *)aModel cellBlock:(CellBlock)aBlock
{
    topicId = aModel.id;
    cellBlock = aBlock;
    
    self.aImageView.image = [LTools imageForBBSId:aModel.headpic];
    self.aTitleLabel.text = aModel.name;
    UIColor *textColor = [UIColor colorWithHexString:@"6a707e"];
    _memberTitle.textColor = textColor;
    
    self.memeberLabel.text = aModel.member_num;
    
    self.memeberLabel.width = [LTools widthForText:aModel.member_num font:14.0];
    
    self.line.left = self.memeberLabel.right + 5;
    
    
    self.topicTitle.left = self.line.right + 5;
    
    _topicTitle.textColor = textColor;
    
    self.topicLabel.text = aModel.thread_num;
    self.topicLabel.left = self.topicTitle.right;
    self.topicLabel.width = [LTools widthForText:aModel.thread_num font:14.0];
    
    self.joinButton.selected = (aModel.inForum == 1) ? YES : NO;
    self.joinButton.userInteractionEnabled = (aModel.inForum == 1) ? NO : YES;
    
}

@end

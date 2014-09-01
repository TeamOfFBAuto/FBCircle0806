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
    
    self.imageView.image = [LTools imageForBBSId:aModel.headpic];
    self.aTitleLabel.text = aModel.name;
    self.memeberLabel.text = aModel.member_num;
    self.topicLabel.text = aModel.thread_num;
    
    self.joinButton.selected = (aModel.inForum == 1) ? YES : NO;
    self.joinButton.userInteractionEnabled = (aModel.inForum == 1) ? NO : YES;
    
}

@end

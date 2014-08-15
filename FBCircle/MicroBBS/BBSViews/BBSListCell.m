//
//  BBSListCell.m
//  FBCircle
//
//  Created by lichaowei on 14-8-7.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "BBSListCell.h"
#import "TopicModel.h"

@implementation BBSListCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellDataWithModel:(TopicModel *)aModel
{
    self.aTitleLabel.text = aModel.title;
    self.nameAndAddressLabel.text = [NSString stringWithFormat:@"%@  |  %@",aModel.username,aModel.address];
    self.timeAndCommentLabel.text = [NSString stringWithFormat:@"%@  |   %@评论",[ZSNApi timestamp:aModel.time],aModel.comment_num];
//    小野人  |  广东 佛山
//    13分钟前  |   10评论

}

@end

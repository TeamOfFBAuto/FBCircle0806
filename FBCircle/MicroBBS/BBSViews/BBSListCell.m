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
    _aTitleLabel.font = [UIFont boldSystemFontOfSize:14];
    
    NSString *address = [LTools NSStringNotNull:aModel.address];
    
    NSString *str = [address isEqualToString:@""] ? [NSString stringWithFormat:@"%@",aModel.username] : [NSString stringWithFormat:@"%@  |  %@",aModel.username,aModel.address];
    
    self.nameAndAddressLabel.text = str;
    self.timeAndCommentLabel.text = [NSString stringWithFormat:@"%@  |   %@评论",[ZSNApi timestamp:aModel.time],aModel.comment_num];
//    小野人  |  广东 佛山
//    13分钟前  |   10评论

}

@end

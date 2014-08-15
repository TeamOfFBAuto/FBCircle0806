//
//  SearchBBSCell.m
//  FBCircle
//
//  Created by lichaowei on 14-8-13.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "SearchBBSCell.h"
#import "BBSInfoModel.h"

@implementation SearchBBSCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellDataWithModel:(BBSInfoModel *)aModel
{
    [self.aImageView sd_setImageWithURL:[NSURL URLWithString:aModel.headpic] placeholderImage:[UIImage imageNamed:@"Picture_default_image"]];
    self.aTitleLabel.text = aModel.name;
    self.memberNumLabel.text = aModel.member_num;
    self.topicNumLabel.text = aModel.thread_num;
}

-(void)layoutSubviews
{
    [self resetFrame:self.memberNumLabel.text];
}

- (void)resetFrame:(NSString *)text
{
    self.memberNumLabel.frame = CGRectMake(_memberNumLabel.left, _memberNumLabel.top, [LTools widthForText:text font:14], _memberNumLabel.height);
    
    self.line.frame = CGRectMake(_memberNumLabel.right + 5, _line.top, _line.width, _line.height);
    self.tieziLable.frame = CGRectMake(_line.right + 5, _tieziLable.top, _tieziLable.width, _tieziLable.height);
    self.topicNumLabel.frame = CGRectMake(_tieziLable.right, _topicNumLabel.top, _topicNumLabel.width, _topicNumLabel.height);
}

@end

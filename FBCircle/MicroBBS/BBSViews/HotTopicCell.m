//
//  HotTopicCell.m
//  FBCircle
//
//  Created by lichaowei on 14-8-6.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "HotTopicCell.h"
#import "TopicModel.h"

@implementation HotTopicCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCellWithModel:(TopicModel *)aModel
{
    [self.aImageView sd_setImageWithURL:[NSURL URLWithString:aModel.forumpic] placeholderImage:[UIImage imageNamed:@"Picture_default_image"]];
    self.aTitleLabel.text = aModel.title;
    self.subTitleLabel.text = aModel.sub_content;
}

@end

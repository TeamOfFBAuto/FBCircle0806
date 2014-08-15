//
//  MyBBSCell.m
//  FBCircle
//
//  Created by lichaowei on 14-8-6.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "MyBBSCell.h"
#import "BBSInfoModel.h"

@implementation MyBBSCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCellWithModel:(BBSInfoModel *)aModel
{
    [self.aImageView sd_setImageWithURL:[NSURL URLWithString:aModel.headpic] placeholderImage:[UIImage imageNamed:@"Picture_default_image"]];
    self.nameLabel.text = aModel.name;
    self.numLabel.text = aModel.newthread_num;
    NSString *numText = @"0";
    if ([aModel.newthread_num intValue] < 10) {
        numText = aModel.newthread_num;
    }else
    {
        numText = [NSString stringWithFormat:@"%d+",[aModel.newthread_num intValue]/10 * 10];
    }
}

@end

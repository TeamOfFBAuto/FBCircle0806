//
//  BBSTableCell.m
//  FBCircle
//
//  Created by lichaowei on 14-8-5.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "BBSTableCell.h"
#import "TopicModel.h"

@implementation BBSTableCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"BBSTableCell" owner:self options:nil]objectAtIndex:0];
    }
    return self;
}

-(void)setCellWithModel:(TopicModel *)aModel
{
    [self.aImageView sd_setImageWithURL:[NSURL URLWithString:aModel.forumpic] placeholderImage:[UIImage imageNamed:@"Picture_default_image"]];
    self.aTitleLabel.text = aModel.title;
    self.subTitleLabel.text = [LTools stringHeadNoSpace:aModel.sub_content];
    self.aTitleLabel.font = [UIFont systemFontOfSize:FONT_SIZE_MID];
    _aTitleLabel.textColor = [UIColor colorWithHexString:@"1d222b"];
    self.subTitleLabel.font = [UIFont systemFontOfSize:FONT_SIZE_SMALL];
    _subTitleLabel.textColor = [UIColor colorWithHexString:@"9197a3"];
}

@end

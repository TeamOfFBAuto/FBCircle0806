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
    self.aTitleLabel.text =[ZSNApi decodeFromPercentEscapeString:aModel.title];
    self.subTitleLabel.text = [ZSNApi decodeFromPercentEscapeString:aModel.sub_content];;
}

@end

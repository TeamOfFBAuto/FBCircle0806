//
//  BBSRecommendCell.m
//  FBCircle
//
//  Created by lichaowei on 14-8-8.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "BBSRecommendCell.h"

@implementation BBSRecommendCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        UIView *hh_view = [[UIView alloc]initWithFrame:CGRectMake(8, 0, 304, 75)];
        hh_view.backgroundColor = [UIColor whiteColor];
        [self addSubview:hh_view];
        
        self.aImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 40, 40)];
        [_aImageView sd_setImageWithURL:Nil placeholderImage:[UIImage imageNamed:@"Picture_default_image"]];
        [hh_view addSubview:_aImageView];
        
        self.nameLabel = [LTools createLabelFrame:CGRectMake(_aImageView.right + 10, 10, 150, 20) title:@"jj" font:14 align:NSTextAlignmentLeft textColor:[UIColor blackColor]];
        [hh_view addSubview:_nameLabel];
        
        self.timeLabel = [LTools createLabelFrame:CGRectMake(hh_view.width - 10 , 0, 100, 20) title:@"08-09" font:12 align:NSTextAlignmentRight textColor:[UIColor lightGrayColor]];
        [hh_view addSubview:_timeLabel];
        
        self.contentLabel = [LTools createLabelFrame:CGRectMake(_nameLabel.left, _nameLabel.bottom, hh_view.width - 20 - _aImageView.right, 20) title:@"kalskla" font:14 align:NSTextAlignmentLeft textColor:[UIColor blackColor]];
        [hh_view addSubview:_contentLabel];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

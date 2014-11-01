//
//  BBSRecommendCell.m
//  FBCircle
//
//  Created by lichaowei on 14-8-8.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "BBSRecommendCell.h"

@implementation BBSRecommendCell
{
    UIView *hh_view;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        hh_view = [[UIView alloc]initWithFrame:CGRectMake(8, 0, 304, 69)];
        hh_view.backgroundColor = [UIColor whiteColor];
        [self addSubview:hh_view];
        
        self.topLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 304, 1.f)];
        _topLine.backgroundColor = COLOR_TABLE_LINE;
        [hh_view addSubview:_topLine];
        
        self.aImageView = [[UIImageView alloc]initWithFrame:CGRectMake(13, 13, 69 - 26, 69 - 26)];
        [_aImageView sd_setImageWithURL:Nil placeholderImage:[UIImage imageNamed:@"Picture_default_image"]];
        [hh_view addSubview:_aImageView];
        
        self.nameLabel = [LTools createLabelFrame:CGRectMake(_aImageView.right + 10, 10, 150, 20) title:@"雨人" font:14 align:NSTextAlignmentLeft textColor:[UIColor blackColor]];
        [hh_view addSubview:_nameLabel];
        _nameLabel.font = [UIFont boldSystemFontOfSize:14];
        
        self.timeLabel = [LTools createLabelFrame:CGRectMake(hh_view.width - 10 - 100 , 10, 100, 20) title:@"08-09" font:12 align:NSTextAlignmentRight textColor:[UIColor lightGrayColor]];
        [hh_view addSubview:_timeLabel];
        
    }
    return self;
}


- (void)setCellData:(NSString *)aModel OHLabel:(UIView *)OHLabel
{
    self.content_label = OHLabel;
    
    _content_label.userInteractionEnabled = YES;
    
    CGFloat aHeight = 30 + _content_label.height + 10;
    
    _content_label.left = _nameLabel.left + 10 - 2;
    _content_label.top = _nameLabel.bottom + 5;
    [self addSubview:_content_label];
    
//    CGFloat aHeight = 30 + _content_label.height + 10;
    aHeight = aHeight > 69 ? aHeight : 69;
    
    CGFloat dis = self.content_label.height - 17.f;
    
    hh_view.height = aHeight + (dis + dis ? 10 : 0);
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

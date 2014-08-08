//
//  PraiseMemberCell.m
//  FBCircle
//
//  Created by lichaowei on 14-8-8.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "PraiseMemberCell.h"

@implementation PraiseMemberCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.aImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 37, 37)];
        [self addSubview:_aImageView];
        
        self.aTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(_aImageView.right + 5, 0, 150, 55)];
        [self addSubview:_aTitleLabel];
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

//
//  GJiuYuanCell.m
//  FBCircle
//
//  Created by gaomeng on 14-8-15.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "GJiuYuanCell.h"

@implementation GJiuYuanCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
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




-(void)loadViewWithIndexPath:(NSIndexPath*)theIndexPath{
    
    self.titielImav  = [[UIImageView alloc]init];
    if (theIndexPath.row == 0) {
        self.titielImav.frame = CGRectMake(18, 15, 15, 15);
        [self.titielImav setImage:[UIImage imageNamed:@"fhome.png"]];
    }else if (theIndexPath.row == 1){
        self.titielImav.frame = CGRectMake(18, 15, 15, 15);
        [self.titielImav setImage:[UIImage imageNamed:@"fearth.png"]];
    }else if (theIndexPath.row == 2){
        self.titielImav.frame = CGRectMake(18, 15, 15, 15);
        [self.titielImav setImage:[UIImage imageNamed:@"ftel.png"]];
    }
    
    [self.contentView addSubview:self.titielImav];
    
}




@end

//
//  BBSAddMemberCell.m
//  FBCircle
//
//  Created by soulnear on 14-8-11.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "BBSAddMemberCell.h"

@implementation BBSAddMemberCell
@synthesize selected_button = _selected_button;
@synthesize delegate = _delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        
        _selected_button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _selected_button.frame = CGRectMake(5,5,40,60);
        
        [_selected_button setImage:[UIImage imageNamed:@"bbs_add_member_quan"] forState:UIControlStateNormal];
        
        [_selected_button setImage:[UIImage imageNamed:@"bbs_add_member_xuanzhong"] forState:UIControlStateSelected];
        
        [_selected_button addTarget:self action:@selector(selectedButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:_selected_button];
        
        
        _headImageV=[[UIImageView alloc]init];
        
        CALayer *l = [_headImageV layer];   //获取ImageView的层
        [l setMasksToBounds:YES];
        [l setCornerRadius:3.0f];
        
        // _headImageV.backgroundColor=[UIColor redColor];
        [self addSubview:_headImageV];
        _nameLabel=[[UILabel alloc]init];
        _nameLabel.font=[UIFont systemFontOfSize:15];
        _nameLabel.textColor=[UIColor blackColor];
        [self addSubview:_nameLabel];
        
    }
    return self;
}
/**
 */
-(void)setFriendAttribute:(FriendAttribute *)FriendAttributemodel{
    
    /**
     *          face = "http://bbs.fblife.com/ucenter/avatar.php?uid=355696&type=virtual&size=small";
     status = 1;
     uid = 355696;
     uname = ivyandrich;
     */
    
    
    [_headImageV setImageWithURL:[NSURL URLWithString:FriendAttributemodel.face] placeholderImage:[UIImage imageNamed:@"xiaotouxiang_92_92.png"]];
    _nameLabel.text=FriendAttributemodel.uname;
    
}

-(void)layoutSubviews{
    
    _headImageV.frame=CGRectMake(50, 12, 46, 46);
    
    _nameLabel.frame=CGRectMake(110, 0, 150,self.frame.size.height);
    
}

- (void)qingright
{
    
    //    [UIView beginAnimations:nil context:NULL];
    //    [UIView setAnimationDuration:2];
    //    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:_nameLabel cache:YES];
    //    [UIView commitAnimations];
    
    NSLog(@"q");
    
}

#pragma mark - 选择用户

-(void)selectedButtonTap:(UIButton *)button
{
    button.selected = !button.selected;
    
    if (_delegate && [_delegate respondsToSelector:@selector(selectedButtonTap: isSelected:)])
    {
        [_delegate selectedButtonTap:self isSelected:button.selected];
    }
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

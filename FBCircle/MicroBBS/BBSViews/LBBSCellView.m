//
//  LBBSCellView.m
//  FBCircle
//
//  Created by lichaowei on 14-8-11.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "LBBSCellView.h"
#import "TopicModel.h"

@implementation LBBSCellView
{
    id _target;
    SEL _action;
}

- (id)initWithFrame:(CGRect)frame
             target:(id)target
             action:(SEL)action
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _target = target;
        _action = action;
        
        self.aImageView = [[UIImageView alloc]initWithFrame:CGRectMake(8+12, 10, 53, 53)];
        [self addSubview:_aImageView];
        
        self.aTitleLabel = [LTools createLabelFrame:CGRectMake(_aImageView.right + 7 , 9, 200, 21) title:@"testlll" font:14 align:NSTextAlignmentLeft textColor:[UIColor blackColor]];
        _aTitleLabel.font = [UIFont boldSystemFontOfSize:16];
        
        [self addSubview:_aTitleLabel];
        
        self.subTitleLabel = [LTools createLabelFrame:CGRectMake(_aTitleLabel.left, _aTitleLabel.bottom, 188, 41) title:@"aksdlkajksldjalkdsjklasjdlkajskdlajklsjdakldjakl" font:14 align:NSTextAlignmentLeft textColor:[UIColor lightGrayColor]];
        [self addSubview:_subTitleLabel];
        
        UIImageView *arrow_image = [[UIImageView alloc]initWithFrame:CGRectMake(276 , self.height/2.f - 13/2.f, 8, 13)];
        arrow_image.image = [UIImage imageNamed:@"jiantou"];
        [self addSubview:arrow_image];
    }
    return self;
}

-(void)setCellWithModel:(TopicModel *)aModel
{
    [self.aImageView sd_setImageWithURL:[NSURL URLWithString:aModel.forumpic] placeholderImage:[UIImage imageNamed:@"Picture_default_image"]];
    self.aTitleLabel.text = aModel.title;
    self.subTitleLabel.text = aModel.sub_content;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.alpha = 0.5;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    if (_target && [_target respondsToSelector:_action]) {
        
#pragma clang diagnostic push
        
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        
        [_target performSelector:_action withObject:self];
        
#pragma clang diagnostic pop
        
        
    }
    
    self.alpha = 1.0;
    
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.alpha = 1.0;
}


@end

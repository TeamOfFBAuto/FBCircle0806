//
//  LButtonView.m
//  FBCircle
//
//  Created by lichaowei on 14-8-6.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "LButtonView.h"

@implementation LButtonView
{
    id _target;
    SEL _action;
}

- (id)initWithFrame:(CGRect)frame
           imageUrl:(NSString *)url
   placeHolderImage:(UIImage *)defaulImage
              title:(NSString *)title
             target:(id)target
             action:(SEL)action
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.layer.cornerRadius = 3.f;
        self.backgroundColor = [UIColor whiteColor];
        
        _target = target;
        _action = action;
        
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height - 18)];
        [_imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:defaulImage];
        [self addSubview:_imageView];
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _imageView.bottom, self.width, 18)];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = title;
        [self addSubview:_titleLabel];
        
    }
    return self;
}

/**
 *  左侧小图标
 */

- (id)initWithFrame:(CGRect)frame
          leftImage:(UIImage*)aImage
              title:(NSString *)title
             target:(id)target
             action:(SEL)action
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.layer.cornerRadius = 3.f;
        self.backgroundColor = [UIColor whiteColor];
        
        _target = target;
        _action = action;
        
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, (self.height-aImage.size.height)/2.f, aImage.size.width, aImage.size.height)];
        [_imageView setImage:aImage];
        [self addSubview:_imageView];
        
        self.titleLabel = [LTools createLabelFrame:CGRectMake(_imageView.right + 10, _imageView.top - 1, 260, 16) title:title font:14 align:NSTextAlignmentLeft textColor:[UIColor blackColor]];
        [self addSubview:_titleLabel];
        
        UIImageView *line_h = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.height - 1, self.width, 0.5f)];
        line_h.backgroundColor = [UIColor colorWithHexString:@"f0f0f0"];
        [self addSubview:line_h];
        
    }
    return self;
}


/**
 *  左侧小图标\右侧图标（有就显示）
 */

- (id)initWithFrame:(CGRect)frame
          leftImage:(UIImage *)leftImage
         rightImage:(UIImage *)rightImage
              title:(NSString *)title
             target:(id)target
             action:(SEL)action
      lineDirection:(Line_Direction)direction
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.layer.cornerRadius = 3.f;
        self.backgroundColor = [UIColor whiteColor];
        
        _target = target;
        _action = action;
        
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, (self.height-leftImage.size.height)/2.f, leftImage.size.width, leftImage.size.height)];
        [_imageView setImage:leftImage];
        [self addSubview:_imageView];
        
        if (rightImage) {
            UIImageView *rightImageV = [[UIImageView alloc]initWithFrame:CGRectMake(self.width - 10 - rightImage.size.width, (self.height-rightImage.size.height)/2.f, rightImage.size.width, rightImage.size.height)];
            [rightImageV setImage:rightImage];
            [self addSubview:rightImageV];
        }
        
        self.titleLabel = [LTools createLabelFrame:CGRectMake(_imageView.right + 10, _imageView.top - 1, 260, 16) title:title font:14 align:NSTextAlignmentLeft textColor:[UIColor blackColor]];
        [self addSubview:_titleLabel];
        
        if (direction == Line_No) {
            
        }else
        {
            UIImageView *line_h = [[UIImageView alloc]initWithFrame:CGRectMake(0, (direction == Line_Up ? 0: self.height - 1), self.width, 0.5f)];
            line_h.backgroundColor = [UIColor colorWithHexString:@"f0f0f0"];
            [self addSubview:line_h];
        }
    }
    return self;
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

    
//    if (self.normalColor) {
//        self.backgroundColor = [UIColor colorWithHexString:self.normalColor];
//    }else
//    {
//        self.backgroundColor = [UIColor clearColor];
//    }

}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
   self.alpha = 1.0;
}


@end

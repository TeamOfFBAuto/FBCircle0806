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

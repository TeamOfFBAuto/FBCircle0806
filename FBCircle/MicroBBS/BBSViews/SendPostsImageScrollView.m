//
//  SendPostsImageScrollView.m
//  FBCircle
//
//  Created by soulnear on 14-8-6.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "SendPostsImageScrollView.h"

@implementation SendPostsImageScrollView
@synthesize data_array = _data_array;




- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


//208  274
-(void)loadAllViewsWith:(NSMutableArray *)array
{
    self.data_array = array;
    
    for (UIView * view in self.subviews) {
        [view removeFromSuperview];
    }
    
    for (int i = 0;i < self.data_array.count;i++)
    {
        UIImage * image = [self.data_array objectAtIndex:i];
        
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15.5+114*i,6.5,104,137)];
        
        imageView.image = image;
        
        imageView.tag = 100 + i;
        
        imageView.userInteractionEnabled = YES;
        
        imageView.contentMode = UIViewContentModeScaleToFill;
        
        [self addSubview:imageView];
        
        
        UIButton * close_button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        close_button.frame = CGRectMake(82,-10,30,30);
        
        close_button.tag = 1000 + i;
        
        [close_button addTarget:self action:@selector(deleteImageTap:) forControlEvents:UIControlEventTouchUpInside];
        
        [close_button setImage:[UIImage imageNamed:@"Send_Image_close.png"] forState:UIControlStateNormal];
        
        [imageView addSubview:close_button];
    }
    
    self.contentSize = CGSizeMake(15.5+114*self.data_array.count,0);
}


-(void)deleteImageTap:(UIButton *)sender
{
    NSLog(@"button tap");
    
    
    UIImageView * current_imageview = (UIImageView *)[self viewWithTag:sender.tag-1000+100];
    
    [current_imageview removeFromSuperview];
    
    
    for (int i = sender.tag-1000 + 1;i < self.data_array.count;i++)
    {        
        UIImageView * imageview = (UIImageView *)[self viewWithTag:i+100];
        
        imageview.tag = i+100-1;
        
        
        CGRect rect = imageview.frame;
        
        rect.origin.x = 15.5+114*(i-1);
        
        imageview.frame = rect;
        
        
        UIButton * button = (UIButton *)[self viewWithTag:i+1000];
        
        button.tag = i+1000-1;
    }
    
    [self.data_array removeObjectAtIndex:sender.tag-1000];
    
    self.contentSize = CGSizeMake(15.5+114*self.data_array.count,0);
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end













//
//  LActionSheet.m
//  FBCircle
//
//  Created by lichaowei on 14-8-11.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "LActionSheet.h"
#define KLEFT 20
#define KTOP 20
#define DIS_SMALL 10
#define DIS_BIG 22

@implementation LActionSheet

- (id)initWithTitles:(NSArray *)titles images:(NSArray *)images sheetStyle:(SHEET_STYLE)style action:(ActionBlock)aBlock
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        // Initialization code
        
        self.frame = [UIScreen mainScreen].bounds;
        
        self.window.windowLevel = UIAlertViewStyleDefault;
        
        bgView = [[UIView alloc]init];
        [self addSubview:bgView];
        
        actionBlock = aBlock;
        
        aStyle = style;
        
        if (style == Style_Normal) {
            
            self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
            self.alpha = 0.0;
            
            bgView.backgroundColor = [UIColor clearColor];
            
            UIImageView *arrow = [[UIImageView alloc]initWithFrame:CGRectMake(572/2.f + 4, 0, 11, 5)];
            arrow.image = [UIImage imageNamed:@"zhankaijiantou22_10"];
            [bgView addSubview:arrow];
            
            UIView *section_bgview = [[UIView alloc]init];
            section_bgview.backgroundColor = [UIColor whiteColor];
            section_bgview.layer.cornerRadius = 3.f;
            [bgView addSubview:section_bgview];
            
            for (int i = 0; i < titles.count; i ++) {
                UIImage *aImage = [images objectAtIndex:i];
                NSString *title = [titles objectAtIndex:i];
                CGFloat left = 3.0;
                if (i != 0) {
                    left = 0.0;
                }
                
                LButtonView *btn = [[LButtonView alloc]initWithFrame:CGRectMake(left, 50 * i, 320, 50) leftImage:aImage rightImage:nil title:title target:self action:@selector(actionToDo:) lineDirection:Line_No];
                btn.tag = 100 + i;
                [section_bgview addSubview:btn];
                
                if (i < titles.count - 1) {
                    UIImageView *line_h = [[UIImageView alloc]initWithFrame:CGRectMake(15, btn.bottom - 1, self.width - 30, 0.5f)];
                    line_h.backgroundColor = [UIColor colorWithHexString:@"f0f0f0"];
                    [section_bgview addSubview:line_h];
                }
                
            }
            
            section_bgview.frame = CGRectMake(0, 5, 320, 50 * titles.count);
            bgView.frame = CGRectMake(0, 0, 320, 50 * titles.count + 5);
            
            
        }else if (style == Style_SideBySide)
        {
            
            bgView.backgroundColor = [UIColor colorWithHexString:@"575757"];
            bgView.layer.cornerRadius = 3.f;
            
            for (int i = 0; i < titles.count; i ++) {
                
                UIImage *aImage = [images objectAtIndex:i];
                NSString *title = [titles objectAtIndex:i];
                
                LButtonView *btn = [[LButtonView alloc]initWithFrame:CGRectMake(5 + 60 * i, 0, 60, 75/2.f) leftImage:aImage rightImage:nil title:title target:self action:@selector(actionToDo:) lineDirection:Line_No];
                btn.backgroundColor = [UIColor colorWithHexString:@"575757"];
                btn.tag = 100 + i;
                btn.titleLabel.textColor = [UIColor whiteColor];
                [bgView addSubview:btn];
                
                if (i < titles.count - 1) {
                    UIImageView *line_h = [[UIImageView alloc]initWithFrame:CGRectMake(btn.right - 1, 13, 1, 13)];
                    line_h.backgroundColor = [UIColor colorWithHexString:@"f0f0f0"];
                    [bgView addSubview:line_h];
                }
            }
            
            bgView.frame = CGRectMake(0, 0, 10 + 60 * titles.count + 10, 75/2.f);
            
        }else if (style == Style_Bottom)
        {
            for (int i = 0; i < titles.count; i ++) {
                NSString *title = [titles objectAtIndex:i];
                
                if (i == 0) {
                    UILabel *titleL = [LTools createLabelFrame:CGRectMake(0, 10, self.width, 45) title:title font:14 align:NSTextAlignmentCenter textColor:[UIColor blackColor]];
                    [bgView addSubview:titleL];
                }else
                {
                    UIButton *btn = [LTools createButtonWithType:UIButtonTypeCustom frame:CGRectMake(22, 10 + 45 + 10 + (15 + 45) * (i - 1), self.width - 22 * 2, 45) normalTitle:title backgroudImage:Nil superView:bgView target:self action:@selector(actionToDo:)];
                    btn.layer.cornerRadius = 3.f;
                    
                    if (i == 1) {
                        btn.backgroundColor = [UIColor colorWithHexString:@"06be04"];
                    }else if (i == 2)
                    {
                        btn.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
                        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                        btn.layer.borderWidth = 0.5f;
                        btn.layer.borderColor = [UIColor colorWithHexString:@"aaaaaa"].CGColor;
                        
                    }
                }
                
                self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
                self.alpha = 0.0;
                bgView.backgroundColor = [UIColor colorWithHexString:@"edecf1"];
                bgView.frame = CGRectMake(0, [UIApplication sharedApplication].keyWindow.bottom, 320, 10 + 60 * titles.count + 10);
            }
        }
        
        [self addSubview:bgView];
        
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        
    }
    return self;
}

- (void)showFromView:(UIView *)aView
{
    //相对于屏幕坐标
    CGRect newFrame = [aView.superview convertRect:aView.frame toView:[UIApplication sharedApplication].keyWindow];
    
    CGRect aFrame = bgView.frame;
    
    if (aStyle == Style_Normal) {
        
        aFrame.origin.y = newFrame.origin.y + newFrame.size.height - 5;
        
    }else if (aStyle == Style_SideBySide){
        
        aFrame.origin.x = newFrame.origin.x - bgView.width - 5;
        aFrame.origin.y = newFrame.origin.y - 5;
        
    }else if (aStyle == Style_Bottom)
    {
        aFrame.origin.y = [UIApplication sharedApplication].keyWindow.bottom - aFrame.size.height;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        
        bgView.frame = aFrame;
        
        self.alpha = 1.0;
    }];
}

- (void)actionToDo:(LButtonView *)button
{
    //0,1,2
    actionBlock(button.tag - 100);
    [self hidden];
}

- (void)hidden
{
    [self removeFromSuperview];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hidden];
}
@end

//
//  MicroBBSInfoController.m
//  FBCircle
//
//  Created by lichaowei on 14-8-8.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "MicroBBSInfoController.h"
#import "BBSMembersController.h"

@interface MicroBBSInfoController ()

@end

@implementation MicroBBSInfoController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIView *first = [self createFirstViewFrame:CGRectMake(18, 15, 320 - 18 * 2, 0)];
    [self.view addSubview:first];
    
    UIView *second = [self createSecondViewFrame:CGRectMake(18, first.bottom + 15, first.width, 0)];
    [self.view addSubview:second];
    
    UIView *third = [self createThirdViewFrame:CGRectMake(18, second.bottom + 15, first.width, 0)];
    [self.view addSubview:third];
    
    UIButton *btn = [LTools createButtonWithType:UIButtonTypeCustom frame:CGRectMake(18, third.bottom + 15, first.width, 40) normalTitle:@"退出微论坛" backgroudImage:nil superView:self.view target:self action:@selector(clickToLeave:)];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 事件处理
//添加成员
- (void)clickToAddMember:(LButtonView *)sender
{
    
}
//成员列表
- (void)clickToMember:(LButtonView *)sender
{
    BBSMembersController *bbsMember = [[BBSMembersController alloc]init];
    [self PushToViewController:bbsMember WithAnimation:YES];
}

//退出论坛
- (void)clickToLeave:(UIButton *)sender
{
    NSString *title = @"确定退出\"车\"";
    LActionSheet *sheet = [[LActionSheet alloc]initWithTitles:@[title,@"退出",@"取消"] images:nil sheetStyle:Style_Bottom action:^(NSInteger buttonIndex) {
        
    }];
    [sheet showFromView:sender];
}

#pragma mark - 网络请求
#pragma mark - 视图创建

- (UIView *)createFirstViewFrame:(CGRect)aFrame
{
    UIView *firstView = [[UIView alloc]initWithFrame:aFrame];
    firstView.layer.cornerRadius = 3.f;
    firstView.layer.borderWidth = 0.5f;
    firstView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    firstView.backgroundColor = [UIColor whiteColor];
    
    LButtonView *btn = [[LButtonView alloc]initWithFrame:CGRectMake(0, 0, firstView.width, 75) leftImage:[UIImage imageNamed:@"jignsai"] rightImage:Nil title:@"车子" target:Nil action:Nil lineDirection:Line_Down];
    [firstView addSubview:btn];
    
    //简介
    NSString *text = @"论坛信息简介，写好多字，阿克苏见大家开始看卡卡是大家阿卡丽按时间段可垃圾深刻了解阿喀琉斯就打开啦几十块来得及阿喀琉斯就打开啦就SD卡辣椒水快乐到家阿喀琉斯就打开啦";
    
    UILabel *descripL = [LTools createLabelFrame:CGRectMake(10, btn.bottom + 10, aFrame.size.width - 20, [LTools heightForText:text width:aFrame.size.width - 20 font:14]) title:text font:14 align:NSTextAlignmentLeft textColor:[UIColor darkGrayColor]];
    descripL.numberOfLines = 0;
    [firstView addSubview:descripL];
    
    aFrame.size.height = descripL.bottom + 10;
    firstView.frame = aFrame;
    
    return firstView;
}

- (UIView *)createSecondViewFrame:(CGRect)aFrame
{
    UIView *firstView = [[UIView alloc]initWithFrame:aFrame];
    firstView.layer.cornerRadius = 3.f;
    firstView.layer.borderWidth = 0.5f;
    firstView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    firstView.backgroundColor = [UIColor whiteColor];
    
    LButtonView *btn1 = [[LButtonView alloc]initWithFrame:CGRectMake(0, 0, aFrame.size.width, 43) leftImage:nil rightImage:[UIImage imageNamed:@"jiantou"] title:@"添加成员" target:self action:@selector(clickToAddMember:) lineDirection:Line_Down];
    [firstView addSubview:btn1];
    
    LButtonView *btn2 = [[LButtonView alloc]initWithFrame:CGRectMake(0, btn1.bottom, aFrame.size.width, 43) leftImage:nil rightImage:[UIImage imageNamed:@"jiantou"] title:@"2名成员" target:self action:@selector(clickToMember:) lineDirection:Line_Down];
    [firstView addSubview:btn2];
    
    aFrame.size.height = btn2.bottom;
    firstView.frame = aFrame;
    
    return firstView;
}

- (UIView *)createThirdViewFrame:(CGRect)aFrame
{
    UIView *firstView = [[UIView alloc]initWithFrame:aFrame];
    firstView.layer.cornerRadius = 3.f;
    firstView.layer.borderWidth = 0.5f;
    firstView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    firstView.backgroundColor = [UIColor whiteColor];
    
    LButtonView *btn2 = [[LButtonView alloc]initWithFrame:CGRectMake(0, 0, aFrame.size.width, 43) leftImage:nil rightImage:[UIImage imageNamed:@"jiantou"] title:@"修改微论坛图标" target:self action:@selector(clickToMember:) lineDirection:Line_Down];
    [firstView addSubview:btn2];
    
    UIImageView *iconImageV = [[UIImageView alloc]initWithFrame:CGRectMake(firstView.width - 33 - 24, (43-24)/2.f, 24, 24)];
    iconImageV.image = [UIImage imageNamed:@"new"];
    [firstView addSubview:iconImageV];
    
    aFrame.size.height = btn2.bottom;
    firstView.frame = aFrame;
    
    return firstView;
}

#pragma mark - delegate

#pragma mark - UITableViewDelegate

@end

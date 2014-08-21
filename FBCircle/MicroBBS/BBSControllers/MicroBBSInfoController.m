//
//  MicroBBSInfoController.m
//  FBCircle
//
//  Created by lichaowei on 14-8-8.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "MicroBBSInfoController.h"
#import "BBSMembersController.h"
#import "BBSAddMemberViewController.h"
#import "BBSInfoModel.h"

@interface MicroBBSInfoController ()
{
    BBSInfoModel *infoModel;
    UIButton *btn;//加入或者退出按钮
}

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
    
    [self getBBSInfoId:self.bbsId];
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
    BBSAddMemberViewController * addMember = [[BBSAddMemberViewController alloc] init];
    addMember.fid = infoModel.id;
    [self PushToViewController:addMember WithAnimation:YES];
}
//成员列表
- (void)clickToMember:(LButtonView *)sender
{
    BBSMembersController *bbsMember = [[BBSMembersController alloc]init];
    bbsMember.bbs_id = infoModel.id;
    [self PushToViewController:bbsMember WithAnimation:YES];
}

//退出论坛
- (void)clickToLeave:(UIButton *)sender
{
     __weak typeof(self)weakSelf = self;
    NSString *title1 = [NSString stringWithFormat:@"确定退出\"%@\"",infoModel.name];
    LActionSheet *sheet = [[LActionSheet alloc]initWithTitles:@[title1,@"退出",@"取消"] images:@[@"",[UIImage imageNamed:@"add_login"],[UIImage imageNamed:@"add_quxiao"]] sheetStyle:Style_Bottom action:^(NSInteger buttonIndex) {
        
        if (buttonIndex == 1) {
            
            [weakSelf leaveOrJoinBBS:!sender.selected];
        }
        
    }];
    [sheet showFromView:sender];
}

#pragma mark - 网络请求

- (void)getBBSInfoId:(NSString *)bbsId
{
    __weak typeof(self)weakSelf = self;

    NSString *url = [NSString stringWithFormat:FBCIRCLE_BBS_INFO,bbsId];
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
    
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        NSLog(@"result %@",result);
        NSDictionary *dataInfo = [result objectForKey:@"datainfo"];
        
        if ([dataInfo isKindOfClass:[NSDictionary class]]) {
            
            infoModel = [[BBSInfoModel alloc]initWithDictionary:dataInfo];
            
            [weakSelf prepareViews];
        }
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        NSLog(@"result %@",failDic);
        
        [LTools showMBProgressWithText:[failDic objectForKey:@"ERRO_INFO"] addToView:self.view];
        
    }];
}

/**
 *  退出论坛\加入
 */
- (void)leaveOrJoinBBS:(BOOL)leave
{
     __weak typeof(self)weakSelf = self;
    
    NSString *url;
    if (leave) {
        url = [NSString stringWithFormat:FBCIRCLE_BBS_MEMBER_LEAVER,[SzkAPI getAuthkey],infoModel.id];
    }else
    {
        url = [NSString stringWithFormat:FBCIRCLE_BBS_MEMBER_JOIN,[SzkAPI getAuthkey],infoModel.id];
    }

    LTools *tool = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
        
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        NSLog(@"result %@",result);
        NSString *errinfo = [result objectForKey:@"errinfo"];
        int errcode = [[result objectForKey:@"errcode"]integerValue];
        
        if (errcode == 0) {
            
            NSString *info = leave ? @"退出论坛成功" : @"加入论坛成功";
            
            [LTools showMBProgressWithText:info addToView:weakSelf.view];
            
            btn.selected = NO;
            
        }

        
        [LTools showMBProgressWithText:errinfo addToView:weakSelf.view];
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        NSLog(@"result %@",failDic);
        
        [LTools showMBProgressWithText:[failDic objectForKey:@"ERRO_INFO"] addToView:weakSelf.view];
        
    }];
}


#pragma mark - 视图创建

- (void)prepareViews
{
    self.titleLabel.text = infoModel.name;
    
    UIView *first = [self createFirstViewFrame:CGRectMake(18, 15, 320 - 18 * 2, 0)];
    [self.view addSubview:first];
    
    UIView *second = [self createSecondViewFrame:CGRectMake(18, first.bottom + 15, first.width, 0)];
    [self.view addSubview:second];
    
    UIView *third = [self createThirdViewFrame:CGRectMake(18, second.bottom + 15, first.width, 0)];
    [self.view addSubview:third];
    
    btn = [LTools createButtonWithType:UIButtonTypeCustom frame:CGRectMake(18, third.bottom + 15, first.width, 40) normalTitle:@"退出微论坛"  image:nil backgroudImage:[UIImage imageNamed:@"add_tuichu"] superView:self.view target:self action:@selector(clickToLeave:)];
    [btn setTitle:@"加入微论坛" forState:UIControlStateSelected];
    
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
}

- (UIView *)createFirstViewFrame:(CGRect)aFrame
{
    UIView *firstView = [[UIView alloc]initWithFrame:aFrame];
    firstView.layer.cornerRadius = 3.f;
    firstView.layer.borderWidth = 0.5f;
    firstView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    firstView.backgroundColor = [UIColor whiteColor];
    
    UIImage *defaultImage = [UIImage imageNamed:@"Picture_default_image"];
    LButtonView *btn1 = [[LButtonView alloc]initWithFrame:CGRectMake(0, 0, firstView.width, 75) leftImage:[LTools scaleToSizeWithImage:defaultImage size:CGSizeMake(35, 35)] rightImage:Nil title:infoModel.name target:Nil action:Nil lineDirection:Line_Down];
    [firstView addSubview:btn1];
    
    [btn1.imageView sd_setImageWithURL:[NSURL URLWithString:infoModel.headpic] placeholderImage:defaultImage];
    
    //简介
    
    UILabel *descripL = [LTools createLabelFrame:CGRectMake(10, btn1.bottom + 10, aFrame.size.width - 20, [LTools heightForText:infoModel.intro width:aFrame.size.width - 20 font:14]) title:infoModel.intro font:14 align:NSTextAlignmentLeft textColor:[UIColor darkGrayColor]];
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
    
    NSString *title = [NSString stringWithFormat:@"%@名成员",infoModel.member_num];
    
    LButtonView *btn2 = [[LButtonView alloc]initWithFrame:CGRectMake(0, btn1.bottom, aFrame.size.width, 43) leftImage:nil rightImage:[UIImage imageNamed:@"jiantou"] title:title target:self action:@selector(clickToMember:) lineDirection:Line_Down];
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

-(void)dealloc
{
    
}

@end

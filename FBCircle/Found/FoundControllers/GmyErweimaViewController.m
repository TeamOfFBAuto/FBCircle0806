//
//  GmyErweimaViewController.m
//  FBCircle
//
//  Created by gaomeng on 14-8-14.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "GmyErweimaViewController.h"

@interface GmyErweimaViewController ()

@end

@implementation GmyErweimaViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.view.backgroundColor = RGBCOLOR(246, 247, 249);
    
    //底层view
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(20, 57, 320-40, 384)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    
    
    //头像view
    UIImageView *faceImv = [[UIImageView alloc]initWithFrame:CGRectMake(20, 20, 64, 64)];
    faceImv.backgroundColor = [UIColor redColor];
    [backView addSubview:faceImv];
    
    
    //名字
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(faceImv.frame)+11, CGRectGetMinY(faceImv.frame)+9, 170, 17)];
    nameLabel.backgroundColor = [UIColor orangeColor];
    nameLabel.font = [UIFont boldSystemFontOfSize:16];
    nameLabel.textColor = [UIColor blackColor];
    [backView addSubview:nameLabel];
    
    //地区
    UILabel *diquLabel = [[UILabel alloc]initWithFrame:CGRectMake(nameLabel.frame.origin.x, CGRectGetMaxY(nameLabel.frame)+11, 170, 12)];
    diquLabel.backgroundColor = [UIColor purpleColor];
    diquLabel.font = [UIFont systemFontOfSize:11];
    diquLabel.textColor = RGBCOLOR(102, 102, 102);
    [backView addSubview:diquLabel];
    
    
    
    //二维码图片
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMinX(faceImv.frame)+16, CGRectGetMaxY(faceImv.frame)+33, 200, 200)];
    imageV.backgroundColor = [UIColor grayColor];
    [backView addSubview:imageV];
    
    //文字描述
    UILabel *tishiLabel = [[UILabel alloc]initWithFrame:CGRectMake(44, CGRectGetMaxY(imageV.frame)+35, 180, 13)];
    tishiLabel.font = [UIFont systemFontOfSize:10.5];
    tishiLabel.textColor = RGBCOLOR(148, 148, 148);
    tishiLabel.text = @"扫一扫上面的二维码图案，加我为好友";
    [backView addSubview:tishiLabel];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

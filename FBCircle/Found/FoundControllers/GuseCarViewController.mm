//
//  GuseCarViewController.m
//  FBCircle
//
//  Created by gaomeng on 14-8-5.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "GuseCarViewController.h"

@interface GuseCarViewController ()

@end

@implementation GuseCarViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    for (int i = 0; i<3; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor orangeColor];
        
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

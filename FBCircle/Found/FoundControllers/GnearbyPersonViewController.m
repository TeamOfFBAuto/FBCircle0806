//
//  GnearbyPersonViewController.m
//  FBCircle
//
//  Created by gaomeng on 14-8-11.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "GnearbyPersonViewController.h"

@interface GnearbyPersonViewController ()

@end

@implementation GnearbyPersonViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any addi
    _tableView = [[RefreshTableView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
    _tableView.refreshDelegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

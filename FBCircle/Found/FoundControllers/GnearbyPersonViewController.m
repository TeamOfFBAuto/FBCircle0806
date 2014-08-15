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
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    _tableView = [[RefreshTableView alloc]init];
    
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

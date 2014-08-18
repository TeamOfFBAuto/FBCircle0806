//
//  GnearbyPersonViewController.m
//  FBCircle
//
//  Created by gaomeng on 14-8-11.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "GnearbyPersonViewController.h"
#import "GpersonInfoViewController.h"//用户信息界面

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



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
    }
    return cell;
    
}

-(CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath{
    return 63;
}





-(void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.navigationController pushViewController:[[GpersonInfoViewController alloc]init] animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

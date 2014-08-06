//
//  FoundViewController.m
//  FBCircle
//
//  Created by soulnear on 14-8-4.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "FoundViewController.h"

#import "GmFoundScanViewController.h"//扫一扫

#import "GuseCarViewController.h"

@interface FoundViewController ()

@end

@implementation FoundViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.view.backgroundColor = RGBCOLOR(246, 247, 249);
    
    
    
    
    //主tableview
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 568) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _tableView.separatorColor = [UIColor clearColor];
    
    [self.view addSubview:_tableView];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - UITableViewDelegate && UITableViewDataSource

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger num = 0;
    
    if (section == 0) {
        num = 1;
    }else if (section == 1){
        num = 2;
    }else if (section == 2){
        num = 1;
    }else if (section == 3){
        num = 1;
    }
    
    
    return num;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell ) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
    }
    
    
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    //图片
    UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(12, 10, 23, 23)];
    imv.layer.cornerRadius = 4;
    imv.backgroundColor = [UIColor redColor];
    [cell.contentView addSubview:imv];
    
    
    //标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imv.frame)+13, CGRectGetMinY(imv.frame)+4, 80, 15)];
    titleLabel.font = [UIFont systemFontOfSize:15];
    [cell.contentView addSubview:titleLabel];
    
    
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        titleLabel.text = @"附近的人";
    }else if (indexPath.section == 1 && indexPath.row == 0){
        titleLabel.text = @"用车服务";
    }else if (indexPath.section == 1 && indexPath.row ==1){
        titleLabel.text = @"E族救援队";
    }else if (indexPath.section == 2 && indexPath.row == 0){
        titleLabel.text = @"扫一扫";
    }else if (indexPath.section == 3 && indexPath.row == 0){
        titleLabel.text = @"购物";
    }
    
    
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    return cell;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    CGFloat height = 0;
    
    if (section == 0) {
        height = 0.01;
    }
    return height;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"row:%d  section:%d",indexPath.row,indexPath.section);
    
    if (indexPath.row == 0 && indexPath.section == 2) {//扫一扫
        [self.navigationController pushViewController:[[GmFoundScanViewController alloc]init] animated:YES];
    }else if (indexPath.row == 0 && indexPath.section == 1){//用车服务
        [self.navigationController pushViewController:[[GuseCarViewController alloc]init] animated:YES];
    }
    
    
}


@end

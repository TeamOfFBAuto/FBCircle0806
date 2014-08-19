//
//  CreateBBSChooseTypeViewController.m
//  FBCircle
//
//  Created by soulnear on 14-8-14.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "CreateBBSChooseTypeViewController.h"

@interface CreateBBSChooseTypeViewController ()
{
    int currentPage;///当前选中的类型
}

@end

@implementation CreateBBSChooseTypeViewController
@synthesize myTableView = _myTableView;
@synthesize data_array = _data_array;
@synthesize name_Label = _name_Label;


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
    
    self.titleLabel.text = @"创建新论坛";
    self.rightString = @"完成";
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeNull WithRightButtonType:MyViewControllerRightbuttonTypeText];
    
    NSString * path = [[NSBundle mainBundle] pathForResource:@"BBSClassify" ofType:@"plist"];
    
    NSDictionary * dictionary = [NSDictionary dictionaryWithContentsOfFile:path];
    NSArray * special = [dictionary objectForKey:@"special"];
    NSArray * normal = [dictionary objectForKey:@"normal"];
    
    _data_array = [NSMutableArray array];
    [_data_array addObjectsFromArray:special];
    [_data_array addObjectsFromArray:normal];
    
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,320,(iPhone5?568:480)-64) style:UITableViewStylePlain];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    [self.view addSubview:_myTableView];
}


#pragma mark - 完成

-(void)submitData:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _data_array.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"identifier";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    if (currentPage == indexPath.row)
    {
        _name_Label.text = [_data_array objectAtIndex:indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.textLabel.text = [_data_array objectAtIndex:indexPath.row];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == currentPage) {
        return;
    }
    
    
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    
    UITableViewCell * last_cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:currentPage inSection:0]];
    
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    last_cell.accessoryType = UITableViewCellAccessoryNone;
    
    currentPage = indexPath.row;
    
    _name_Label.text = [_data_array objectAtIndex:indexPath.row];
}


-(void)dealloc
{
    _name_Label = nil;
    _data_array = nil;
    
    _myTableView = nil;
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
   
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end



























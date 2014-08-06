//
//  ClassifyBBSController_Sub.m
//  FBCircle
//
//  Created by lichaowei on 14-8-6.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "ClassifyBBSController_Sub.h"
#import "JoinBBSCell.h"

@interface ClassifyBBSController_Sub ()<UISearchBarDelegate,RefreshDelegate,UITableViewDataSource>
{
    RefreshTableView *_table;
}

@end

@implementation ClassifyBBSController_Sub

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
    self.view.backgroundColor = [UIColor colorWithHexString:@"d3d6db"];
    
    self.titleLabel.text = self.navigationTitle;
    
    //搜索
    [self createSearchView];
    
    //数据展示table
    _table = [[RefreshTableView alloc]initWithFrame:CGRectMake(0, 45, 320, self.view.height - 44 - 45 - 20)];
    _table.backgroundColor = [UIColor clearColor];
    _table.refreshDelegate = self;
    _table.dataSource = self;
    
    _table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _table.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view addSubview:_table];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 事件处理

/**
 *  搜索页
 */
- (void)clickToSearch:(UIButton *)sender
{
    NSLog(@"searchPage");
}

#pragma mark - 网络请求
#pragma mark - 视图创建
/**
 *  搜索view
 */
- (void)createSearchView
{
    UIView *search_bgview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 45)];
    search_bgview.backgroundColor = [UIColor colorWithHexString:@"cac9ce"];
    [self.view addSubview:search_bgview];
    
    UISearchBar *bar = [[UISearchBar alloc]initWithFrame:CGRectMake(5, 0, 310, 45)];
    bar.placeholder = @"搜索";
    bar.backgroundColor = [UIColor clearColor];
    bar.delegate = self;
    [search_bgview addSubview:bar];
}

#pragma mark - delegate

#pragma - mark UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [self clickToSearch:nil];
    return NO;
}

#pragma - mark RefreshDelegate <NSObject>

- (void)loadNewData
{
    NSLog(@"loadNewData");
}

- (void)loadMoreData
{
    NSLog(@"loadMoreData");
}

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

#pragma mark - UITableViewDelegate

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier= @"JoinBBSCell";
    
    JoinBBSCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"JoinBBSCell" owner:self options:nil]objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

@end

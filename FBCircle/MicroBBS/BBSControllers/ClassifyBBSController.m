//
//  ClassifyBBSController.m
//  FBCircle
//
//  Created by lichaowei on 14-8-6.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "ClassifyBBSController.h"
#import "ClassifyBBSController_Sub.h"
#import "BBSModel.h"

@interface ClassifyBBSController ()<UISearchBarDelegate>
{
    NSArray *_dataArray;
    NSArray *_titles;
    UIView *search_bgview;
    UIScrollView *bgScroll;
    
    UIView *second_bgView;//第二部分背景view
}

@end

@implementation ClassifyBBSController

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
    self.titleLabel.text = @"分类论坛";
    self.title = @"分类论坛";
    self.view.backgroundColor = [UIColor colorWithHexString:@"d3d6db"];
    
    self.rightImageName = @"+";
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeNull WithRightButtonType:MyViewControllerRightbuttonTypeOther];
    
    //搜索
    [self createSearchView];
    
    bgScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, search_bgview.bottom, 320, self.view.height - 44 - 20 - search_bgview.height)];
    bgScroll.backgroundColor = [UIColor clearColor];
    bgScroll.showsHorizontalScrollIndicator = NO;
    bgScroll.showsVerticalScrollIndicator = YES;
    [self.view addSubview:bgScroll];
    
    //创建第一部分
    
    [self getBBSClass];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 事件处理

/**
 *  进入分类论坛 -- 二级页面
 */

- (void)clickToSubClassifyBBS:(UIButton *)sender
{
    ClassifyBBSController_Sub *sub = [[ClassifyBBSController_Sub alloc]init];
    sub.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:sub animated:YES];
}

/**
 *  添加论坛
 */
- (void)clickToAddBBS
{
    
}

/**
 *  搜索页
 */
- (void)clickToSearch:(UIButton *)sender
{
    NSLog(@"searchPage");
}

#pragma mark - 网络请求
/**
 *  官方论坛分类
 */
- (void)getBBSClass
{
    __weak typeof(self)weakSelf = self;
    
    LTools *tool = [[LTools alloc]initWithUrl:FBCIRCL_MICROBBS_BBSCLASS isPost:NO postData:nil];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        NSLog(@"result %@",result);
        NSArray *dataInfo = [result objectForKey:@"datainfo"];
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:dataInfo.count];
        for (NSDictionary *aDic in dataInfo) {
            
            [arr addObject:[[BBSModel alloc]initWithDictionary:aDic]];
        }
        
        [weakSelf createFirstViewWithTitles:arr];
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        NSLog(@"result %@",failDic);
    }];
}

#pragma mark - 视图创建

/**
 *  搜索view
 */
- (void)createSearchView
{
    search_bgview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 45)];
    search_bgview.backgroundColor = [UIColor colorWithHexString:@"cac9ce"];
    [self.view addSubview:search_bgview];
    
    UISearchBar *bar = [[UISearchBar alloc]initWithFrame:CGRectMake(5, 0, 310, 45)];
    bar.placeholder = @"搜索";
    bar.backgroundColor = [UIColor clearColor];
    bar.delegate = self;
    [search_bgview addSubview:bar];
}

- (void)createFirstViewWithTitles:(NSArray *)titles
{
    _titles = titles;
    
    int k = 0;
    int line = 0;
    for (int i = 0 ; i < titles.count; i ++) {
        NSString *title = ((BBSModel *)[titles objectAtIndex:i]).classname;
        NSString *imageUrl = ((BBSModel *)[titles objectAtIndex:i]).classpic;
        
        k = i % 4;
        line = i / 4;
        
        LButtonView *lBtn = [[LButtonView alloc]initWithFrame:CGRectMake(10 + (5 + 72) * k,15 + (15 + 72) * line, 72, 67) imageUrl:imageUrl placeHolderImage:[UIImage imageNamed:@"defaultPlaceHolder"] title:title target:self action:@selector(clickToSubClassifyBBS:)];
        lBtn.tag = 100 + i;
        
        [bgScroll addSubview:lBtn];
    }
}

- (void)createSecondViewWithDataArray:(NSArray *)array
{
    CGFloat aY = [bgScroll viewWithTag:(_titles.count + 100 - 1)].bottom + 15;
    int k = 0;
    int line = 0;
    for (int i = 0; i < array.count; i ++) {
        k = i % 4;
        line = i / 4;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btn setTitle:[array objectAtIndex:i] forState:UIControlStateNormal];
        btn.frame = CGRectMake(80 * k, aY + 45 * line, 80, 45);
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor whiteColor];
        [btn addTarget:self action:@selector(clickToSubClassifyBBS:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 1000 + i;
        [bgScroll addSubview:btn];
        
        if ((i + 1) % 4 != 0) {
            UIView *hLineView = [[UIView alloc]initWithFrame:CGRectMake(btn.width - 1, 7.5, 0.5, 30)];
            hLineView.backgroundColor = [UIColor colorWithHexString:@"d8d9db"];
            [btn addSubview:hLineView];
        }else
        {
            UIView *hLineView = [[UIView alloc]initWithFrame:CGRectMake(0, btn.bottom - 1, 320, 0.5)];
            hLineView.backgroundColor = [UIColor colorWithHexString:@"bbbec3"];
            [bgScroll addSubview:hLineView];
        }
        
    }
    
    bgScroll.contentSize = CGSizeMake(320, [bgScroll viewWithTag:(array.count + 1000 - 1)].bottom);
}

#pragma mark - delegate

#pragma - mark UICollection

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell*cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor orangeColor];
    
    return  cell;
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(100,130);
}

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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 || indexPath.row == 4) {
        
        return 16;
        
    }else if (indexPath.row == 1 || indexPath.row == 5)
    {
        return 40;
    }
    return 75;
}

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
    return nil;
    
}


@end

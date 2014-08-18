//
//  BBSTopicController.m
//  FBCircle
//
//  Created by lichaowei on 14-8-7.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "BBSTopicController.h"
#import "MyBBSViewController.h"
#import "HotTopicViewController.h"
#import "ClassifyBBSController.h"
#import "PraiseMemberController.h"
#import "ShowImagesViewController.h"

#import "LTools.h"
#import "LSecionView.h"
#import "BBSRecommendCell.h"
#import "SendPostsViewController.h"
#import "TopicCommentModel.h"
#import "BBSInfoModel.h"
#import "TopicModel.h"

typedef enum{
    Action_Topic_Info = 0,//帖子基本信息
    Action_Topic_Zan,//赞帖
    Action_Topic_Top,//置顶
    Action_Topic_Top_Cancel,//取消顶
    Action_Topic_Del//删除帖子
}Network_ACTION;

@interface BBSTopicController ()<UITableViewDataSource,UITableViewDelegate,OHAttributedLabelDelegate>
{
    UITableView *_table;
    int _pageNum;//评论页数
    
    LInputView *inputView;
    NSMutableArray *_dataArray;
    
    NSMutableArray *rowHeights;//所有高度
    NSDictionary *emojiDic;//所有表情
    NSMutableArray *labelArr;//所有label
    
    UIButton *moreBtn;//点击加载更多
    
    TopicModel *aTopicModel;
}

@end

@implementation BBSTopicController

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
    
    self.titleLabel.text = @"主题帖";
    
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeNull WithRightButtonType:MyViewControllerRightbuttonTypeNull];
    
    [self.my_right_button addTarget:self action:@selector(clickToAddBBS) forControlEvents:UIControlEventTouchUpInside];
    
    //数据展示table
    _table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.height - 44 - 20 - 45) style:UITableViewStylePlain];
    _table.backgroundColor = [UIColor clearColor];
    _table.delegate = self;
    _table.dataSource = self;
    
    _table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _table.separatorInset = UIEdgeInsetsMake(0, 8, 0, 8);
    [self.view addSubview:_table];
    
    [self createInputView];
    
    labelArr = [NSMutableArray array];
    rowHeights = [NSMutableArray array];
    _dataArray = [NSMutableArray array];
    
    _pageNum = 1;
    
    //帖子信息
    
    [self networdAction:Action_Topic_Info];
    
    //评论列表
    [self getCommentList];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 事件处理

//进入称赞者页
- (void)clickTOPraiseMember:(UIGestureRecognizer *)tap
{
    PraiseMemberController *praise = [[PraiseMemberController alloc]init];
    self.title = @"";
    praise.tid = self.tid;
    [self PushToViewController:praise WithAnimation:YES];
}

//弹出赞视图
- (void)clickToZan:(UIButton *)sender
{
    NSLog(@"zan");
    
    LActionSheet *sheet = [[LActionSheet alloc]initWithTitles:@[@"赞",@"评论"] images:@[[UIImage imageNamed:@"zhiding"],[UIImage imageNamed:@"zhiding"]] sheetStyle:Style_SideBySide action:^(NSInteger buttonIndex) {
        
        if (buttonIndex == 0) {
            NSLog(@"赞");
            
            [self networdAction:Action_Topic_Zan];
            
        }else if (buttonIndex == 1)
        {
            NSLog(@"评论");
            
            [inputView.textView becomeFirstResponder];
        }
    }];
    [sheet showFromView:sender];
}
//进入我的论坛

- (void)clickToMyBBS:(UIButton *)sender
{
    MyBBSViewController *myBBS = [[MyBBSViewController alloc]init];
    myBBS.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:myBBS animated:YES];
}

- (void)clickToMore:(UIButton *)sender
{
    _pageNum ++;
    
    [self getCommentList];
}
/**
 *  进入分类论坛
 */
- (void)clickToClassifyBBS
{
    ClassifyBBSController *classify = [[ClassifyBBSController alloc]init];
    classify.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:classify animated:YES];
}

/**
 *  添加论坛
 */
- (void)clickToAddBBS
{
    SendPostsViewController * sendPostVC = [[SendPostsViewController alloc] init];
    [self PushToViewController:sendPostVC WithAnimation:YES];
}

/**
 *  进入置顶帖子\删除
 */
- (void)clickToRecommend:(LButtonView *)btn
{
    __weak typeof(self)weakSelf = self;
    LActionSheet *sheet = [[LActionSheet alloc]initWithTitles:@[@"取消置顶",@"删除"] images:@[[UIImage imageNamed:@"quxiao"],[UIImage imageNamed:@"dele"]] sheetStyle:Style_Normal action:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            
            NSLog(@"取消置顶");
            [weakSelf networdAction:Action_Topic_Top];
            
        }else if (buttonIndex == 1)
        {
            NSLog(@"删除");
            [weakSelf networdAction:Action_Topic_Del];
        }

    }];
    
    [sheet showFromView:btn];
}

- (void)clickJoinBBS:(UIButton *)sender
{
    
}


#pragma mark - 网络请求

- (void)sendComment:(NSString *)text
{
    [inputView clearContent];
    
    TopicCommentModel *aModel = [[TopicCommentModel alloc]init];
    aModel.username = [SzkAPI getUsername];
    aModel.content = text;
    aModel.time = [LTools timechangeToDateline];
    aModel.userface = [SzkAPI getUserFace];
    
    [self createRichLabelWithMessage:text isInsert:YES];
    [_dataArray insertObject:aModel atIndex:0];
    [_table reloadData];
    
//    inputView.textView.text = @"<#string#>";
}

/**
 *  添加评论
 */
- (void)addComment:(NSString *)text
{
    __weak typeof(self)weakSelf = self;
    
    NSString *url = [NSString stringWithFormat:FBCIRCLE_COMMENT_ADD,[SzkAPI getAuthkey],text,self.fid,self.tid];
    
    url = [url stringByReplacingEmojiUnicodeWithCheatCodes];
    
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        NSLog(@"result %@",result);
        NSDictionary *dataInfo = [result objectForKey:@"datainfo"];
        if ([result isKindOfClass:[NSDictionary class]]) {
            
            int errcode = [[result objectForKey:@"errcode"]integerValue];
            if (errcode == 0) {
                
                [weakSelf sendComment:text];
            }else
            {
                [LTools showMBProgressWithText:[dataInfo objectForKey:@"errinfo"] addToView:self.view];
            }
            
        }
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        NSLog(@"result %@",failDic);
        [LTools showMBProgressWithText:[failDic objectForKey:@"errinfo"] addToView:self.view];
    }];
}

/**
 *  添加评论
 */
- (void)networdAction:(Network_ACTION)action
{    
    NSString *url;
    if (action == Action_Topic_Zan) {
        
        url = [NSString stringWithFormat:FBCIRCLE_TOPIC_ZAN,[SzkAPI getAuthkey],self.tid];
        
    }else if (action == Action_Topic_Top)
    {
        url = [NSString stringWithFormat:FBCIRCLE_TOPIC_TOP,[SzkAPI getAuthkey],self.fid,self.tid];
        
    }else if (action == Action_Topic_Top_Cancel)
    {
        url = [NSString stringWithFormat:FBCIRCLE_TOPIC_TRIPTOP,[SzkAPI getAuthkey],self.fid,self.tid];
    }else if (action == Action_Topic_Info)
    {
        url = [NSString stringWithFormat:FBCIRCLE_TOPIC_INFO,self.tid,1,1];
    }else if (action == Action_Topic_Del)
    {
        url = [NSString stringWithFormat:FBCIRCLE_TOPIC_DELETE,[SzkAPI getAuthkey],self.fid,self.tid];
    }
    
    __weak typeof(UITableView *)weakTable = _table;
    
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        NSLog(@"result %@",result);
        
        //帖子详情
        if (action == Action_Topic_Info) {
            NSDictionary *datainfo = [result objectForKey:@"datainfo"];
            if ([datainfo isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *thread = [datainfo objectForKey:@"thread"];
                if ([thread isKindOfClass:[NSDictionary class]]) {
                    
                    NSLog(@"topic info %@",thread);
                    
                    aTopicModel = [[TopicModel alloc]initWithDictionary:thread];
                    
                    weakTable.tableHeaderView = [self createTableHeaderView];
                    weakTable.tableFooterView = [self createTableFooterView];
                }
            }
        }else
        {
            if ([result isKindOfClass:[NSDictionary class]]) {
                
                [LTools showMBProgressWithText:[result objectForKey:@"errinfo"] addToView:self.view];
                
            }
        }
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        NSLog(@"fail result %@",failDic);
        [LTools showMBProgressWithText:[failDic objectForKey:@"ERRO_INFO"] addToView:self.view];
    }];
}


/**
 *  评论列表
 */
- (void)getCommentList
{
    __weak typeof(UITableView *)weakTable = _table;
    NSString *url = [NSString stringWithFormat:FBCIRCLE_COMMENT_LIST,self.tid,_pageNum,L_PAGE_SIZE];
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        NSLog(@"result %@",result);
        NSDictionary *dataInfo = [result objectForKey:@"datainfo"];
        if ([dataInfo isKindOfClass:[NSDictionary class]]) {
            NSArray *data = [dataInfo objectForKey:@"data"];
            for (NSDictionary *aDic in data) {
                
                TopicCommentModel *aModel = [[TopicCommentModel alloc]initWithDictionary:aDic];
                aModel.content = [aModel.content stringByReplacingEmojiCheatCodesWithUnicode];
                [_dataArray addObject:aModel];
            }
            [weakTable reloadData];
            
            int total = [[dataInfo objectForKey:@"total"]integerValue];
            if (total > _pageNum) {
                
            }else
            {
                [moreBtn setTitle:@"没有更多评论" forState:UIControlStateNormal];
                moreBtn.userInteractionEnabled = NO;
            }
        }
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        NSLog(@"failDic result %@",failDic);
        [LTools showMBProgressWithText:[failDic objectForKey:@"ERRO_INFO"] addToView:self.view];
        int erroCode = [[failDic objectForKey:@"errcode"]integerValue];
        if (erroCode == 2) {
            [moreBtn setTitle:@"没有更多评论" forState:UIControlStateNormal];
            moreBtn.userInteractionEnabled = NO;
        }
    }];
}

- (void)getBBSInfoId:(NSString *)bbsId
{
    __weak typeof(self)weakSelf = self;
    __weak typeof(UITableView *)weakTable = _table;
    
    NSString *url = [NSString stringWithFormat:FBCIRCLE_BBS_INFO,bbsId];
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        NSLog(@"result %@",result);
        NSDictionary *dataInfo = [result objectForKey:@"datainfo"];
        
        if ([dataInfo isKindOfClass:[NSDictionary class]]) {
            
            BBSInfoModel *aBBSModel = [[BBSInfoModel alloc]initWithDictionary:dataInfo];
            
            weakTable.tableHeaderView = [weakSelf createTableHeaderView];
            
            weakSelf.titleLabel.text = aBBSModel.name;
            
        }
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        NSLog(@"result %@",failDic);
        
        [LTools showMBProgressWithText:[failDic objectForKey:@"ERRO_INFO"] addToView:self.view];
        
    }];
}

#pragma mark - 视图创建
- (CGFloat)createRichLabelWithMessage:(NSString *)text isInsert:(BOOL)isInsert
{
    OHAttributedLabel *label = [[OHAttributedLabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor orangeColor];
    label.lineBreakMode = NSLineBreakByCharWrapping;
    [FBHelper creatAttributedText:text Label:label OHDelegate:self];
    
    NSNumber *heightNum = [[NSNumber alloc] initWithFloat:label.frame.size.height];
    
    if (isInsert) {
        [labelArr insertObject:label atIndex:0];
    }else
    {
        [labelArr addObject:label];
    }
    
    if (isInsert) {
        [rowHeights insertObject:heightNum atIndex:0];
    }else
    {
        [rowHeights addObject:heightNum];
        
    }
    
    return [heightNum floatValue];
}

- (void)createInputView
{
    __weak typeof(self) weakSelf = self;
    inputView = [[LInputView alloc]initWithFrame:CGRectMake(0, self.view.height - 45 - 20 - 44, 320, 45)inView:self.view inputText:^(NSString *inputText) {

        NSLog(@"inputText %@",inputText);
        
        if (inputText.length > 0) {
            
            [weakSelf addComment:inputText];
            
        }
        
    }];
    inputView.clearInputWhenSend = NO;;
    inputView.resignFirstResponderWhenSend = YES;
    
    [self.view addSubview:inputView];
}

/**
 *  论坛基本信息部分
 */
- (UIView *)createBBSInfoViewFrame:(CGRect)aFrame
{
    UIView *basic_view = [[UIView alloc]initWithFrame:aFrame];
    basic_view.layer.cornerRadius = 3.f;
    
    //论坛name
    UILabel *nameLabel = [LTools createLabelFrame:CGRectMake(10, 0, 150, 40) title:@"汽车联赛" font:14 align:NSTextAlignmentLeft textColor:[UIColor blackColor]];
    [basic_view addSubview:nameLabel];
    
    //帖子数
    UILabel *numLabel = [LTools createLabelFrame:CGRectMake(nameLabel.right, 0, aFrame.size.width - nameLabel.width - 10 * 2, 40) title:@"5678帖子" font:13 align:NSTextAlignmentRight textColor:[UIColor colorWithHexString:@"90a1cd"]];
    [basic_view addSubview:numLabel];
    
    //精 帖

    LButtonView *btnV = [[LButtonView alloc]initWithFrame:CGRectMake(0, 40, aFrame.size.width, 40) leftImage:[UIImage imageNamed:@"jing"] rightImage:[UIImage imageNamed:@"jiantou_down"] title:aTopicModel.title target:self action:@selector(clickToRecommend:) lineDirection:Line_Up];
    [basic_view addSubview:btnV];
    
    
    basic_view.backgroundColor = [UIColor whiteColor];
    aFrame.size.height = 40 + 40;
    basic_view.frame = aFrame;
    return basic_view;
}

/**
 *  置顶帖子部分
 */
- (UIView *)createRecommendViewFrame:(CGRect)aFrame
{
    
    UIView *recommed_view = [[UIView alloc]init];
    recommed_view.backgroundColor = [UIColor whiteColor];
    recommed_view.layer.cornerRadius = 3.f;
    recommed_view.clipsToBounds = YES;
    
    //头像
    UIImageView *headImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 40, 40)];
    [headImage sd_setImageWithURL:[NSURL URLWithString:@"<#string#>"] placeholderImage:[UIImage imageNamed:@"Picture_default_image"]];
    [recommed_view addSubview:headImage];
    
    //楼主
    NSString *name = aTopicModel.username;
    
    UILabel *nameLabel = [LTools createLabelFrame:CGRectMake(headImage.right + 10, headImage.top, [LTools widthForText:name font:14], 15) title:name font:14 align:NSTextAlignmentLeft textColor:[UIColor blackColor]];
    [recommed_view addSubview:nameLabel];
    
    UIButton *hintBtn = [LTools createButtonWithType:UIButtonTypeCustom frame:CGRectMake(nameLabel.right + 5, headImage.top, 35, 15) normalTitle:@"楼主" backgroudImage:nil superView:recommed_view target:nil action:nil];
    hintBtn.backgroundColor = [UIColor colorWithHexString:@"5c7bbe"];
    hintBtn.layer.cornerRadius = 3.f;
    [hintBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    
    //时间
    NSString *time = [LTools timechange:aTopicModel.time];
    UILabel *timeLabel = [LTools createLabelFrame:CGRectMake(aFrame.size.width - 10 - [LTools widthForText:time font:12], nameLabel.top, [LTools widthForText:time font:12], nameLabel.height) title:time font:12 align:NSTextAlignmentRight textColor:[UIColor lightGrayColor]];
    [recommed_view addSubview:timeLabel];
    
    //正文
    
    NSString *text = aTopicModel.content;
    UILabel *textLabel = [LTools createLabelFrame:CGRectMake(nameLabel.left, nameLabel.bottom + 2, aFrame.size.width - headImage.right - 20, [LTools heightForText:text width:aFrame.size.width - headImage.right - 20 font:12]) title:text font:12 align:NSTextAlignmentLeft textColor:[UIColor blackColor]];
    textLabel.numberOfLines = 0;
    [recommed_view addSubview:textLabel];
    
    //图片
    
    NSArray *imageUrls = aTopicModel.img;
    
    __weak typeof(self)weakSelf = self;
    
    LNineImagesView *nineView = [[LNineImagesView alloc]initWithFrame:CGRectMake(textLabel.left, textLabel.bottom + 5, textLabel.width, 0) images:imageUrls imageIndex:^(int index) {
        NSLog(@"slectIndex %d",index);
        
        ShowImagesViewController *showBigVC=[[ShowImagesViewController alloc]init];
        showBigVC.allImagesUrlArray= [NSMutableArray arrayWithArray:imageUrls];
        showBigVC.currentPage = index ;
        [weakSelf PushToViewController:showBigVC WithAnimation:YES];
    }];
    [recommed_view addSubview:nineView];
    
    //赞
    
    UIView *zan_view = [[UIView alloc]initWithFrame:CGRectMake(-1, nineView.bottom + 10, aFrame.size.width + 2, 40)];
    zan_view.backgroundColor = [UIColor whiteColor];
    zan_view.layer.borderWidth = 1.f;
    zan_view.layer.borderColor = [UIColor colorWithHexString:@"f0f0f0"].CGColor;
    zan_view.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
    [recommed_view addSubview:zan_view];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickTOPraiseMember:)];
    [zan_view addGestureRecognizer:tap];
    
    UIImageView *zanImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, (40 - 16)/2.0, 16, 16)];
    zanImage.image = [UIImage imageNamed:@"zhiding"];
    [zan_view addSubview:zanImage];
    
    NSString *numberSter = [NSString stringWithFormat:@"%@",aTopicModel.zan_num];
    UILabel *zan_num_label = [LTools createLabelFrame:CGRectMake(zanImage.right + 5, 0, [LTools widthForText:numberSter font:12], zan_view.height) title:numberSter font:12 align:NSTextAlignmentLeft textColor:[UIColor colorWithHexString:@"7083ad"]];
    [zan_view addSubview:zan_num_label];
    
    NSString *names = @"越野小豆、胡桃、小猴玩、猴子请来的逗比、卡卡拉卡拉";
    UILabel *zan_names_label = [LTools createLabelFrame:CGRectMake(zan_num_label.right + 5, 0, 240, zan_view.height) title:names font:12 align:NSTextAlignmentLeft textColor:[UIColor colorWithHexString:@"7083ad"]];
    [zan_view addSubview:zan_names_label];
    
    //时间
    UIView *time_view = [[UIView alloc]initWithFrame:CGRectMake(-1, zan_view.bottom, aFrame.size.width + 2, 40)];
    time_view.backgroundColor = [UIColor whiteColor];
    time_view.layer.borderWidth = 0.5f;
    time_view.layer.borderColor = [UIColor colorWithHexString:@"f0f0f0"].CGColor;
    [recommed_view addSubview:time_view];
    
    NSString *time_str = [LTools timestamp:aTopicModel.time];
    UILabel *time_Label = [LTools createLabelFrame:CGRectMake(10, 0, 100, time_view.height) title:time_str font:14 align:NSTextAlignmentLeft textColor:[UIColor blackColor]];
    [time_view addSubview:time_Label];
    
    UIButton *zan_btn = [LTools createButtonWithType:UIButtonTypeCustom frame:CGRectMake(time_view.width - 10 - 30, 5, 30, 30) normalTitle:@"赞" backgroudImage:nil superView:time_view target:self action:@selector(clickToZan:)];
    [zan_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    aFrame.size.height = time_view.bottom;
    recommed_view.frame = aFrame;
    
    
    return recommed_view;
}

/**
 *  创建tableView的 headerView
 */
- (UIView *)createTableHeaderView
{
    UIView *headerView = [[UIView alloc]init];
    headerView.backgroundColor = [UIColor clearColor];
    //基本信息部分
    
    UIView *basic_view = [self createBBSInfoViewFrame:CGRectMake(8, 15, 304, 0)];
    [headerView addSubview:basic_view];
    
    UIView *recommed_view = [self createRecommendViewFrame:CGRectMake(8, basic_view.bottom + 15, 304, 0)];
    [headerView addSubview:recommed_view];
    
    headerView.frame = CGRectMake(0, 0, 320, basic_view.height + recommed_view.height + 15 + 15 +1);
    
    UIView *hh_view = [[UIView alloc]initWithFrame:CGRectMake(8, headerView.height - 10, 304, 10)];
    hh_view.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:hh_view];
    
    
    UIView *line_view = [[UIView alloc]initWithFrame:CGRectMake(8, headerView.height - 1, 304, 1)];
    line_view.backgroundColor = [UIColor colorWithHexString:@"f0f0f0"];
    [headerView addSubview:line_view];

    
    return headerView;
}

- (UIView *)createTableFooterView
{
    UIView *footer_view = [[UIView alloc]initWithFrame:CGRectMake(8, 0, 304, 45 + 15)];
    footer_view.backgroundColor = [UIColor clearColor];
    
    UIView *bg_view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 304, 45)];
    bg_view.backgroundColor = [UIColor whiteColor];
    bg_view.layer.cornerRadius = 3.f;
    [footer_view addSubview:bg_view];
    
    UIView *hh_view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 304, 10)];
    hh_view.backgroundColor = [UIColor whiteColor];
    [footer_view addSubview:hh_view];
    
    UIView *line_view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 304, 1)];
    line_view.backgroundColor = [UIColor colorWithHexString:@"f0f0f0"];
    [footer_view addSubview:line_view];

    
    
    moreBtn = [LTools createButtonWithType:UIButtonTypeCustom frame:CGRectMake(10, 0, 150, footer_view.height - 15) normalTitle:@"查看更多评论..." backgroudImage:nil superView:footer_view target:self action:@selector(clickToMore:)];
    [moreBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    moreBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    moreBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    return footer_view;
}


#pragma mark - delegate

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TopicCommentModel *aModel = [_dataArray objectAtIndex:indexPath.row];
    NSString *text = aModel.content;
    CGFloat labelHeight = 0.0;
    if (rowHeights.count > indexPath.row && [rowHeights objectAtIndex:indexPath.row]) {
        
        labelHeight = [[rowHeights objectAtIndex:indexPath.row] floatValue];
        
    }else
    {
        labelHeight = [self createRichLabelWithMessage:text isInsert:NO];
    }
    
    
    CGFloat aHeight = 30 + labelHeight + 10;
    
    if (aHeight <= 75) {
        aHeight = 75;
    }
    return aHeight;
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath NS_AVAILABLE_IOS(6_0)
{
    BBSRecommendCell *aCell =(BBSRecommendCell *)cell;
    if (aCell.content_label) {
        [aCell.content_label removeFromSuperview];//防止重绘
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier3 = @"BBSRecommendCell";
    
    BBSRecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier3];
    if (cell == nil) {
        cell = [[BBSRecommendCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier3];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    TopicCommentModel *aModel = [_dataArray objectAtIndex:indexPath.row];
    NSString *text = aModel.content;
    
    if (labelArr.count > indexPath.row && [labelArr objectAtIndex:indexPath.row]) {
        
    }else
    {
        //否则没有,需要新创建
        [self createRichLabelWithMessage:text isInsert:NO];
        
    }
    
    UIView *label = (UIView *)[labelArr objectAtIndex:indexPath.row];
    
    [cell setCellData:text OHLabel:label];
    
    if ([aModel.userface isKindOfClass:[UIImage class]]) {
        cell.aImageView.image = (UIImage *)aModel.userface;
    }else
    {
       [cell.aImageView sd_setImageWithURL:[NSURL URLWithString:aModel.userface] placeholderImage:[UIImage imageNamed:@"Picture_default_image"]];
    }
    
    cell.nameLabel.text = aModel.username;
    cell.timeLabel.text = [LTools timechange:aModel.time];
    
    return cell;
    
}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    return footer_view;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 45;
//}

@end

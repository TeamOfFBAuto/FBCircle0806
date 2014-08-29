//
//  GpersonInfoViewController.m
//  FBCircle
//
//  Created by gaomeng on 14-8-14.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//


#import "GpersonInfoViewController.h"

#import "GMAPI.h"

@interface GpersonInfoViewController ()

@end

@implementation GpersonInfoViewController

- (void)dealloc
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.titleLabel.text = @"详细信息";
    
    
    //请求网络数据
    [self prepareNetData];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)btnClicked:(UIButton *)sender{
    NSLog(@"%d",sender.tag);
}



#pragma mark - 加载控件
-(void)loadCustomView{
    
    //头像 名字 的背景view==========================================================
    UIView *nameView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 66)];
    [self.view addSubview:nameView];
    //    nameView.backgroundColor = [UIColor orangeColor];
    
    //头像
    self.userFaceImv = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 46, 46)];
    [self.userFaceImv sd_setImageWithURL:[NSURL URLWithString:self.personModel.person_face]];
    [nameView addSubview:self.userFaceImv];
    
    //姓名
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.userFaceImv.frame)+10, CGRectGetMinY(self.userFaceImv.frame)+13, 200, 16)];
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.font = [UIFont systemFontOfSize:15];
    nameLabel.text = self.personModel.person_username;
    [nameView addSubview:nameLabel];
    
    //分割线
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 66, 320, 0.5)];
    line.backgroundColor = RGBCOLOR(230, 229, 234);
    [nameView addSubview:line];
    
    
    
    //信息view======================================================
    UIView *infoView = [[UIView alloc]initWithFrame:CGRectMake(16, CGRectGetMaxY(nameView.frame)+21, 320-16-16, 184)];
    infoView.layer.borderWidth = 0.5;
    infoView.layer.borderColor = [RGBCOLOR(229, 230, 232)CGColor];
    infoView.layer.cornerRadius = 5;
    [self.view addSubview:infoView];
    
    //标题titleLabel
    
    NSArray *tLabelArray = @[@"地区",@"个性签名",@"个人相册"];
    
    
    for (int i = 0; i<3; i++) {
        
        UILabel *tLabel = [[UILabel alloc]init];
        
        if (i == 0) {//地区
            tLabel.frame = CGRectMake(12, 18, 50, 13);
            self.userAreaLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(tLabel.frame)+14, tLabel.frame.origin.y, 205, 13)];
            NSString *diqu = [self.personModel.person_province stringByAppendingString:self.personModel.person_city];
            self.userAreaLabel.text = [GMAPI exchangeStringForDeleteNULLWithWeiTianXie:diqu];
            self.userAreaLabel.font = [UIFont boldSystemFontOfSize:12];
            self.userAreaLabel.textColor = RGBCOLOR(143, 143, 143);
            [infoView addSubview:self.userAreaLabel];
            
            //分割线
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(tLabel.frame)+19, infoView.frame.size.width, 0.5)];
            line.backgroundColor = RGBCOLOR(229, 230, 232);
            [infoView addSubview:line];
            
        }else if (i == 1){//个性签名
            tLabel.frame = CGRectMake(12, 18+13+37, 50, 13);
            self.gexingqianmingLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(tLabel.frame)+14, tLabel.frame.origin.y, 205, 13)];
            self.gexingqianmingLabel.font = [UIFont boldSystemFontOfSize:12];
            self.gexingqianmingLabel.textColor = RGBCOLOR(143, 143, 143);
            self.gexingqianmingLabel.text = [GMAPI exchangeStringForDeleteNULLWithWeiTianXie:self.personModel.person_words];
            [infoView addSubview:self.gexingqianmingLabel];
            
            
            //分割线
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(tLabel.frame)+19, infoView.frame.size.width, 0.5)];
            line.backgroundColor = RGBCOLOR(229, 230, 232);
            [infoView addSubview:line];
            
        }else if (i == 2){//个人相册
            tLabel.frame = CGRectMake(12, 18+13+37+13+52, 50, 13);
        }
        tLabel.textColor = [UIColor blackColor];
        tLabel.font = [UIFont boldSystemFontOfSize:12];
        tLabel.text = tLabelArray[i];
        [infoView addSubview:tLabel];
    }
    
    
    //展示图片的view
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(62+14, 112, 182, 56)];
    
    //足迹展示图片的数组
    NSMutableArray *imavMutableArray = [NSMutableArray arrayWithCapacity:1];
    
    //文章对象
    FBCircleModel *wenzhang = [[FBCircleModel alloc]init];
    
    NSLog(@"%d",self.wenzhangArray.count);
    
    int count = self.wenzhangArray.count;
    
    //解决wenzhangArray.count等于0崩溃问题
    for (int i =0; i<count; i++) {
        //获得文章对象
        wenzhang = self.wenzhangArray[i];
        
        //获取文章对象中图片的数组
        NSMutableArray *imageArr =wenzhang.fb_image;
        
        //初始化一个dic 里面存图片地址
        NSDictionary*dic = [[NSDictionary alloc]init];
        
        NSLog(@"wenzhang.fb_image.count = %d",imageArr.count);
        
        
        if (imageArr.count>0) {//图片数组里有东西
            //取出第一张图片
            dic = imageArr[0];
            self.imaCount++;
            
            NSLog(@"_imaCount = %d",self.imaCount);
            
            NSString *str = [dic objectForKey:@"link"];
            
            NSLog(@"图片地址%@",str);
            
            //创建展示图片iamge
            UIImageView *imv = [[UIImageView alloc]init];
            
            @try {
                [imv setImageWithURL:[NSURL URLWithString:str] placeholderImage:nil];
            }
            @catch (NSException *exception) {
                
            }
            @finally {
                
            }
            
            
            
            //imv.backgroundColor = [UIColor purpleColor];
            
            //把需要展示的图片view放到数组中
            [imavMutableArray addObject:imv];
            
        }
        
        if (self.imaCount == 3) {
            break;//图片数量等于3的时候跳出循环 最多展示3张图片 break跳出for循环走下面的遍历数组 return 直接跳到最后
        }
        
        
    }
    
    //遍历数组 倒着放图片
//    for (int i = 0; i<self.imaCount; i++) {
//        UIImageView *imv = imavMutableArray[self.imaCount-i-1];
//        imv.frame = CGRectMake(200-(i+1)*63-10, 0, 56, 56);
//        [view addSubview:imv];
//    }
    
    [infoView addSubview:view];
    
    
    //箭头
    UIImageView *jiantouImv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"jiantou.png"]];
    jiantouImv.frame = CGRectMake(CGRectGetMaxX(view.frame)+15, CGRectGetMinY(view.frame)+23, 8, 13);
    [infoView addSubview:jiantouImv];
    
    
    
    
    
    //发消息或加好友view==========================================
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(infoView.frame.origin.x, CGRectGetMaxY(infoView.frame)+20, infoView.frame.size.width, 41);
    btn.layer.borderWidth = 0.5;
    btn.layer.borderColor = [RGBCOLOR(35, 153, 36)CGColor];
    btn.layer.cornerRadius = 5;
    self.isFriend = YES;
    if (self.isFriend) {
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [btn setTitle:@"发消息" forState:UIControlStateNormal];
        [btn setBackgroundColor:RGBCOLOR(36, 192, 38)];
        btn.tag = 10;
        
    }else{
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [btn setTitle:@"添加到通讯录" forState:UIControlStateNormal];
        [btn setBackgroundColor:RGBCOLOR(36, 192, 38)];
        btn.tag = 11;
    }
    
    [btn addTarget:self action:@selector(bttnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn];
}



-(void)bttnClick:(UIButton*)sender{
    if (sender.tag == 10) {
        
    }else if (sender.tag == 11){
        
    }
}



#pragma mark - 请求网络数据
-(void)prepareNetData{
    
    @try {
        __weak typeof(self) bself = self;
        
        
        //请求用户信息
        self.personModel = [[FBCirclePersonalModel alloc]init];
        
        [self.personModel loadPersonWithUid:self.passUserid WithBlock:^(FBCirclePersonalModel *model) {
            bself.personModel = model;
            bself.userName = model.person_username;
            NSLog(@"%@",model.person_gender);
            
            for (UIView *view in self.view.subviews) {
                [view removeFromSuperview];
            }
            [bself loadCustomView];
           
        } WithFailedBlcok:^(NSString *string) {
            
        }];
        
        //请求文章数据
        FBCircleModel *fbModel = [[FBCircleModel alloc]init];
        [fbModel initHttpRequestWithUid:self.passUserid Page:1 WithType:2 WithCompletionBlock:^( NSMutableArray *array) {
            bself.wenzhangArray = array;
            for (UIView *view in self.view.subviews) {
                [view removeFromSuperview];
            }
            
            [bself loadCustomView];
            
        } WithFailedBlock:^(NSString *operation) {
            
        }];
    }
    @catch (NSException *exception) {
        
        UIAlertView *alertV=[[UIAlertView alloc]initWithTitle:@"提示" message:@"网络异常" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertV show];
    }
    @finally {
        
    }
    
    
    
    
}

@end

//
//  GnearbyPersonCell.m
//  FBCircle
//
//  Created by gaomeng on 14-8-18.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "GnearbyPersonCell.h"

@implementation GnearbyPersonCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



//加载自定义cell
-(void)loadCustomViewWithIndexPath:(NSIndexPath*)theIndexPath{
    //头像
    self.userFaceImv = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 46, 46)];
    self.userFaceImv.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:self.userFaceImv];
    //姓名
    self.userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.userFaceImv.frame)+11, 12, 191, 17)];
    self.userNameLabel.backgroundColor = [UIColor orangeColor];
    [self.contentView addSubview:self.userNameLabel];
    //距离和时间
    self.userDistanceAndTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.userNameLabel.frame.origin.x, CGRectGetMaxY(self.userNameLabel.frame)+11, 191, 12)];
    self.userDistanceAndTimeLabel.backgroundColor = [UIColor purpleColor];
    [self.contentView addSubview:self.userDistanceAndTimeLabel];
    //按钮
    self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn.backgroundColor = RGBCOLOR(30, 186, 34);
    self.btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btn setTitle:@"发消息" forState:UIControlStateNormal];
    self.btn.layer.cornerRadius = 4;
    self.btn.frame = CGRectMake(CGRectGetMaxX(self.userNameLabel.frame), 17, 51, 29);
    [self.contentView addSubview:self.btn];
    [self.btn addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
    
}

//填充数据
-(void)configNetDataWithIndexPath:(NSIndexPath*)theIndexPath dataArray:(NSArray*)array{
    NSLog(@"%s",__FUNCTION__);
    
    NSLog(@"dddd");
}



-(void)sendMessage{
    if (self.sendMessageBlock) {
        self.sendMessageBlock();
    }
}

//block set方法
-(void)setSendMessageBlock:(sendMessageBlock)sendMessageBlock{
    _sendMessageBlock = sendMessageBlock;
}


@end

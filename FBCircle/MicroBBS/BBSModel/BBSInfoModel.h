//
//  BBSInfoModel.h
//  FBCircle
//
//  Created by lichaowei on 14-8-12.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "BaseModel.h"
/**
 *  论坛基本信息
 */
@interface BBSInfoModel : BaseModel

@property(nonatomic,retain)NSString *id;//论坛分类id
@property(nonatomic,retain)NSString *uid;//创建人
@property(nonatomic,retain)NSString *username;//创建人名
@property(nonatomic,retain)NSString *name;//论坛名字
@property(nonatomic,retain)NSString *headpic;//图标
@property(nonatomic,retain)NSString *intro;//简介
@property(nonatomic,retain)NSString *forumclass;//论坛分类id
@property(nonatomic,retain)NSString *newthread_num;//新帖子数
@property(nonatomic,retain)NSString *newthread_date;//新帖日期
@property(nonatomic,retain)NSString *thread_num;//论坛帖子数
@property(nonatomic,retain)NSString *member_num;//论坛成员数
@property(nonatomic,retain)NSString *status;//论坛状态（0:正常   1:删除    2:审核中）
@property(nonatomic,retain)NSString *uptime;//更新时间
@property(nonatomic,retain)NSString *dateline;//创建时间

@end

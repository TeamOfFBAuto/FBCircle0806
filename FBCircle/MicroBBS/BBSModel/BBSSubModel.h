//
//  BBSSubModel.h
//  FBCircle
//
//  Created by lichaowei on 14-8-6.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

/**
 *  论坛
 */
@interface BBSSubModel : BaseModel
@property(nonatomic,retain)NSString *id;
@property(nonatomic,retain)NSString *uid;
@property(nonatomic,retain)NSString *username;
@property(nonatomic,retain)NSString *name;
@property(nonatomic,retain)NSString *intro;
@property(nonatomic,retain)NSString *headpic;
@property(nonatomic,retain)NSString *forumclass;
@property(nonatomic,retain)NSString *newthread_num;
@property(nonatomic,retain)NSString *newthread_date;
@property(nonatomic,retain)NSString *thread_num;
@property(nonatomic,retain)NSString *member_num;
@property(nonatomic,retain)NSString *status;
@property(nonatomic,retain)NSString *uptime;
@property(nonatomic,retain)NSString *dateline;
@property(nonatomic,assign)int inForum;

/*
errcode:>0 时返回错误结果
errinfo:errcode>0 时返回错误描述
datainfo:    
 total:总页数    
 data:{id:论坛id    uid:创建者用户id    username:创建者用户名    name:论坛名称
intro:论坛简介    headpic:论坛头像    forumclass:论坛分类id    newthread_num:今日新帖数量
newthread_date:今日新帖时间标志    thread_num:论坛帖子数    member_num:论坛成员数   
 status:论坛状态（0:正常   1:删除    2:审核中）
    uptime:更新时间    dateline:创建时间    inForm:是否在此论坛中
 }
 */

@end

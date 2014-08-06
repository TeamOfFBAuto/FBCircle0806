//
//  BBSSubModel.h
//  FBCircle
//
//  Created by lichaowei on 14-8-6.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
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

@end

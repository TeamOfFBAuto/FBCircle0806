//
//  BBSModel.h
//  FBCircle
//
//  Created by lichaowei on 14-8-6.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBSModel : NSObject
@property(nonatomic,retain)NSString *id;
@property(nonatomic,retain)NSString *classname;
@property(nonatomic,retain)NSString *classpic;

-(id)initWithDictionary:(NSDictionary *)dic;

@end

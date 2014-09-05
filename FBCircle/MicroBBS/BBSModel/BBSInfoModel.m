//
//  BBSInfoModel.m
//  FBCircle
//
//  Created by lichaowei on 14-8-12.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "BBSInfoModel.h"

@implementation BBSInfoModel

-(id)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        
        if ([dic isKindOfClass:[NSDictionary class]]) {
            [self setValuesForKeysWithDictionary:dic];
            
            if (self.name) {
                self.name = [ZSNApi decodeFromPercentEscapeString:self.name];
            }
            if (self.intro) {
                self.intro = [ZSNApi decodeFromPercentEscapeString:self.intro];
            }
            
        }
    }
    return self;
}

@end

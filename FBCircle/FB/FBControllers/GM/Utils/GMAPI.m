//
//  GMAPI.m
//  FBCircle
//
//  Created by gaomeng on 14-8-25.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "GMAPI.h"

@implementation GMAPI
+(NSString *)exchangeStringForDeleteNULL:(id)sender
{
    NSString * temp = [NSString stringWithFormat:@"%@",sender];
    
    if (temp.length == 0 || [temp isEqualToString:@"<null>"] || [temp isEqualToString:@"null"] || [temp isEqualToString:@"(null)"])
    {
        temp = @"暂无";
    }
    
    return temp;
}
@end

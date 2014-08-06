//
//  SendPostsImageScrollView.h
//  FBCircle
//
//  Created by soulnear on 14-8-6.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendPostsImageScrollView : UIScrollView
{
    
}

@property(nonatomic,weak)NSMutableArray * data_array;

///图片类，显示选择的图片
-(void)loadAllViewsWith:(NSMutableArray *)array;




@end

//
//  SendPostsViewController.h
//  FBCircle
//
//  Created by soulnear on 14-8-5.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QBImagePickerController.h"



@interface SendPostsViewController : MyViewController<UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,QBImagePickerControllerDelegate>
{
    
}


@property(nonatomic,strong)UITextView * title_textView;

@property(nonatomic,strong)UITextView * content_textView;
///论坛id
@property(nonatomic,strong)NSString * fid;



@end

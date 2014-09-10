//
//  ZSNApi.h
//  FBCircle
//
//  Created by soulnear on 14-5-14.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "NSString+Emoji.h"
#import "MBProgressHUD.h"

#define PERSONAL_DEFAULTS_IMAGE [UIImage imageNamed:@"gtouxiangHolderImage.png"]



@interface ZSNApi : NSObject

+(UIImage *)getImageWithName:(NSString *)name;

+(NSArray *)exChangeFriendListByOrder:(NSMutableArray *)theArray;

///裁剪图片
+(UIImage *)scaleToSizeWithImage:(UIImage *)img size:(CGSize)size;
///按比例缩放图片
+(UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize;


+(NSString *)returnUrl:(NSString *)theUrl;
+(NSString *)returnMiddleUrl:(NSString *)theUrl;

+(NSString *)timechange:(NSString *)placetime;

+(NSString *)timechangeByAll:(NSString *)placetime;

+(NSString *)timechange1:(NSString *)placetime;

+(NSString *)timechangeToDateline;

+(NSArray *)stringExchange:(NSString *)string;

+(float)calculateheight:(NSArray *)array;

+(CGPoint)LinesWidth:(NSString *)string Label:(UILabel *)label font:(UIFont *)thefont;

+ (float)theHeight:(NSString *)content withHeight:(CGFloat)theheight WidthFont:(UIFont *)font;

+(NSString*)timestamp:(NSString*)myTime;

+(UIViewAnimationOptions)animationOptionsForCurve:(UIViewAnimationCurve)curve;


+ (NSString*)FBImageChange:(NSString*)imgSrc;

+ (NSString*)FBEximgreplace:(NSString*)imgSrc;


///删除asyncimage某个缓存图片
+(void)deleteFileWithUrl:(NSString *)path;

//保存图片到沙盒

+(void)saveImageToDocWith:(NSString *)path WithImage:(UIImage *)image;
//删除沙盒文件

+(void)deleteDocFileWith:(NSMutableArray *)fileNames;

//保存图片沙盒地址

+(NSString *)docImagePath;
///弹出提示框
+ (MBProgressHUD *)showMBProgressWithText:(NSString *)text addToView:(UIView *)aView;
///弹出框，1.5秒后自动消失
+ (void)showAutoHiddenMBProgressWithText:(NSString *)text addToView:(UIView *)aView;

///字符串编码
+(NSString *)encodeToPercentEscapeString: (NSString *) input;
///字符串解码
+(NSString *)decodeFromPercentEscapeString: (NSString *) input;

///解码特殊字符
+(NSString *)decodeSpecialCharactersString:(NSString *)input;
@end








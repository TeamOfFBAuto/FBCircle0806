//
//  LCWTools.h
//  FBAuto
//
//  Created by lichaowei on 14-7-9.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RefreshTableView.h"
#import "MBProgressHUD.h"
#import "UIColor+ConvertColor.h"
#import "UIView+Frame.h"
#import "UIImageView+WebCache.h"
#import "LButtonView.h"
#import "LNineImagesView.h"
#import "LInputView.h"
#import "LActionSheet.h"
#import "LSearchView.h"
#import "LMoveView.h"
#import "FBHelper.h"
#import "NSString+Emoji.h"

#define L_PAGE_SIZE 10 //每页条数
#define ERROR_INFO @"ERRO_INFO" //错误信息

typedef void(^ urlRequestBlock)(NSDictionary *result,NSError *erro);

@interface LTools : NSObject<NSURLConnectionDelegate,NSURLConnectionDataDelegate>
{
    urlRequestBlock successBlock;
    urlRequestBlock failBlock;
    NSString *requestUrl;
    NSData *requestData;
    BOOL isPostRequest;//是否是post请求
    
    NSURLConnection *connection;
}

+ (id)shareInstance;

/**
 *  网络请求
 */
- (id)initWithUrl:(NSString *)url isPost:(BOOL)isPost postData:(NSData *)postData;//初始化请求

- (void)requestCompletion:(void(^)(NSDictionary *result,NSError *erro))completionBlock failBlock:(void(^)(NSDictionary *failDic,NSError *erro))failedBlock;//处理请求结果

- (void)cancelRequest;

/**
 *  NSUserDefault 缓存
 */
//存
+ (void)cache:(id)dataInfo ForKey:(NSString *)key;
//取
+ (id)cacheForKey:(NSString *)key;

#pragma mark - 常用视图快速创建

+ (UIButton *)createButtonWithType:(UIButtonType)buttonType
                             frame:(CGRect)aFrame
                       normalTitle:(NSString *)normalTitle
                             image:(UIImage *)normalImage
                    backgroudImage:(UIImage *)bgImage
                         superView:(UIView *)superView
                            target:(id)target
                            action:(SEL)action;

+ (UILabel *)createLabelFrame:(CGRect)aFrame
                        title:(NSString *)title
                         font:(CGFloat)size
                        align:(NSTextAlignment)align
                    textColor:(UIColor *)textColor;

#pragma mark - 计算宽度、高度

+ (CGFloat)widthForText:(NSString *)text font:(CGFloat)size;
+ (CGFloat)heightForText:(NSString *)text width:(CGFloat)width font:(CGFloat)size;

#pragma mark - 小工具

+ (NSString *) md5:(NSString *) text;
+ (void)alertText:(NSString *)text;
+(NSString *)timechange:(NSString *)placetime;
+(NSString *)timechange2:(NSString *)placetime;
+(NSString *)timechange3:(NSString *)placetime;

+(NSString *)timechangeToDateline;//转换为时间戳

+(NSString*)timestamp:(NSString*)myTime;//模糊时间,如几天前

+ (NSString *)currentTime;//当前时间 yyyy-mm-dd

+ (void)showMBProgressWithText:(NSString *)text addToView:(UIView *)aView;

+ (NSString *)NSStringNotNull:(NSString *)text;

+ (NSAttributedString *)attributedString:(NSString *)content keyword:(NSString *)aKeyword color:(UIColor *)textColor;

#pragma mark - 验证有效性

/**
 *  验证 邮箱、电话等
 */

+ (BOOL)isValidateInt:(NSString *)digit;
+ (BOOL)isValidateFloat:(NSString *)digit;
+ (BOOL)isValidateEmail:(NSString *)email;
+ (BOOL)isValidateName:(NSString *)userName;
+ (BOOL)isValidatePwd:(NSString *)pwdString;
+ (BOOL)isValidateMobile:(NSString *)mobileNum;

/**
 *  切图
 */
+(UIImage *)scaleToSizeWithImage:(UIImage *)img size:(CGSize)size;


#pragma mark - CoreData管理

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

- (void)insertDataClassType:(NSString *)classType dataArray:(NSMutableArray*)dataArray unique:(NSString *)unique;
//查询
- (NSArray*)queryDataClassType:(NSString *)classType pageSize:(int)pageSize andOffset:(int)currentPage unique:(NSString *)unique;

#pragma mark - 分类论坛图片获取

+ (UIImage *)imageForBBSId:(NSString *)bbsId;

@end

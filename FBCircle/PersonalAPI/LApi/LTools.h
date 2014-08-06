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

#define ERROR_INFO @"ERRO_INFO" //错误信息

typedef void(^ urlRequestBlock)(NSDictionary *result,NSError *erro);

@interface LTools : NSObject<NSURLConnectionDelegate,NSURLConnectionDataDelegate>
{
    urlRequestBlock successBlock;
    urlRequestBlock failBlock;
    NSString *requestUrl;
    NSData *requestData;
    BOOL isPostRequest;//是否是post请求
}

+ (id)shareInstance;

/**
 *  网络请求
 */
- (id)initWithUrl:(NSString *)url isPost:(BOOL)isPost postData:(NSData *)postData;//初始化请求

- (void)requestCompletion:(void(^)(NSDictionary *result,NSError *erro))completionBlock failBlock:(void(^)(NSDictionary *failDic,NSError *erro))failedBlock;//处理请求结果

#pragma mark - 常用视图快速创建

+ (UIButton *)createButtonWithType:(UIButtonType)buttonType
                             frame:(CGRect)aFrame
                       normalTitle:(NSString *)normalTitle
                    backgroudImage:(UIImage *)image
                         superView:(UIView *)superView
                            target:(id)target
                            action:(SEL)action;

#pragma mark - 小工具

+ (NSString *) md5:(NSString *) text;
+ (void)alertText:(NSString *)text;
+(NSString *)timechange:(NSString *)placetime;
+(NSString *)timechange2:(NSString *)placetime;
+(NSString *)timechange3:(NSString *)placetime;

+ (NSString *)currentTime;//当前时间 yyyy-mm-dd

+ (void)showMBProgressWithText:(NSString *)text addToView:(UIView *)aView;

+ (NSString *)NSStringNotNull:(NSString *)text;

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


#pragma mark - CoreData管理

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

- (void)insertDataClassType:(NSString *)classType dataArray:(NSMutableArray*)dataArray unique:(NSString *)unique;
//查询
- (NSArray*)queryDataClassType:(NSString *)classType pageSize:(int)pageSize andOffset:(int)currentPage unique:(NSString *)unique;

@end

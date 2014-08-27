//
//  AppDelegate.h
//  FBCircle
//
//  Created by soulnear on 14-8-4.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBCircleUploadData.h"
#import "BMapKit.h"

//@interface BaiduMapApiDemoAppDelegate : NSObject <UIApplicationDelegate>
//
//@end


@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    BMKMapManager* _mapManager;
}
@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,strong)FBCircleUploadData * uploadData;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;



@end

//
//  AppDelegate.m
//  FBCircle
//越野e族
//  Created by soulnear on 14-8-4.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"//fb圈
#import "MicroBBSViewController.h"//微论坛
#import "MessageViewController.h"//消息
#import "FoundViewController.h"//发现
#import "MineViewController.h"//我

#import "LeftViewController.h"//侧滑到左边的，暂时用不到
#import "RightViewController.h"//侧滑到右边的，暂时用不到
#import "MMDrawerController.h"

#import "MobClick.h"//友盟
#import "WXApi.h"







@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    
    MainViewController * mainVC = [[MainViewController alloc] init];
    
    MicroBBSViewController * microBBSVC = [[MicroBBSViewController alloc] init];
    
    MessageViewController * messageVC = [[MessageViewController alloc] init];
    
    FoundViewController * foundVC = [[FoundViewController alloc] init];
    
    MineViewController * mineVC = [[MineViewController alloc] init];
    
    UINavigationController * navc1 = [[UINavigationController alloc] initWithRootViewController:mainVC];
    
    UINavigationController * navc2 = [[UINavigationController alloc] initWithRootViewController:microBBSVC];
    
    UINavigationController * navc3 = [[UINavigationController alloc] initWithRootViewController:messageVC];
    
    UINavigationController * navc4 = [[UINavigationController alloc] initWithRootViewController:foundVC];
    
    UINavigationController * navc5 = [[UINavigationController alloc] initWithRootViewController:mineVC];
    
    
    navc1.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"FB圈" image:[UIImage imageNamed:@"unselected_fbcircle_image.png"] selectedImage:[UIImage imageNamed:@"selected_fbcircle_image.png"]];
    
    navc2.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"微论坛" image:[UIImage imageNamed:@"unselected_small_bbs_icon.png"] selectedImage:[UIImage imageNamed:@"selected_small_bbs_icon_image.png"]];
    
    navc3.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"消息" image:[UIImage imageNamed:@"unselected_message_icon.png"] selectedImage:[UIImage imageNamed:@"selected_message_icon.png"]];
    
    navc4.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"发现" image:[UIImage imageNamed:@"unselected_found_image.png"] selectedImage:[UIImage imageNamed:@"selected_found_image.png"]];
    
    navc5.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我" image:[UIImage imageNamed:@"unselected_mine_image.png"] selectedImage:[UIImage imageNamed:@"selected_mine_image.png"]];
    
    
    
    UITabBarController * tabbarVC = [[UITabBarController alloc] init];
    
    tabbarVC.viewControllers = [NSArray arrayWithObjects:navc1,navc2,navc3,navc4,navc5,nil];
    
    tabbarVC.selectedIndex = 0;
    
    
    
    
    MMDrawerController *_RootVC=[[MMDrawerController alloc]initWithCenterViewController:tabbarVC leftDrawerViewController:nil rightDrawerViewController:nil];
    
    
    [_RootVC setMaximumRightDrawerWidth:200];
    [_RootVC setMaximumLeftDrawerWidth:320];
    _RootVC.shouldStretchDrawer = NO;
    [_RootVC setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [_RootVC setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    
    [MobClick startWithAppkey:@"5368ab4256240b6925029e29"];
    
    //微信
    [WXApi registerApp:@"wx278bfca281b3cfd1"];
    
    
    self.window.rootViewController = _RootVC;
    
    
    
    
    
    
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"FBCircle" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"FBCircle.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end

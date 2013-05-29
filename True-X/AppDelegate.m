//
//  AppDelegate.m
//  True-X
//
//  Created by Dao Nguyen on 5/10/13.
//  Copyright (c) 2013 Dao Nguyen. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    //self.window.backgroundColor = [UIColor whiteColor];
    //[self.window makeKeyAndVisible];
    //custom tabbar
    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    UITabBar *tabBar = tabBarController.tabBar;
    UITabBarItem *tabBarItem1 = [tabBar.items objectAtIndex:0];
    UITabBarItem *tabBarItem2 = [tabBar.items objectAtIndex:1];
    UITabBarItem *tabBarItem3 = [tabBar.items objectAtIndex:2];

    [tabBarItem1 setFinishedSelectedImage:[UIImage imageNamed:@"tb_baiviet_selected.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"tb_baiviet.png"]];
    [tabBarItem2 setFinishedSelectedImage:[UIImage imageNamed:@"tb_bosuutap_selected.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"tb_bosuutap.png"]];
    [tabBarItem3 setFinishedSelectedImage:[UIImage imageNamed:@"tb_lienhe_selected.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"tb_lienhe.png"]];
    
    [MagicalRecord setupCoreDataStackWithStoreNamed:@"True_X.sqlite"];
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
    [MagicalRecord cleanUp];
}

@end

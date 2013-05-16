//
//  AppDelegate.m
//  TestXMLRPC
//
//  Created by InfoNam on 5/16/13.
//  Copyright (c) 2013 InfoNam. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    [self getOnlineData:self];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (BOOL)getOnlineData: (id<XMLRPCConnectionDelegate>)delegate {
    
//    NSString *catID = [appDelegate.categoryDict valueForKey:@"id"];
    
    NSString *method = @"articles/getCategories/";     // the method
//    NSArray *args = [NSArray arrayWithObjects:catID,nil];  // the param(s)
    
    NSURL *serverURL = [NSURL URLWithString: @"http://true-x.net/service/"];
    
    XMLRPCRequest *request = [[XMLRPCRequest alloc] initWithURL: serverURL];
    XMLRPCConnectionManager *manager = [XMLRPCConnectionManager sharedManager];
    
    [request setMethod:method withParameters:nil];
    
    [manager spawnConnectionWithXMLRPCRequest: request delegate:delegate];
        
    return TRUE;
}

- (void)request: (XMLRPCRequest *)request didReceiveResponse: (XMLRPCResponse *)response {
    
    if ([response isFault]) {
         NSLog(@"Fault code: %@", [response faultCode]);
        
         NSLog(@"Fault string: %@", [response faultString]);
        } else {
             NSLog(@"Parsed response: %@", [response object]);
//             NSMutableDictionary *dataDict = [[response object] retain];
//             AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//             appDelegate.dataDict = dataDict;
//             [myDelegate didReceiveResponse: dataDict];
            }
    NSLog(@"Response body: %@", [response body]);
}

- (void)request: (XMLRPCRequest *)request didFailWithError: (NSError *)error
{
    
    NSEnumerator *enumerator = [[error userInfo] keyEnumerator];
    id key;
    
    NSString *strtest;
    while ((key = [enumerator nextObject])) {
         strtest = key;
        }
    
    enumerator = [[error userInfo] objectEnumerator];
    id value;
    
    while ((value = [enumerator nextObject])) {
         strtest = value;
        }
    
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
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

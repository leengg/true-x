//
//  TrueXFB.m
//  True-X
//
//  Created by Dao Nguyen on 6/1/13.
//  Copyright (c) 2013 Dao Nguyen. All rights reserved.
//

#import "TrueXFB.h"

static TrueXFB *_shareTrueXFB = nil;

@implementation TrueXFB

+ (TrueXFB *)shareTrueXFB {
    
    if (!_shareTrueXFB) {
        _shareTrueXFB = [[TrueXFB alloc] init];
    }
    return _shareTrueXFB;
}

#pragma mark - FB Application Delegate

+ (void)trueXFBWillTerminate {
    
    [FBSession.activeSession close];
}
+ (void)trueXFBDidBecomeActive {

    [FBAppCall handleDidBecomeActive];
}
+ (BOOL)trueXFB:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication fallbackHandler:^(FBAppCall *call) {
        NSLog(@"In fallback handler");
    }];
}

#pragma mark - FB actions

- (void)shareFB:(NSDictionary *)params onViewController:(UIViewController *)viewController {
    
    // Post a status update to the user's feed via the Graph API, and display an alert view
    // with the results or an error.
    
//    params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
//     @"https://developers.facebook.com/ios", @"link",
//     @"https://raw.github.com/fbsamples/ios-3.x-howtos/master/Images/iossdk_logo.png", @"picture",
//     @"Facebook SDK for iOS", @"name",
//     @"Build great social apps and get more installs.", @"caption",
//     @"The Facebook SDK for iOS makes it easier and faster to develop Facebook integrated iOS apps.", @"description",
//     nil];
    
    // This code demonstrates 3 different ways of sharing using the Facebook SDK.
    // The first method tries to share via the Facebook app. This allows sharing without
    // the user having to authorize your app, and is available as long as the user has the
    // correct Facebook app installed. This publish will result in a fast-app-switch to the
    // Facebook app.
    // The second method tries to share via Facebook's iOS6 integration, which also
    // allows sharing without the user having to authorize your app, and is available as
    // long as the user has linked their Facebook account with iOS6. This publish will
    // result in a popup iOS6 dialog.
    // The third method tries to share via a Graph API request. This does require the user
    // to authorize your app. They must also grant your app publish permissions. This
    // allows the app to publish without any user interaction.
    
    // If it is available, we will first try to post using the share dialog in the Facebook app
    NSURL *shareURL = [params objectForKey:@"link"] ? [NSURL URLWithString:[params objectForKey:@"link"]] : nil;
    NSURL *pictureURL = [params objectForKey:@"picture"] ? [NSURL URLWithString:[params objectForKey:@"picture"]] : nil;
    FBAppCall *appCall = [FBDialogs presentShareDialogWithLink:shareURL
                                                          name:[params objectForKey:@"name"]
                                                       caption:[params objectForKey:@"caption"]
                                                   description:[params objectForKey:@"description"]
                                                       picture:pictureURL
                                                   clientState:nil
                                                       handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                                           if (error) {
                                                               [TrueXAlert shareAlert].message = [error localizedDescription];
                                                               [[TrueXAlert shareAlert] show];
                                                           } else {
                                                               [TrueXAlert shareAlert].message = @"Posted successfully.";
                                                               [[TrueXAlert shareAlert] show];
                                                           }
                                                       }];
    
    if (!appCall) {
        // Next try to post using Facebook's iOS6 integration
        NSString *textStr = [NSString stringWithFormat:@"%@ %@ %@", [params objectForKey:@"name"], [params objectForKey:@"caption"], [params objectForKey:@"description"]];
        BOOL displayedNativeDialog = [FBDialogs presentOSIntegratedShareDialogModallyFrom:viewController
                                                                              initialText:textStr
                                                                                    image:[params objectForKey:@"photo"]
                                                                                      url:shareURL
                                                                                  handler:nil];
        
        if (!displayedNativeDialog) {
            // Lastly, fall back on a request for permissions and a direct post using the Graph API
            
            [self performIOS5PublishAction:params];
        }
    }
}

#pragma mark - iOS 5 Publish Story

// Convenience method to perform some action that requires the "publish_actions" permissions.
- (void) performIOS5PublishAction:(NSDictionary *)params {
    
    if (!FBSession.activeSession.isOpen) {
        [FBSession openActiveSessionWithPublishPermissions:@[@"publish_actions"] defaultAudience:FBSessionDefaultAudienceFriends allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
            
            [self sessionStateChanged:session state:status error:error];
            if (status == FBSessionStateOpen && !error) {
                [self publishStoryWithWebDialogAction:params];
            }
        }];
    }
    else {
        // we defer request for permission to post to the moment of post, then we check for the permission
        if ([FBSession.activeSession.permissions indexOfObject:@"publish_actions"] == NSNotFound) {
            // if we don't already have the permission, then we request it now
            [FBSession.activeSession requestNewPublishPermissions:@[@"publish_actions"] defaultAudience:FBSessionDefaultAudienceFriends completionHandler:^(FBSession *session, NSError *error) {
                if (!error)  [self publishStoryWithWebDialogAction:params];
                //For this example, ignore errors (such as if user cancels).
            }];
        }
        else {
            [self publishStoryWithWebDialogAction:params];
        }
    }
}

/*
 * Callback for session changes.
 */
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen:
            if (!error) {
                // We have a valid session
                //NSLog(@"User session found");
            }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            [FBSession.activeSession closeAndClearTokenInformation];
            break;
        default:
            break;
    }
        
    if (error) {
        [TrueXAlert shareAlert].message = [error localizedDescription];
        [[TrueXAlert shareAlert] show];
    }
}

#pragma mark - FB Publish Story

/*
 * Publish the story
 */
- (void)publishStoryWithoutWebDialog:(NSDictionary *)params
{
    [FBRequestConnection startWithGraphPath:@"me/feed" parameters:params HTTPMethod:@"POST" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
         NSString *alertText;
         if (error) {
//             alertText = [NSString stringWithFormat:@"Error: domain = %@, code = %d", error.domain, error.code];
             alertText = [error localizedDescription];
         } else {
             alertText = @"Posted successfully.";
         }
         // Show the result in an alert
        [TrueXAlert shareAlert].message = alertText;
        [[TrueXAlert shareAlert] show];
     }];
}

- (void)publishStoryWithWebDialogAction:(NSDictionary *)params {
    
    // Invoke the dialog
    [FBWebDialogs presentFeedDialogModallyWithSession:nil parameters:params handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
        if (error) {
             // Error launching the dialog or publishing a story.
             NSLog(@"Error publishing story.");
            [TrueXAlert shareAlert].message = [error localizedDescription];
            [[TrueXAlert shareAlert] show];
         } else {
             if (result == FBWebDialogResultDialogNotCompleted) {
                 // User clicked the "x" icon
                 NSLog(@"User canceled story publishing.");
             } else {
                 // Handle the publish feed callback
                 NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                 if (![urlParams valueForKey:@"post_id"]) {
                     // User clicked the Cancel button
                     NSLog(@"User canceled story publishing.");
                 } else {
                     // User clicked the Share button
                     //NSString *msg = [NSString stringWithFormat:@"Posted story, id: %@", [urlParams valueForKey:@"post_id"]];
                     // Show the result in an alert
                     [TrueXAlert shareAlert].message = @"Posted successfully.";
                     [[TrueXAlert shareAlert] show];
                 }
             }
         }
     }];
}

/**
 * A function for parsing URL parameters.
 */
- (NSDictionary*)parseURLParams:(NSString *)query {
    
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val = [[kv objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [params setObject:val forKey:[kv objectAtIndex:0]];
    }
    return params;
}

// UIAlertView helper for post buttons
- (void)showAlert:(NSString *)message result:(id)result error:(NSError *)error {
    
    NSString *alertMsg;
    if (error) {
        if (error.fberrorShouldNotifyUser ||
            error.fberrorCategory == FBErrorCategoryPermissions ||
            error.fberrorCategory == FBErrorCategoryAuthenticationReopenSession) {
            alertMsg = error.fberrorUserMessage;
        } else {
            alertMsg = @"Operation failed due to a connection problem, retry later.";
        }
    } else {
        alertMsg = @"Posted successfully.";
    }
    
    [TrueXAlert shareAlert].message = alertMsg;
    [[TrueXAlert shareAlert] show];
}

@end

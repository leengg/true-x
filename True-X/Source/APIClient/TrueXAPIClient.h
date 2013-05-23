//
//  TrueXAPIClient.h
//  True-X
//
//  Created by Dao Nguyen on 5/23/13.
//  Copyright (c) 2013 Dao Nguyen. All rights reserved.
//

#import "AFHTTPClient.h"

@interface TrueXAPIClient : AFHTTPClient

+ (TrueXAPIClient *)sharedAPIClient;

@end

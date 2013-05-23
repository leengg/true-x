//
//  TrueXAPIClient.m
//  True-X
//
//  Created by Dao Nguyen on 5/23/13.
//  Copyright (c) 2013 Dao Nguyen. All rights reserved.
//

#import "TrueXAPIClient.h"
#import "AFJSONRequestOperation.h"

@implementation TrueXAPIClient

static TrueXAPIClient *_shareAPIClient = nil;

+ (TrueXAPIClient *)sharedAPIClient {

    if (!_shareAPIClient) {
        _shareAPIClient = [[TrueXAPIClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://true-x.net/service"]];
    }
    return _shareAPIClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    // Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
	[self setDefaultHeader:@"Accept" value:@"application/json"];
    
    return self;
}

@end

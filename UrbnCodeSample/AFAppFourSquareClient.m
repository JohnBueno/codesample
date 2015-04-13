//
//  AFAppFourSquareClient.m
//  UrbnCodeSample
//
//  Created by John McCartney on 4/13/15.
//  Copyright (c) 2015 John McCartney. All rights reserved.
//

#import "AFAppFourSquareClient.h"

static NSString* const AFAppFourSquareClientBaseURLString = @"https://api.foursquare.com";

@implementation AFAppFourSquareClient

+ (instancetype)sharedClient
{
    static AFAppFourSquareClient* _sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[AFAppFourSquareClient alloc] initWithBaseURL:[NSURL URLWithString:AFAppFourSquareClientBaseURLString]];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    });

    return _sharedClient;
}

@end

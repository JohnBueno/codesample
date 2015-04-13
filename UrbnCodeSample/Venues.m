//
//  Venues.m
//  UrbnCodeSample
//
//  Created by John McCartney on 4/13/15.
//  Copyright (c) 2015 John McCartney. All rights reserved.
//

#import "Venues.h"
#import <AFNetworking/AFNetworking.h>
#import "AFAppFourSquareClient.h"

#define kCLIENTID @"YDU2NKEWT5N2VQPROGBXBUENW0GR3R4P41KDEZG1XLW5OANJ"
#define kCLIENTSECRET @"CTRLBHZGCDW5WYQSSOYFBZ0VGTUNMXJI1DGPHDRWV3DNCUU0"

@implementation Venues


+ (void)getVenuesNearLatitude:(float)latitude andLongitude:(float)longitude
{
    NSString* ll = [NSString stringWithFormat:@"%f,%f", latitude, longitude];
    NSDictionary* params = @{
        @"client_id" : kCLIENTID,
        @"client_secret" : kCLIENTSECRET,
        @"v" : @"20130815",
        @"limit" : @"10",
        @"ll" : ll,
        @"query" : @"sushi"
    };

    [[AFAppFourSquareClient sharedClient] GET:@"/v2/venues/search" parameters:params success:^(NSURLSessionDataTask* task, id responseObject) {
        NSLog(@"response object %@", responseObject);
    } failure:^(NSURLSessionDataTask* task, NSError* error) {
        NSLog(@"error %@", error.localizedDescription);
    }];
}

@end

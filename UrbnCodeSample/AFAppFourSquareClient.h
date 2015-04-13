//
//  AFAppFourSquareClient.h
//  UrbnCodeSample
//
//  Created by John McCartney on 4/13/15.
//  Copyright (c) 2015 John McCartney. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface AFAppFourSquareClient : AFHTTPSessionManager

+ (instancetype)sharedClient;

@end

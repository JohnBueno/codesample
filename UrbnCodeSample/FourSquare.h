//
//  Venues.h
//  UrbnCodeSample
//
//  Created by John McCartney on 4/13/15.
//  Copyright (c) 2015 John McCartney. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FourSquare : NSObject
@property (strong, nonatomic) NSDictionary* objectMap;

/**
 Block function that returns a list of venues from Foursquare
 param: float: user latitude from locaation data
 param: float: longitude from locaation data
 param: int: offset for results list
 param: int: limit of results list
 param: NSString: Specific query
 @return void
*/
+ (void)getVenuesNearLatitude:(float)latitude
                 andLongitude:(float)longitude
                    andOffset:(int)offset
                     andLimit:(int)limit
                     andQuery:(NSString*)query
                    withBlock:(void (^)(NSError*))block;

@end

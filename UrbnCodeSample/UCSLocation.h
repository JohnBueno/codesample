//
//  UCSLocation.h
//  UrbnCodeSample
//
//  Created by John McCartney on 4/16/15.
//  Copyright (c) 2015 John McCartney. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class UCSVenue;

@interface UCSLocation : NSManagedObject

@property (nonatomic, retain) NSString* cc;
@property (nonatomic, retain) NSString* city;
@property (nonatomic, retain) NSString* country;
@property (nonatomic) int16_t distance;
@property (nonatomic, retain) NSString* state;
@property (nonatomic, retain) NSString* address;
@property (nonatomic, retain) NSString* postalCode;
@property (nonatomic, retain) UCSVenue* venue;

@end

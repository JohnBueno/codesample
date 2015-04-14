//
//  UCSCategory.h
//  UrbnCodeSample
//
//  Created by John McCartney on 4/14/15.
//  Copyright (c) 2015 John McCartney. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class UCSIcon, UCSVenue;

@interface UCSCategory : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * pluralName;
@property (nonatomic) int16_t primary;
@property (nonatomic, retain) NSString * shortName;
@property (nonatomic, retain) UCSVenue *venue;
@property (nonatomic, retain) UCSIcon *icon;

@end

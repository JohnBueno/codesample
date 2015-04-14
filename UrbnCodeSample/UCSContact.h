//
//  UCSContact.h
//  UrbnCodeSample
//
//  Created by John McCartney on 4/14/15.
//  Copyright (c) 2015 John McCartney. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "UCSVenue.h"

@class UCSVenue;

@interface UCSContact : NSManagedObject

@property (nonatomic, retain) NSString * formattedPhone;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) UCSVenue *relationship;

@end

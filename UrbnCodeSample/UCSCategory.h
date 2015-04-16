//
//  UCSCategory.h
//  UrbnCodeSample
//
//  Created by John McCartney on 4/15/15.
//  Copyright (c) 2015 John McCartney. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NSManagedObject, UCSIcon;

@interface UCSCategory : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * pluralName;
@property (nonatomic) int16_t primary;
@property (nonatomic, retain) NSString * shortName;
@property (nonatomic, retain) UCSIcon *icon;
@property (nonatomic, retain) NSManagedObject *venue;

@end

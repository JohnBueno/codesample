//
//  UCSStats.h
//  UrbnCodeSample
//
//  Created by John McCartney on 4/15/15.
//  Copyright (c) 2015 John McCartney. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NSManagedObject;

@interface UCSStats : NSManagedObject

@property (nonatomic) int16_t checkinsCount;
@property (nonatomic) int16_t tipCount;
@property (nonatomic) int16_t usersCount;
@property (nonatomic, retain) NSManagedObject* venue;

@end

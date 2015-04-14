//
//  Venue.h
//  UrbnCodeSample
//
//  Created by John McCartney on 4/14/15.
//  Copyright (c) 2015 John McCartney. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NSManagedObject;

@interface Venue : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSManagedObject *contact;

@end

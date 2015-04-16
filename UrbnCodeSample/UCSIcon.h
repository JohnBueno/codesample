//
//  UCSIcon.h
//  UrbnCodeSample
//
//  Created by John McCartney on 4/15/15.
//  Copyright (c) 2015 John McCartney. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class UCSCategory;

@interface UCSIcon : NSManagedObject

@property (nonatomic, retain) NSString * prefix;
@property (nonatomic, retain) NSString * suffix;
@property (nonatomic, retain) UCSCategory *category;

@end

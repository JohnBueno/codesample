//
//  UCSIcon.h
//  UrbnCodeSample
//
//  Created by John McCartney on 4/14/15.
//  Copyright (c) 2015 John McCartney. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "UCSCategory.h"

@class UCSCategory;

@interface UCSIcon : UCSCategory

@property (nonatomic, retain) NSString * prefix;
@property (nonatomic, retain) NSString * suffix;
@property (nonatomic, retain) UCSCategory *category;

@end

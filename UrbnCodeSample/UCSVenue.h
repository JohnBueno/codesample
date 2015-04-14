//
//  UCSVenue.h
//  UrbnCodeSample
//
//  Created by John McCartney on 4/14/15.
//  Copyright (c) 2015 John McCartney. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class UCSCategory, UCSContact;

@interface UCSVenue : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * url;
@property (nonatomic) int16_t hasMenu;
@property (nonatomic, retain) NSString * referralId;
@property (nonatomic) BOOL verified;
@property (nonatomic, retain) UCSContact *contact;
@property (nonatomic, retain) NSSet *categories;
@end

@interface UCSVenue (CoreDataGeneratedAccessors)

- (void)addCategoriesObject:(UCSCategory *)value;
- (void)removeCategoriesObject:(UCSCategory *)value;
- (void)addCategories:(NSSet *)values;
- (void)removeCategories:(NSSet *)values;

@end

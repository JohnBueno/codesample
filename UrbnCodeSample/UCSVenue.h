//
//  UCSVenue.h
//  UrbnCodeSample
//
//  Created by John McCartney on 4/16/15.
//  Copyright (c) 2015 John McCartney. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class UCSCategory, UCSContact, UCSLocation, UCSPhotos, UCSStats;

@interface UCSVenue : NSManagedObject

@property (nonatomic) int16_t hasMenu;
@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSString* referralId;
@property (nonatomic, retain) NSString* url;
@property (nonatomic, retain) NSString* venueId;
@property (nonatomic) BOOL verified;
@property (nonatomic, retain) NSSet* categories;
@property (nonatomic, retain) UCSContact* contact;
@property (nonatomic, retain) UCSLocation* location;
@property (nonatomic, retain) UCSStats* stats;
@property (nonatomic, retain) UCSPhotos* featuredPhotos;
@end

@interface UCSVenue (CoreDataGeneratedAccessors)

- (void)addCategoriesObject:(UCSCategory*)value;
- (void)removeCategoriesObject:(UCSCategory*)value;
- (void)addCategories:(NSSet*)values;
- (void)removeCategories:(NSSet*)values;

@end

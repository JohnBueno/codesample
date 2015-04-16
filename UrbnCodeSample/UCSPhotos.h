//
//  UCSPhotos.h
//  UrbnCodeSample
//
//  Created by John McCartney on 4/16/15.
//  Copyright (c) 2015 John McCartney. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class UCSPhoto, UCSVenue;

@interface UCSPhotos : NSManagedObject

@property (nonatomic) int16_t count;
@property (nonatomic, retain) UCSVenue *venue;
@property (nonatomic, retain) NSSet *items;
@end

@interface UCSPhotos (CoreDataGeneratedAccessors)

- (void)addPhotoObject:(UCSPhoto *)value;
- (void)removePhotoObject:(UCSPhoto *)value;
- (void)addPhoto:(NSSet *)values;
- (void)removePhoto:(NSSet *)values;

@end

//
//  UCSPhoto.h
//  UrbnCodeSample
//
//  Created by John McCartney on 4/16/15.
//  Copyright (c) 2015 John McCartney. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NSManagedObject;

@interface UCSPhoto : NSManagedObject

@property (nonatomic) int16_t createdAt;
@property (nonatomic) int16_t height;
@property (nonatomic) int16_t* width;
@property (nonatomic, retain) NSString* photoID;
@property (nonatomic, retain) NSString* prefix;
@property (nonatomic, retain) NSString* suffix;
@property (nonatomic, retain) NSManagedObject* photos;

@end

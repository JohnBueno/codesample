//
//  Venues.m
//  UrbnCodeSample
//
//  Created by John McCartney on 4/13/15.
//  Copyright (c) 2015 John McCartney. All rights reserved.
//

#import "FourSquare.h"
#import <AFNetworking/AFNetworking.h>
#import "AFAppFourSquareClient.h"
#import "CoreDataStack.h"

//Coredata
#import "UCSVenue.h"
#import "UCSContact.h"
#import "UCSCategory.h"
#import "UCSIcon.h"

#define kCLIENTID @"YDU2NKEWT5N2VQPROGBXBUENW0GR3R4P41KDEZG1XLW5OANJ"
#define kCLIENTSECRET @"CTRLBHZGCDW5WYQSSOYFBZ0VGTUNMXJI1DGPHDRWV3DNCUU0"

@implementation FourSquare
@synthesize objectMap;
+ (void)getVenuesNearLatitude:(float)latitude andLongitude:(float)longitude
{

    [[CoreDataStack defaultStack] clearAll];
    NSString* ll = [NSString stringWithFormat:@"%f,%f", latitude, longitude];
    NSDictionary* params = @{
        @"client_id" : kCLIENTID,
        @"client_secret" : kCLIENTSECRET,
        @"v" : @"20130815",
        @"limit" : @"1",
        @"ll" : ll,
        @"query" : @"sushi"
    };

    //    self.objectMap = @{
    //        @"client_id" : kCLIENTID,
    //        @"client_secret" : kCLIENTSECRET,
    //        @"v" : @"20130815",
    //        @"limit" : @"10",
    //        @"ll" : ll,
    //        @"query" : @"sushi"
    //    };

    [[AFAppFourSquareClient sharedClient] GET:@"/v2/venues/search" parameters:params success:^(NSURLSessionDataTask* task, id responseObject) {
        NSMutableArray *venues = [[NSMutableArray alloc] initWithArray:[[responseObject objectForKey:@"response"] objectForKey:@"venues"]];
        
        

        for (NSDictionary* venue in venues) {
            //[FourSquare saveResponse:venue];
            [FourSquare processParsedObject:venue depth:0 parent:nil];
            //NSLog(@"----------");
        }

        //NSLog(@"response object %@", [venues firstObject]);

    } failure:^(NSURLSessionDataTask* task, NSError* error) {
        NSLog(@"error %@", error.localizedDescription);
    }];
}

+ (void)processParsedObject:(id)object depth:(int)depth parent:(id)parent
{

    if ([object isKindOfClass:[NSDictionary class]]) {

        for (NSString* key in [object allKeys]) {
            id child = [object objectForKey:key];
            if ([child isKindOfClass:[NSDictionary class]] || [child isKindOfClass:[NSArray class]]) {
                NSLog(@"Parent %@", key);
            }

            //            NSLog(@"Key %@", key);
            //            NSLog(@"Child %@", child);
            [self processParsedObject:child depth:depth + 1 parent:object];
        }
    }
    else if ([object isKindOfClass:[NSArray class]]) {

        for (id child in object) {
            [self processParsedObject:child depth:depth + 1 parent:object];
        }
    }
    else {
        //This object is not a container you might be interested in it's value
        //NSLog(@"Node: %@  depth: %d", [object description], depth);
    }
}

// Manual Object Mapping
+ (void)saveResponse:(NSDictionary*)dictionary
{
    CoreDataStack* coreDataStack = [CoreDataStack defaultStack];
    // Create Venue
    UCSVenue* venue = [NSEntityDescription insertNewObjectForEntityForName:@"UCSVenue" inManagedObjectContext:coreDataStack.managedObjectContext];
    [FourSquare mapFromDictionary:dictionary toObject:venue];

    // Create Contact
    UCSContact* contact = [NSEntityDescription insertNewObjectForEntityForName:@"UCSContact" inManagedObjectContext:coreDataStack.managedObjectContext];
    [FourSquare mapFromDictionary:[dictionary objectForKey:@"contact"] toObject:contact];
    [venue setContact:contact];

    // Add Categories
    UCSCategory* category = [NSEntityDescription insertNewObjectForEntityForName:@"UCSCategory" inManagedObjectContext:coreDataStack.managedObjectContext];

    NSMutableSet* categoriesSet = [venue mutableSetValueForKey:@"categories"];
    NSArray* categoriesArray = [dictionary objectForKey:@"categories"];
    for (NSDictionary* cat in categoriesArray) {
        [FourSquare mapFromDictionary:cat toObject:category];
        [categoriesSet addObject:category];
    }
    [coreDataStack saveContext];
}

+ (void)mapFromDictionary:(NSDictionary*)dictionary toObject:(NSManagedObject*)object
{
    NSEntityDescription* entity = [object entity];
    for (NSPropertyDescription* property in entity) {

        if (![NSStringFromClass([property class]) isEqual:@"NSRelationshipDescription"]) {

            NSString* value = [dictionary objectForKey:property.name];
            if (value != NULL) {
                [object setValue:value forKey:property.name];
                //NSLog(@"value %@ name %@", value, property.name);
            }
        }
    }
}

@end

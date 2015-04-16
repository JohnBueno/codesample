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
#import "UCSLocation.h"
#import "UCSStats.h"

#define kCLIENTID @"YDU2NKEWT5N2VQPROGBXBUENW0GR3R4P41KDEZG1XLW5OANJ"
#define kCLIENTSECRET @"CTRLBHZGCDW5WYQSSOYFBZ0VGTUNMXJI1DGPHDRWV3DNCUU0"

@implementation FourSquare
@synthesize objectMap;
- (void)getVenuesNearLatitude:(float)latitude andLongitude:(float)longitude
{

    [[CoreDataStack defaultStack] clearAll];
    NSString* ll = [NSString stringWithFormat:@"%f,%f", latitude, longitude];
    NSDictionary* params = @{
        @"client_id" : kCLIENTID,
        @"client_secret" : kCLIENTSECRET,
        @"v" : @"20130815",
        @"limit" : @"10",
        @"ll" : ll,
        @"query" : @"sushi"
    };

    [[AFAppFourSquareClient sharedClient] GET:@"/v2/venues/search" parameters:params success:^(NSURLSessionDataTask* task, id responseObject) {
        NSMutableArray *venues = [[NSMutableArray alloc] initWithArray:[[responseObject objectForKey:@"response"] objectForKey:@"venues"]];
        
        

        for (NSDictionary* venue in venues) {
            //NSLog(@"Venue %@", venue);
            [self saveResponse:venue];
            //NSMutableDictionary * venueDictionary = [NSMutableDictionary dictionaryWithObject:venue forKey:@"venue"];
            //[self processParsedObject:venue depth:0 parent:@"venue"];

        }

        //NSLog(@"response object %@", [venues firstObject]);

    } failure:^(NSURLSessionDataTask* task, NSError* error) {
        NSLog(@"error %@", error.localizedDescription);
    }];
}

// Manual Object Mapping
- (void)saveResponse:(NSDictionary*)dictionary
{
    CoreDataStack* coreDataStack = [CoreDataStack defaultStack];
    // Create Venue
    UCSVenue* venue = [NSEntityDescription insertNewObjectForEntityForName:@"UCSVenue" inManagedObjectContext:coreDataStack.managedObjectContext];
    [venue setFourSquareId:[dictionary objectForKey:@"id"]];
    [self mapFromDictionary:dictionary toObject:venue];

    // Create Contact
    //    UCSContact* contact = [NSEntityDescription insertNewObjectForEntityForName:@"UCSContact" inManagedObjectContext:coreDataStack.managedObjectContext];
    //    [self mapFromDictionary:[dictionary objectForKey:@"contact"] toObject:contact];
    //    [venue setContact:contact];
    //
    //    // Create Location
    //    UCSLocation* location = [NSEntityDescription insertNewObjectForEntityForName:@"UCSLocation" inManagedObjectContext:coreDataStack.managedObjectContext];
    //    [self mapFromDictionary:[dictionary objectForKey:@"location"] toObject:location];
    //    [venue setLocation:location];
    //
    //    // Create Location
    //    UCSStats* stats = [NSEntityDescription insertNewObjectForEntityForName:@"UCSStats" inManagedObjectContext:coreDataStack.managedObjectContext];
    //    [self mapFromDictionary:[dictionary objectForKey:@"stats"] toObject:stats];
    //    [venue setStats:stats];
    //
    //    // Add Categories
    //    UCSCategory* category = [NSEntityDescription insertNewObjectForEntityForName:@"UCSCategory" inManagedObjectContext:coreDataStack.managedObjectContext];

    //    NSMutableSet* categoriesSet = [venue mutableSetValueForKey:@"categories"];
    //    NSArray* categoriesArray = [dictionary objectForKey:@"categories"];
    //    for (NSDictionary* cat in categoriesArray) {
    //        [self mapFromDictionary:cat toObject:category];
    //        [categoriesSet addObject:category];
    //    }
    [coreDataStack saveContext];
}

- (void)mapFromDictionary:(NSDictionary*)dictionary toObject:(NSManagedObject*)object
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
        else {
            //TRY THIS!!!!!!!!!!!!
            NSManagedObject* relationship = [self getManagedObjectNamed:[property name]];
            [self mapFromDictionary:[dictionary objectForKey:[property name]] toObject:relationship];
            NSLog(@"RelationShip %@", relationship);
            [object setValue:relationship forKey:property.name];
        }
    }
}

- (NSManagedObject*)getManagedObjectNamed:(NSString*)objectName
{
    CoreDataStack* coreDataStack = [CoreDataStack defaultStack];
    UCSContact* contact = [NSEntityDescription insertNewObjectForEntityForName:@"UCSContact" inManagedObjectContext:coreDataStack.managedObjectContext];

    UCSLocation* location = [NSEntityDescription insertNewObjectForEntityForName:@"UCSLocation" inManagedObjectContext:coreDataStack.managedObjectContext];

    UCSStats* stats = [NSEntityDescription insertNewObjectForEntityForName:@"UCSStats" inManagedObjectContext:coreDataStack.managedObjectContext];

    NSDictionary* entities = @{
        @"contact" : contact,
        @"location" : location,
        @"stats" : stats
    };

    //REFACTOR THIS LATER
    NSManagedObject* relationshipObject;
    if ([entities objectForKey:objectName]) {
        relationshipObject = [entities objectForKey:objectName];
    }
    else {
        relationshipObject = nil;
    }

    return relationshipObject;
}

//- (void)processParsedObject:(id)object depth:(int)depth parent:(id)parent
//{
//
//    if ([object isKindOfClass:[NSDictionary class]]) {
//
//        for (NSString* key in [object allKeys]) {
//            id child = [object objectForKey:key];
//            if ([child isKindOfClass:[NSDictionary class]] || [child isKindOfClass:[NSArray class]]) {
//                NSLog(@"Create Object %@ and add to parent Parent %@", key, parent);
//            }
//            else {
//                NSLog(@"Add key %@ Directly to parent %@", key, parent);
//            }
//            [self processParsedObject:child depth:depth + 1 parent:key];
//        }
//    }
//    else if ([object isKindOfClass:[NSArray class]]) {
//
//        for (id child in object) {
//            [self processParsedObject:child depth:depth + 1 parent:@"categories"];
//        }
//    }
//    else {
//        //This object is not a container you might be interested in it's value
//        //NSLog(@"Node: %@  depth: %d", [object description], depth);
//        //NSLog(@"add %@ to %@", [object description], parent);
//    }
//}

@end

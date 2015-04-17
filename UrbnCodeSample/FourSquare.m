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
#import "UCSPhoto.h"
#import "UCSPhotos.h"

#define kCLIENTID @"YDU2NKEWT5N2VQPROGBXBUENW0GR3R4P41KDEZG1XLW5OANJ"
#define kCLIENTSECRET @"CTRLBHZGCDW5WYQSSOYFBZ0VGTUNMXJI1DGPHDRWV3DNCUU0"

@implementation FourSquare
@synthesize objectMap;

- (void)getVenuesNearLatitude:(float)latitude
                 andLongitude:(float)longitude
                    andOffset:(int)offset
                     andLimit:(int)limit
                     andQuery:(NSString*)query
                    withBlock:(void (^)(NSError*))block
{

    if (offset == 0) {
        [[CoreDataStack defaultStack] clearAll];
    }

    NSString* ll = [NSString stringWithFormat:@"%f,%f", latitude, longitude];
    NSString* offsetString = [NSString stringWithFormat:@"%d", offset];
    NSString* limitString = [NSString stringWithFormat:@"%d", limit];

    NSMutableDictionary* params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:kCLIENTID, @"client_id", kCLIENTSECRET, @"client_secret", @"20130815", @"v", limitString, @"limit", offsetString, @"offset", @"1", @"venuePhotos", @"1", @"sortByDistance", ll, @"ll", nil];

    if (query) {
        [params addEntriesFromDictionary:[NSDictionary dictionaryWithObjectsAndKeys:query, @"query", nil]];
    }

    NSLog(@"Params %@", params);

    [[AFAppFourSquareClient sharedClient] GET:@"/v2/venues/explore" parameters:params success:^(NSURLSessionDataTask* task, id responseObject) {
        //Response if Search
        //Might need this for query
        //NSMutableArray *venues = [[NSMutableArray alloc] initWithArray:[[responseObject objectForKey:@"response"] objectForKey:@"venues"]];
        
        //Response if explore
        NSArray *items = [[responseObject objectForKey:@"response"] objectForKey:@"groups"];
        NSArray *exploreArray = [[items firstObject] objectForKey:@"items"];
        for (NSDictionary* item in exploreArray) {
            //NSLog(@"Venue %@", [item objectForKey:@"venue"]);
            [self saveResponse:[item objectForKey:@"venue"]];
        }
        block(nil);

    } failure:^(NSURLSessionDataTask* task, NSError* error) {
        block(error);
    }];
}

// Manual Object Mapping
- (void)saveResponse:(NSDictionary*)dictionary
{
    CoreDataStack* coreDataStack = [CoreDataStack defaultStack];
    // Create Venue
    UCSVenue* venue = [NSEntityDescription insertNewObjectForEntityForName:@"UCSVenue" inManagedObjectContext:coreDataStack.managedObjectContext];
    // Set Id manually from foursquare because id is reserved
    [venue setVenueId:[dictionary objectForKey:@"id"]];
    [self mapFromDictionary:dictionary toObject:venue];

    [coreDataStack saveContext];
}

- (void)mapFromDictionary:(NSDictionary*)dictionary toObject:(NSManagedObject*)object
{
    NSEntityDescription* entity = [object entity];
    for (NSPropertyDescription* property in entity) {

        if (![NSStringFromClass([property class]) isEqual:@"NSRelationshipDescription"]) {
            //Map base properties
            NSString* value = [dictionary objectForKey:[property name]];
            if (value != NULL) {
                [object setValue:value forKey:[property name]];
            }
        }
        else {
            //If entity is a relationship call mapping recursively
            NSManagedObject* relationship = [self getManagedObjectNamed:[property name]];

            //If this property is an array then loop through and set 1 to many relationship
            if ([[dictionary objectForKey:[property name]] isKindOfClass:[NSArray class]]) {

                NSMutableSet* objectSet = [object mutableSetValueForKey:[property name]];
                NSArray* objectArray = [dictionary objectForKey:[property name]];

                for (NSDictionary* element in objectArray) {
                    [self mapFromDictionary:element toObject:relationship];
                    [objectSet addObject:relationship];
                }
            }
            //Else property is just a dictionary no need to iterate
            else {
                [self mapFromDictionary:[dictionary objectForKey:[property name]] toObject:relationship];
                [object setValue:relationship forKey:[property name]];
            }
        }
    }
}

// Map JSON Objects to NSManaged Objects
- (NSManagedObject*)getManagedObjectNamed:(NSString*)objectName
{

    CoreDataStack* coreDataStack = [CoreDataStack defaultStack];
    UCSContact* contact = [NSEntityDescription insertNewObjectForEntityForName:@"UCSContact" inManagedObjectContext:coreDataStack.managedObjectContext];

    UCSLocation* location = [NSEntityDescription insertNewObjectForEntityForName:@"UCSLocation" inManagedObjectContext:coreDataStack.managedObjectContext];

    UCSStats* stats = [NSEntityDescription insertNewObjectForEntityForName:@"UCSStats" inManagedObjectContext:coreDataStack.managedObjectContext];

    UCSCategory* category = [NSEntityDescription insertNewObjectForEntityForName:@"UCSCategory" inManagedObjectContext:coreDataStack.managedObjectContext];

    UCSIcon* icon = [NSEntityDescription insertNewObjectForEntityForName:@"UCSIcon" inManagedObjectContext:coreDataStack.managedObjectContext];

    UCSPhotos* photos = [NSEntityDescription insertNewObjectForEntityForName:@"UCSPhotos" inManagedObjectContext:coreDataStack.managedObjectContext];

    UCSPhoto* photo = [NSEntityDescription insertNewObjectForEntityForName:@"UCSPhoto" inManagedObjectContext:coreDataStack.managedObjectContext];

    //JSON Properties and cooresponding ManagedObject instances
    NSDictionary* entities = @{
        @"contact" : contact,
        @"location" : location,
        @"stats" : stats,
        @"categories" : category,
        @"icon" : icon,
        @"featuredPhotos" : photos,
        @"items" : photo
    };

    //NSLog(@"obj name %@", objectName);

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

@end

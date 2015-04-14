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

#define kCLIENTID @"YDU2NKEWT5N2VQPROGBXBUENW0GR3R4P41KDEZG1XLW5OANJ"
#define kCLIENTSECRET @"CTRLBHZGCDW5WYQSSOYFBZ0VGTUNMXJI1DGPHDRWV3DNCUU0"

@implementation FourSquare

+ (void)getVenuesNearLatitude:(float)latitude andLongitude:(float)longitude
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
            [FourSquare saveResponse:venue];
        }

        //NSLog(@"response object %@", [venues firstObject]);

    } failure:^(NSURLSessionDataTask* task, NSError* error) {
        NSLog(@"error %@", error.localizedDescription);
    }];
}

// Manual Object Mapping
+ (void)saveResponse:(NSDictionary*)dictionary
{
    CoreDataStack* coreDataStack = [CoreDataStack defaultStack];
    UCSVenue* venue = [NSEntityDescription insertNewObjectForEntityForName:@"UCSVenue" inManagedObjectContext:coreDataStack.managedObjectContext];

    [FourSquare mapFromDictionary:dictionary toObject:venue];

    UCSContact* contact = [NSEntityDescription insertNewObjectForEntityForName:@"UCSContact" inManagedObjectContext:coreDataStack.managedObjectContext];
    [contact setPhone:@"1111"];
    [venue setContact:contact];

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

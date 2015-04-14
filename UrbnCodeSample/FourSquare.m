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
#import "Venue.h"
#import "Contact.h"

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
            [FourSquare saveVenueToStoreWithVenue:venue];
        }
        
        NSLog(@"response object %@", [venues firstObject]);

    } failure:^(NSURLSessionDataTask* task, NSError* error) {
        NSLog(@"error %@", error.localizedDescription);
    }];
}

// Manual Object Mapping
+ (void)saveResponse:(NSDictionary*)response
{
    CoreDataStack* coreDataStack = [CoreDataStack defaultStack];
    Venue* venue = [NSEntityDescription insertNewObjectForEntityForName:@"Venue" inManagedObjectContext:coreDataStack.managedObjectContext];
    Contact* contact = [NSEntityDescription insertNewObjectForEntityForName:@"Contact" inManagedObjectContext:coreDataStack.managedObjectContext];

    [venue setName:[response objectForKey:@"name"]];
    [contact setPhone:@"1111"];
    [venue setContact:contact];

    [coreDataStack saveContext];
}

@end

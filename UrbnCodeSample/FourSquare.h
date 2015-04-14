//
//  Venues.h
//  UrbnCodeSample
//
//  Created by John McCartney on 4/13/15.
//  Copyright (c) 2015 John McCartney. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FourSquare : NSObject

+ (void)getVenuesNearLatitude:(float)latitude andLongitude:(float)longitude;
+ (void)saveVenueToStoreWithVenue:(NSDictionary*)venue;
@end

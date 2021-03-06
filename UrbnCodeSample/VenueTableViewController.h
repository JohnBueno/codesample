//
//  VenueTableViewController.h
//  UrbnCodeSample
//
//  Created by John McCartney on 4/14/15.
//  Copyright (c) 2015 John McCartney. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VenueTableViewController : UITableViewController

@property float latitude;
@property float longitude;
@property (strong, nonatomic) NSString* queryString;
@property (strong, nonatomic) NSString* nearString;

@end

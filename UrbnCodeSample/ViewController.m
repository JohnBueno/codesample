//
//  ViewController.m
//  UrbnCodeSample
//
//  Created by John McCartney on 4/13/15.
//  Copyright (c) 2015 John McCartney. All rights reserved.
//

#import "ViewController.h"
#import "FourSquare.h"
#import <CoreLocation/CoreLocation.h>

@interface ViewController () <CLLocationManagerDelegate> {
    FourSquare* fourSquare;
}

- (IBAction)getLocationPressed:(id)sender;

@end

@implementation ViewController {
    CLLocationManager* locationManager;
    float latitude;
    float longitude;
}

- (void)viewDidLoad
{
    NSLog(@"View Did load");
    [super viewDidLoad];
    fourSquare = [[FourSquare alloc] init];
    [self getlocation];
}

- (IBAction)getLocationPressed:(id)sender
{
    NSLog(@"get location button");
    [self getlocation];
}

- (void)getlocation
{
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    if ([locationManager
            respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
}

- (IBAction)searchBtnPressed:(id)sender
{
    NSLog(@"Search button Pressed");
    [self performSegueWithIdentifier:@"showResults" sender:nil];
    //[Venues testAFNetworking];
}

#pragma mark CLLocationManagerDelegate Methods

- (void)locationManager:(CLLocationManager*)manager
       didFailWithError:(NSError*)error
{
    // Add instructions if in simulator
    NSLog(@"Location Error %@", error);
}

- (void)locationManager:(CLLocationManager*)manager
     didUpdateLocations:(NSArray*)locations
{
    CLLocation* location = [locations lastObject];
    if (location != nil) {
        latitude = location.coordinate.latitude;
        longitude = location.coordinate.longitude;
        // Convert all fourSqaure to class method
        // Instance not needed with coredata
        [fourSquare getVenuesNearLatitude:latitude andLongitude:longitude withBlock:^(NSError* error) {
                    if(!error){
                        NSLog(@"Push to list");
                    }else{
                        NSLog(@"error %@", error);
                    }
        }];
    }

    [locationManager stopUpdatingLocation];
}

@end

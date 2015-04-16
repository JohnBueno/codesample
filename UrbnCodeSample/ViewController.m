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

@interface ViewController () <CLLocationManagerDelegate>

- (IBAction)getLocationPressed:(id)sender;

@end

@implementation ViewController {
    CLLocationManager* locationManager;
    float latitude;
    float longitude;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    locationManager = [[CLLocationManager alloc] init];
}

- (IBAction)getLocationPressed:(id)sender
{
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
    NSLog(@"test search");
    [self performSegueWithIdentifier:@"showResults" sender:nil];
    //[Venues testAFNetworking];
}

#pragma mark CLLocationManagerDelegate Methods

- (void)locationManager:(CLLocationManager*)manager
       didFailWithError:(NSError*)error
{
    NSLog(@"Location Error %@", error);
}

- (void)locationManager:(CLLocationManager*)manager
     didUpdateLocations:(NSArray*)locations
{
    CLLocation* location = [locations lastObject];

    if (location != nil) {
        latitude = location.coordinate.latitude;
        longitude = location.coordinate.longitude;
        FourSquare* fourSquare = [[FourSquare alloc] init];
        [fourSquare getVenuesNearLatitude:latitude andLongitude:longitude];
    }

    [locationManager stopUpdatingLocation];
}

@end

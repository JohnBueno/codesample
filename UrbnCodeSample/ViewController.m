//
//  ViewController.m
//  UrbnCodeSample
//
//  Created by John McCartney on 4/13/15.
//  Copyright (c) 2015 John McCartney. All rights reserved.
//

#import "ViewController.h"
#import "VenueTableViewController.h"
#import "FourSquare.h"
#import <CoreLocation/CoreLocation.h>
#import <SVProgressHUD/SVProgressHUD.h>

@interface ViewController () <CLLocationManagerDelegate, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UILabel* lblAddress;
- (IBAction)toggleSearchPressed:(id)sender;

- (IBAction)getLocationPressed:(id)sender;

- (void)viewResultsBtnPressed;

- (void)searchForQuery;

@property (strong, nonatomic) IBOutlet UITextField* inputQuery;
@property (strong, nonatomic) IBOutlet UIButton* btnToggleSearch;
@property (strong, nonatomic) IBOutlet UIButton* btnSearch;
@property (strong, nonatomic) IBOutlet UILabel* lblSearchType;
@property (strong, nonatomic) IBOutlet UITextField* inputNear;
@property BOOL isLocationEnabled;

@end

@implementation ViewController {
    CLLocationManager* locationManager;
    CLGeocoder* geoCoder;
    CLPlacemark* placeMark;
    float latitude;
    float longitude;
    NSString* query;
    BOOL didFindLocation;
    //FourSquare* fourSquare;
}

@synthesize lblAddress;
@synthesize inputQuery;
@synthesize btnToggleSearch;
@synthesize btnSearch;
@synthesize lblSearchType;
@synthesize inputNear;
@synthesize isLocationEnabled;

- (void)viewDidLoad
{
    [super viewDidLoad];
    geoCoder = [[CLGeocoder alloc] init];
    [self getlocation];
    [btnSearch addTarget:self action:@selector(viewResultsBtnPressed) forControlEvents:UIControlEventTouchUpInside];
}

// Toggle Search function
- (IBAction)toggleSearchPressed:(id)sender
{
    [lblAddress setHidden:!lblAddress.hidden];
    [inputQuery setHidden:!inputQuery.hidden];

    // If no location services require manual entry for city
    if (isLocationEnabled == NO && [inputNear.text isEqual:@""]) {
        [self mustEnterLocation];
    }
    else if (lblAddress.hidden) {
        [self showLocation];
    }
    else {
        [self showQuery];
    }
    [inputQuery resignFirstResponder];
    [inputNear resignFirstResponder];
}

//Show location input
- (void)showLocation
{
    [btnToggleSearch setTitle:@"Show me everything" forState:UIControlStateNormal];
    [lblSearchType setText:@"I'm looking for:"];
    [inputNear setHidden:YES];
    [btnSearch removeTarget:self action:@selector(viewResultsBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [btnSearch addTarget:self action:@selector(searchForQuery) forControlEvents:UIControlEventTouchUpInside];
}

//Show specific query input
- (void)showQuery
{
    [btnToggleSearch setTitle:@"Find something specfic" forState:UIControlStateNormal];
    [lblSearchType setText:@"Show me everything near:"];
    if (!isLocationEnabled) {
        [inputNear setHidden:NO];
    }
    [btnSearch removeTarget:self action:@selector(searchForQuery) forControlEvents:UIControlEventTouchUpInside];
    [btnSearch addTarget:self action:@selector(viewResultsBtnPressed) forControlEvents:UIControlEventTouchUpInside];
}

// View all results for location
- (void)viewResultsBtnPressed
{
    if (isLocationEnabled == NO && [inputNear.text isEqual:@""]) {
        [self mustEnterLocation];
    }
    else {
        [self requestVenuesFromFourSquareWithQuery:nil];
    }
}

// Search for query near location
- (void)searchForQuery
{
    query = inputQuery.text;
    if (![inputQuery.text isEqualToString:@""]) {
        query = inputQuery.text;
    }
    [self requestVenuesFromFourSquareWithQuery:query];
}

// Manually get location
- (IBAction)getLocationPressed:(id)sender
{
    [self getlocation];
}

- (void)mustEnterLocation
{
    UIAlertView* loactionError = [[UIAlertView alloc] initWithTitle:@"Location Error" message:@"Please manually enter a location before searching." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [loactionError show];
}

// Request venues from FourSquare
- (void)requestVenuesFromFourSquareWithQuery:(NSString*)_query
{
    [SVProgressHUD showWithStatus:@"Generating List" maskType:SVProgressHUDMaskTypeGradient];

    [FourSquare getVenuesNearLatitude:latitude
                         andLongitude:longitude
                            andOffset:0
                             andLimit:10
                             andQuery:_query
                              andNear:inputNear.text
                            withBlock:^(NSError* error) {
                                
                                [SVProgressHUD dismiss];
                                if(!error){
                                    //NSLog(@"Push to list");
                                    [self performSegueWithIdentifier:@"showResults" sender:self];
                                    [inputQuery setText:@""];
                                }else{
                                    NSLog(@"error %@", error);
                                }

                            }];
}

- (void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"showResults"]) {
        VenueTableViewController* venueTableViewController = [segue destinationViewController];
        venueTableViewController.latitude = latitude;
        venueTableViewController.longitude = longitude;
        venueTableViewController.queryString = query;
        venueTableViewController.nearString = inputNear.text;
    }
}

#pragma mark CLLocationManagerDelegate Methods

// Set up Location Manager
- (void)getlocation
{
    didFindLocation = NO;
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    [SVProgressHUD showWithStatus:@"Finding Location" maskType:SVProgressHUDMaskTypeGradient];

    if ([locationManager
            respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
}

// If location manager fails to get location
- (void)locationManager:(CLLocationManager*)manager
       didFailWithError:(NSError*)error
{
    [SVProgressHUD dismiss];

    NSString* errorMessage;

    if (TARGET_IPHONE_SIMULATOR) {
        errorMessage = @"The simulator cannot retreive location data.  To simulate select debug/location.";
    }
    else {
        errorMessage = @"Location Services are not available";
    }
    [self setIsLocationEnabled:NO];
    [inputNear setHidden:NO];

    UIAlertView* locationError = [[UIAlertView alloc] initWithTitle:@"Error getting location" message:errorMessage delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
    // Add instructions if in simulator
    [locationError show];

    [lblAddress setText:@""];
}

- (void)locationManager:(CLLocationManager*)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusRestricted || status == kCLAuthorizationStatusDenied || status == kCLAuthorizationStatusNotDetermined) {
        isLocationEnabled = NO;
        [inputNear setHidden:NO];
    }
    else {
        isLocationEnabled = YES;
        [inputNear setHidden:YES];
    }
}

- (void)locationManager:(CLLocationManager*)manager
     didUpdateLocations:(NSArray*)locations
{
    CLLocation* location = [locations lastObject];

    if (location != nil && !didFindLocation) {
        [locationManager stopUpdatingLocation];
        didFindLocation = YES;
        latitude = location.coordinate.latitude;
        longitude = location.coordinate.longitude;
        [SVProgressHUD dismiss];
    }
    [self getAddressForLocation:location];
}

// Build actual address.
- (void)getAddressForLocation:(CLLocation*)location
{
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray* placemarks, NSError* error) {
        if (!error && [placemarks count] > 0) {
            placeMark = [placemarks lastObject];

            NSMutableString *label = [NSMutableString string];
            if (placeMark.subThoroughfare) {
                [label appendString:[NSString stringWithFormat:@"%@ ", placeMark.subThoroughfare]];
            }
            
            if (placeMark.thoroughfare) {
                [label appendString:[NSString stringWithFormat:@"%@\n", placeMark.thoroughfare]];
            }
            
            if (placeMark.postalCode) {
                [label appendString:[NSString stringWithFormat:@"%@ ", placeMark.postalCode]];
            }
            
            if (placeMark.locality) {
                [label appendString:[NSString stringWithFormat:@"%@ ", placeMark.locality]];
            }
            
            if (placeMark.administrativeArea) {
                [label appendString:[NSString stringWithFormat:@"%@\n", placeMark.administrativeArea]];
            }
            
            if (placeMark.country) {
                [label appendString:[NSString stringWithFormat:@"%@ ", placeMark.country]];
            }
            
            [lblAddress setText:label];
            
        }else{
            NSLog(@"Error %@", error.debugDescription);
        }

    }];
}

@end

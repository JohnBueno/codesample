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

@interface ViewController () <CLLocationManagerDelegate>

@property (strong, nonatomic) IBOutlet UILabel* lblAddress;

- (IBAction)getLocationPressed:(id)sender;
- (IBAction)viewResultsBtnPressed:(id)sender;
- (IBAction)searchForQuery:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField* inputQuery;

@end

@implementation ViewController {
    CLLocationManager* locationManager;
    CLGeocoder* geoCoder;
    CLPlacemark* placeMark;
    float latitude;
    float longitude;
    BOOL didFindLocation;
    FourSquare* fourSquare;
}

@synthesize lblAddress;
@synthesize inputQuery;

- (void)viewDidLoad
{
    [super viewDidLoad];
    fourSquare = [[FourSquare alloc] init];
    geoCoder = [[CLGeocoder alloc] init];
    [self getlocation];
}

- (IBAction)getLocationPressed:(id)sender
{
    NSLog(@"get location button");
    [self getlocation];
}

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

- (IBAction)viewResultsBtnPressed:(id)sender
{
    NSLog(@"Search button Pressed");
    [SVProgressHUD showWithStatus:@"Generating List" maskType:SVProgressHUDMaskTypeGradient];

    [fourSquare getVenuesNearLatitude:latitude
                         andLongitude:longitude
                            andOffset:0
                             andLimit:10
                             andQuery:nil
                            withBlock:^(NSError* error) {
                                
                                [SVProgressHUD dismiss];
                                if(!error){
                                    [self performSegueWithIdentifier:@"showResults" sender:self];
                                    [inputQuery setText:@""];
                                }else{
                                    NSLog(@"error %@", error);
                                }

                            }];
}

- (IBAction)searchForQuery:(id)sender
{
    NSString* query;
    query = inputQuery.text;
    if (![inputQuery.text isEqualToString:@""]) {
        query = inputQuery.text;
    }

    [SVProgressHUD showWithStatus:@"Generating List" maskType:SVProgressHUDMaskTypeGradient];

    [fourSquare getVenuesNearLatitude:latitude
                         andLongitude:longitude
                            andOffset:0
                             andLimit:10
                             andQuery:query
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
    }
}

#pragma mark CLLocationManagerDelegate Methods

- (void)locationManager:(CLLocationManager*)manager
       didFailWithError:(NSError*)error
{
    [SVProgressHUD dismiss];
    UIAlertView* locationError = [[UIAlertView alloc] initWithTitle:@"Error getting location" message:@"Location Services are not available" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
    // Add instructions if in simulator
    [locationError show];

    NSLog(@"Location Error %@", error);
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

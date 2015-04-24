//
//  DetailViewController.m
//  UrbnCodeSample
//
//  Created by John McCartney on 4/16/15.
//  Copyright (c) 2015 John McCartney. All rights reserved.
//

#import "DetailViewController.h"
#import "UCSIcon.h"
#import "UCSLocation.h"
#import "UCSContact.h"
#import "UCSCategory.h"
#import "UCSPhotos.h"
#import "UCSPhoto.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface DetailViewController ()

@property (strong, nonatomic) IBOutlet UILabel* lblCategory;
@property (strong, nonatomic) IBOutlet UIImageView* imgVenue;
@property (strong, nonatomic) IBOutlet UIImageView* imgCategory;
@property (strong, nonatomic) IBOutlet UILabel* lblVenueName;
@property (strong, nonatomic) IBOutlet UILabel* lblAddressLine1;
@property (strong, nonatomic) IBOutlet UILabel* lblAddressLine2;
@property (strong, nonatomic) IBOutlet UILabel* lblHours;
@property (strong, nonatomic) IBOutlet UILabel* lblWebsite;
@property (strong, nonatomic) IBOutlet UILabel* lblRating;

@end

@implementation DetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.lblVenueName setText:self.detailVenue.name];
    [self.lblRating setText:[NSString stringWithFormat:@"%1.1f", self.detailVenue.rating]];
    [self.lblWebsite setText:self.detailVenue.url];

    //Location
    UCSLocation* location = self.detailVenue.location;
    self.lblAddressLine1.text = location.address;
    self.lblAddressLine2.text = [NSString stringWithFormat:@"%@, %@ %@", location.city, location.state, location.postalCode];

    //Category
    UCSCategory* category = [[self.detailVenue.categories allObjects] firstObject];
    self.lblCategory.text = category.name;
    NSDictionary* icon = [category valueForKey:@"icon"];
    NSString* iconUrlString = [self imageFromPrefix:[icon valueForKey:@"prefix"] andSize:@"bg_64" andSuffix:[icon valueForKey:@"suffix"]];
    [self.imgCategory sd_setImageWithURL:[NSURL URLWithString:iconUrlString]
                        placeholderImage:[UIImage imageNamed:@"placeholder.png"]];

    //Photo
    UCSPhoto* photo = [[self.detailVenue.featuredPhotos.items allObjects] firstObject];
    NSString* venueImageSize = [NSString stringWithFormat:@"%dx%d", photo.width, photo.height];
    NSString* venueImageUrlString = [self imageFromPrefix:photo.prefix andSize:venueImageSize andSuffix:photo.suffix];
    [self.imgVenue sd_setImageWithURL:[NSURL URLWithString:venueImageUrlString]
                     placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
}

//Builds image urlstring
- (NSString*)imageFromPrefix:(NSString*)prefix andSize:(NSString*)size andSuffix:(NSString*)suffix
{
    NSString* urlString = [NSString stringWithFormat:@"%@%@%@", prefix, size, suffix];
    return urlString;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

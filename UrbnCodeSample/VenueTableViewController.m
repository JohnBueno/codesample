//
//  VenueTableViewController.m
//  UrbnCodeSample
//
//  Created by John McCartney on 4/14/15.
//  Copyright (c) 2015 John McCartney. All rights reserved.
//

#import "VenueTableViewController.h"
#import "DetailViewController.h"
#import "CoreDataStack.h"
#import "UCSVenue.h"
#import "UCSIcon.h"
#import "UCSLocation.h"
#import "UCSContact.h"
#import "UCSPhotos.h"
#import "UCSPhoto.h"
#import "FourSquare.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIScrollView+SVInfiniteScrolling.h"

@interface VenueTableViewController () <NSFetchedResultsControllerDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) NSFetchedResultsController* fetchedResultsController;

@property int limit;
@property int offset;

@end

@implementation VenueTableViewController

@synthesize latitude;
@synthesize longitude;
@synthesize queryString;
@synthesize offset;
@synthesize limit;
@synthesize nearString;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Call results from coredata
    [self.fetchedResultsController performFetch:nil];
    [self setUpInfiniteScrolling];
}

// Pagination
- (void)setUpInfiniteScrolling
{
    // Init limit and offset
    limit = 10;
    offset = 10;

    // load more content when scroll to the bottom most
    __weak typeof(self) weakSelf = self;

    [self.tableView addInfiniteScrollingWithActionHandler:^{
        
        [FourSquare getVenuesNearLatitude:weakSelf.latitude
                             andLongitude:weakSelf.longitude
                                andOffset:weakSelf.offset
                                 andLimit:weakSelf.limit
                                 andQuery:weakSelf.queryString
                                  andNear:weakSelf.nearString
                                withBlock:^(NSError *error) {
                                    if (!error) {
                                        offset += limit;
                                        [weakSelf.fetchedResultsController performFetch:nil];
                                    }else{
                                        NSLog(@"Error %@", error);
                                    }
                                    
                                    [weakSelf.tableView.infiniteScrollingView stopAnimating];
                                }];

    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{

    // Return the number of sections.
    return self.fetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{

    id<NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{

    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    if (indexPath.row % 2 == 0) {
        [cell setBackgroundColor:[UIColor colorWithRed:(244.0f / 255.0f)green:(244.0f / 255.0f)blue:(244.0f / 255.0f)alpha:1]];
    }
    else {
        [cell setBackgroundColor:[UIColor whiteColor]];
    }

    UCSVenue* venue = [self.fetchedResultsController objectAtIndexPath:indexPath];

    //Set image
    UIImageView* imageView = (UIImageView*)[cell viewWithTag:100];
    NSDictionary* icon = [[[venue.categories allObjects] firstObject] valueForKey:@"icon"];
    NSString* urlString = [self imageFromPrefix:[icon valueForKey:@"prefix"] andSuffix:[icon valueForKey:@"suffix"]];
    [imageView sd_setImageWithURL:[NSURL URLWithString:urlString]
                 placeholderImage:[UIImage imageNamed:@"placeholder.png"]];

    //Set venue label
    UILabel* nameLabel = (UILabel*)[cell viewWithTag:101];
    nameLabel.text = venue.name;

    UILabel* distanceLabel = (UILabel*)[cell viewWithTag:102];
    float distanceMiles = venue.location.distance * 0.000621371;
    distanceLabel.text = [NSString stringWithFormat:@"Distance: %1.1f miles", distanceMiles];

    return cell;
}

//Builds image urlstring
- (NSString*)imageFromPrefix:(NSString*)prefix andSuffix:(NSString*)suffix
{
    NSString* urlString = [NSString stringWithFormat:@"%@bg_64%@", prefix, suffix];
    return urlString;
}

#pragma mark - Fetch CoreData

- (NSFetchRequest*)entryListFetchRequest
{
    NSFetchRequest* fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"UCSVenue"];

    fetchRequest.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"location.distance" ascending:YES] ];

    return fetchRequest;
}

- (NSFetchedResultsController*)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }

    CoreDataStack* coreDataStack = [CoreDataStack defaultStack];
    NSFetchRequest* fetchRequest = [self entryListFetchRequest];

    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:coreDataStack.managedObjectContext sectionNameKeyPath:nil cacheName:nil];

    _fetchedResultsController.delegate = self;

    return _fetchedResultsController;
}

- (void)controllerDidChangeContent:(NSFetchedResultsController*)controller
{
    //NSLog(@"Did change data");
    [self.tableView reloadData];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.

    if ([segue.identifier isEqualToString:@"showVenueDetail"]) {

        DetailViewController* detailViewController = segue.destinationViewController;
        UCSVenue* venue = [self.fetchedResultsController objectAtIndexPath:self.tableView.indexPathForSelectedRow];
        detailViewController.detailVenue = venue;
    }
}

@end

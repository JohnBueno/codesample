//
//  VenueTableViewController.m
//  UrbnCodeSample
//
//  Created by John McCartney on 4/14/15.
//  Copyright (c) 2015 John McCartney. All rights reserved.
//

#import "VenueTableViewController.h"
#import "CoreDataStack.h"
#import "UCSVenue.h"
#import "UCSLocation.h"
#import "UCSContact.h"
#import "FourSquare.h"
#import "UIScrollView+SVInfiniteScrolling.h"

@interface VenueTableViewController () <NSFetchedResultsControllerDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) NSFetchedResultsController* fetchedResultsController;

@property int limit;
@property int offset;

@end

@implementation VenueTableViewController

@synthesize latitude;
@synthesize longitude;
@synthesize offset;
@synthesize limit;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.fetchedResultsController performFetch:nil];
    [self setUpInfiniteScrolling];
}

- (void)setUpInfiniteScrolling
{
    limit = 10;
    offset = 10;

    // load more content when scroll to the bottom most
    __weak typeof(self) weakSelf = self;

    [self.tableView addInfiniteScrollingWithActionHandler:^{
        
        FourSquare *fourSquare = [[FourSquare alloc] init];
        [fourSquare getVenuesNearLatitude:weakSelf.latitude
                             andLongitude:weakSelf.longitude
                                andOffset:weakSelf.offset
                                 andLimit:weakSelf.limit
                                withBlock:^(NSError *error) {
                                    if (!error) {
                                        offset += limit;
                                        [weakSelf.fetchedResultsController performFetch:nil];
                                    }else{
                                        NSLog(@"Error %@", error);
                                    }
                                    [weakSelf.tableView.infiniteScrollingView stopAnimating];
                                    //weakSelf.tableView.showsInfiniteScrolling = NO;
                                    //[weakSelf.tableView.infiniteScrollingView performSelector:@selector(stopAnimating) withObject:nil];
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

    UCSVenue* venue = [self.fetchedResultsController objectAtIndexPath:indexPath];
    //    NSLog(@"url %@", [venue valueForKey:@"url"]);
    //    NSLog(@"location %@", venue.location);
    //    NSLog(@"Name %@", venue.name);
    //    NSLog(@"category %@", [[[venue.categories allObjects] firstObject] valueForKey:@"icon"]);
    cell.textLabel.text = venue.name;

    return cell;
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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

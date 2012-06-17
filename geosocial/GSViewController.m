//
//  GSViewController.m
//  geosocial
//
//  Created by Иван Ушаков on 16.06.12.
//  Copyright (c) 2012 ООО Скрипт. All rights reserved.
//

#import <SVPullToRefresh/SVPullToRefresh.h>
#import "GSViewController.h"
#import "GSItemTableVIewCell.h"
#import "GSItemModel.h"

@interface GSViewController ()
@property (nonatomic, retain) GSItemModel *itemModel;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) Items *selectedItem;
- (void)pinchImageHandler:(UIPinchGestureRecognizer*)recognizer;
@end

@implementation GSViewController
@synthesize itemModel = _itemModel;
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize selectedItem = _selectedItem;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.itemModel = [[[GSItemModel alloc] init] autorelease];
        
        [self.tableView addPullToRefreshWithActionHandler:^(void){
            [self.itemModel loadItems];
        }];
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)dealloc
{
    [_itemModel release];
    [_selectedItem release];
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(itemsDidLoad)
                                                 name:GS_ITEM_MODEL_FINISH_LOAD_ITEMS
                                               object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.fetchedResultsController performFetch:nil];
    [self.tableView.pullToRefreshView triggerRefresh];
    [NSTimer scheduledTimerWithTimeInterval:30.0f
                                     target:self.tableView.pullToRefreshView
                                   selector:@selector(triggerRefresh)
                                   userInfo:nil 
                                    repeats:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.fetchedResultsController = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[self.fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *GSItemTableVIewCellIdentifier = @"GSItemTableVIewCellIdentifier";
    GSItemTableVIewCell *cell = [tableView dequeueReusableCellWithIdentifier:GSItemTableVIewCellIdentifier];
    if (!cell) {
        cell = [[[GSItemTableVIewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                           reuseIdentifier:GSItemTableVIewCellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self
                                                                                                     action:@selector(pinchImageHandler:)];
        
        [cell.imageView addGestureRecognizer:pinchGestureRecognizer];
        [pinchGestureRecognizer release];
    }
    cell.item = [self.fetchedResultsController objectAtIndexPath:indexPath];
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [GSItemTableVIewCell heightForCellWithItem:[self.fetchedResultsController objectAtIndexPath:indexPath]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedItem = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if ([self.selectedItem.media count] > 0) {
        MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        browser.displayActionButton = YES;
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
        nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentModalViewController:nc animated:YES];
        [nc release];
    }
}

#pragma mark - fetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller 
{
    [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller 
   didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath 
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath 
{
    UITableView *tableView = self.tableView;
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeUpdate:
            [(GSItemTableVIewCell*)[tableView cellForRowAtIndexPath:indexPath] setItem: [self.fetchedResultsController objectAtIndexPath:indexPath]];
            break;
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray
                                               arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray
                                               arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller 
  didChangeSection:(id )sectionInfo 
           atIndex:(NSUInteger)sectionIndex 
     forChangeType:(NSFetchedResultsChangeType)type 
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

#pragma mark - privat

- (void)itemsDidLoad
{
    [self.tableView.pullToRefreshView stopAnimating];
}

- (void)pinchImageHandler:(UIPinchGestureRecognizer*)recognizer
{
    if (recognizer.scale > 0.5) {
        
    }
}

#pragma mark - properties

- (NSFetchedResultsController *)fetchedResultsController
{
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    self.fetchedResultsController = [[[NSFetchedResultsController alloc] initWithFetchRequest:[Items requestAllSortedBy:@"createdAt" ascending:NO]
                                                                         managedObjectContext:[NSManagedObjectContext defaultContext]
                                                                           sectionNameKeyPath:nil
                                                                                    cacheName:@"Root"] autorelease];
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return [self.selectedItem.media count];
}

- (MWPhoto *)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < [self.selectedItem.media count]) {
        NSArray *images = [self.selectedItem.media allObjects];
        return [MWPhoto photoWithURL:[NSURL URLWithString:[[images objectAtIndex:index] url]]];
    }
    return nil;
}

@end

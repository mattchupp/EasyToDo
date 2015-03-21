//
//  MCItemsViewController.m
//  HomePwner
//
//  Created by Matthew Chupp on 3/18/15.
//  Copyright (c) 2015 MattChupp. All rights reserved.
//

#import "MCItemsViewController.h"
#import "MCItemStore.h"
#import "MCItem.h"
#import "MCDetailViewController.h"

@interface MCItemsViewController ()



@end


@implementation MCItemsViewController

#pragma mark -Setup


- (instancetype)init {
    
    // call the superclass's designated initializer
    self = [super initWithStyle:UITableViewStylePlain];
    
    if (self) {
        
        UINavigationItem *navItem = self.navigationItem;
        navItem.title = @"Tasks";
        
        // create a new bar button item that sends
        // addNewItem: to MCItemsViewController
        UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                           target:self
                                           action:@selector(addNewItem:)];
        
        // set this bar button as the right item in the navigationItem
        navItem.rightBarButtonItem = rightBarButton;
        
        // set the left bar button to be the right item in the navigationItem
        navItem.leftBarButtonItem = self.editButtonItem;
        
    }
    
    return self;
    
}

- (instancetype)initWithStyle:(UITableViewStyle)style {
    return [self init];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[[MCItemStore sharedStore] allItems] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // create an instance of UITableViewCell, with default appearance
//    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
//                                                   reuseIdentifier:@"UITableViewCell"];
    
    // get a new or recycled cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"
                                                        forIndexPath:indexPath];
    
    // set the text on the cell with the description of the item
    // that is at the nth index of items, where n = row this cell
    // will appear in on the tablview
    NSArray *items = [[MCItemStore sharedStore] allItems];
    MCItem *item = items[indexPath.row];
    
    cell.textLabel.text = [item description];
    
    return cell;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
}

#pragma mark -Buttons

- (IBAction)addNewItem:(id)sender {
    
    /* CAN'T DO THIS - NOT TELLING STORE THERE IS A NEW ITEM AND CAUSES CRASH*/
    // make a new index path for the 0th section, last row
    //    NSInteger lastRow = [self.tableView numberOfRowsInSection:0];
    
    
    // create new MCItem and add it to the store
    MCItem *newItem = [[MCItemStore sharedStore] createItem];
    
    // figure out where that item is in the array
    NSInteger lastRow = [[[MCItemStore sharedStore] allItems] indexOfObject:newItem];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lastRow inSection:0];
    
    // insert this new row into the table
    [self.tableView insertRowsAtIndexPaths:@[indexPath]
                          withRowAnimation:UITableViewRowAnimationTop];
    
}


- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // if the table view is asking to commit a delete command
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSArray *items = [[MCItemStore sharedStore] allItems];
        MCItem *item = items[indexPath.row];
        [[MCItemStore sharedStore] removeItem:item];
     
        // also remove that row from the table view with an animation
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
    
}

- (void)tableView:(UITableView *)tableView
    moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath
      toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    [[MCItemStore sharedStore] moveItemAtIndex:sourceIndexPath.row toIndex:destinationIndexPath.row];
}

# pragma mark -NavController

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MCDetailViewController *detailViewController = [[MCDetailViewController alloc] init];
    
    NSArray *items = [[MCItemStore sharedStore] allItems];
    MCItem *selectedItem = items[indexPath.row];
    
    // give detail view controller a pointer to the itme object in row
    detailViewController.item = selectedItem;
    
    // push it onto the top of the navigation controller's stack
    [self.navigationController pushViewController:detailViewController animated:YES];
    
}

# pragma mark -ViewWillAppear

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    // reload did will view appears again
    [self.tableView reloadData];
}


@end













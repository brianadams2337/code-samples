//
//  vcMaintRequestsRequestList.m
//  MaintenanceRequestsBBB
//
//  Created by Brian Adams on 6/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "adUniversal.h"
#import "ViewController.h"
#import "vcMaintRequestsProgramList.h"
#import "vcMaintRequestsRequestList.h"
#import "vcMaintRequestsIndividual.h"
#import "vcMaintRequestsFormRequest.h"

@interface vcMaintRequestsRequestList ()

@end

@implementation vcMaintRequestsRequestList

@synthesize tableReload;
@synthesize searchBarInput;

@synthesize keysCellSorted;

@synthesize activityIndicator;

@synthesize footer;
@synthesize btnOpenClose;

@synthesize filterSetting;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // ACTIVITY INDICATOR
    activityIndicator = [adUniversal loadActivityIndicator:@"Loading Maintenance Requests..."];
    [self.view addSubview: activityIndicator];
    [self.view bringSubviewToFront: activityIndicator];
    
    // NAVIGATION BAR
    
    // Set Title of Nav Bar to current program
    [self setTitle:@"Maintenance Requests"];
    
    // Add Buttons to Nav Bar (add)
    UIBarButtonItem *addRequest = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addMaintRequest)];
    [[self navigationItem] setRightBarButtonItem:addRequest];
    addRequest.enabled = TRUE;
    
    // TOOLBAR
    CGRect frFooter = CGRectMake(0, 372, 320, 44);
    footer = [[UIToolbar alloc] initWithFrame:frFooter];
    [footer setBarStyle:UIBarStyleBlack];
    [self.view addSubview:footer];
    [self.view bringSubviewToFront:footer];
    
    NSArray *arrayOpenClosed = [NSArray arrayWithObjects:@"Open", @"Closed", nil];
    CGRect frBtnOpenClose = CGRectMake(60, 7, 200, 30);
    btnOpenClose = [[UISegmentedControl alloc] initWithItems:arrayOpenClosed];
    [btnOpenClose setFrame:frBtnOpenClose];
    [btnOpenClose setSegmentedControlStyle:UISegmentedControlStyleBar];
    [btnOpenClose setTintColor:[UIColor darkGrayColor]];
    [btnOpenClose setSelectedSegmentIndex:0];
    [btnOpenClose setEnabled:YES];
    [btnOpenClose addTarget:self action:@selector(filterRequests:) forControlEvents:UIControlEventValueChanged];
    [footer addSubview:btnOpenClose];
    [footer bringSubviewToFront:btnOpenClose];
    
    // LOAD TABLE AND DATA
    CGRect frTable = CGRectMake(0, 0, 320, 328);
    [tableReload setFrame:frTable];
    [self viewDidAppear:YES];
    CGRect frTableScrolled = CGRectMake(0, 50, 320, 328);
    [tableReload scrollRectToVisible:frTableScrolled animated:NO];
    
    // SEARCH BAR
    CGRect frSearchBar = CGRectMake(0, 0, 320, 50);
    searchBarInput = [[UISearchBar alloc] initWithFrame:frSearchBar];
    [searchBarInput setBarStyle:UIBarStyleBlack];
    [searchBarInput setShowsCancelButton:TRUE animated:TRUE];
    [searchBarInput setDelegate:self];
    [tableReload setTableHeaderView:searchBarInput];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    // DATA
    
    // get array of sorted requests
    adUniversal *universal = (adUniversal *)[[UIApplication sharedApplication] delegate];
    
    NSPredicate *predOpen = [NSPredicate predicateWithFormat:@"completeStatus == %@", @"Open"];
    NSPredicate *predClosed = [NSPredicate predicateWithFormat:@"completeStatus == %@", @"Closed"];
    
    NSArray *keys = [[universal.currentDictMaintRequests objectForKey:universal.selectedProgram] allKeys];

    keysCellSorted = [[NSMutableArray alloc] init];
    for (int i = 0; i < [keys count]; i++) {
        [keysCellSorted addObject:[[universal.currentDictMaintRequests objectForKey:universal.selectedProgram] objectForKey:[keys objectAtIndex:i]]];
    }
    // sort by numDays
    NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:@"numDays" ascending:NO];
    [keysCellSorted sortUsingDescriptors:[NSMutableArray arrayWithObject:sorter]];
    if (filterSetting == 0)
    {
        [keysCellSorted filterUsingPredicate:predOpen];
    } else if (filterSetting == 1) {
        [keysCellSorted filterUsingPredicate:predClosed];
    }
    // RELOAD TABLE
    
    [tableReload reloadData];
    
    // HIDE ACTIVITY INDICATOR
    
    [activityIndicator setHidden:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return number of rows in section
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return number of rows in section
    return [keysCellSorted count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];

    // Configure the cell
    NSArray *tmp = [keysCellSorted objectAtIndex:[indexPath row]];
    // address
    CGRect frCellAddressLabel = CGRectMake(15, 6, 200, 16);
    UILabel *cellAddressLabel = [[UILabel alloc] initWithFrame:frCellAddressLabel];
    NSString *address = [NSString stringWithFormat:@"%@ %@",[tmp valueForKey:@"streetnum"],[tmp valueForKey:@"address"]];
    [cellAddressLabel setText:address];
    [cellAddressLabel setFont:[UIFont fontWithName:@"OpenSans-Bold" size:14]];
    [cellAddressLabel setTextColor:[UIColor blackColor]];
    [cellAddressLabel setAdjustsFontSizeToFitWidth:TRUE];
    [cellAddressLabel setMinimumFontSize:10];
    [cell addSubview:cellAddressLabel];
    [cell bringSubviewToFront:cellAddressLabel];
    
    // maintenance type
    CGRect frCellTypeLabel = CGRectMake(cellAddressLabel.frame.origin.x, [cellAddressLabel bounds].size.height + cellAddressLabel.frame.origin.y, 200, 15);
    UILabel *cellTypeLabel = [[UILabel alloc] initWithFrame:frCellTypeLabel];
    NSString *typeName = [NSString stringWithString:[tmp valueForKey:@"type_name"]];
    [cellTypeLabel setText:typeName];
    [cellTypeLabel setFont:[UIFont fontWithName:@"OpenSans" size:12]];
    [cellTypeLabel setTextColor:[UIColor blackColor]];
    [cellTypeLabel setAdjustsFontSizeToFitWidth:TRUE];
    [cellTypeLabel setMinimumFontSize:10];
    [cell addSubview:cellTypeLabel];
    [cell bringSubviewToFront:cellTypeLabel];
    
    // number of days
    CGRect frCellDaysLabel = CGRectMake(215, 13, 90, 16);
    UILabel *cellDaysLabel = [[UILabel alloc] initWithFrame:frCellDaysLabel];
    NSString *numberDays = [NSString stringWithFormat:@"%@ Days", [tmp valueForKey:@"numDays"]];
    [cellDaysLabel setText:numberDays];
    [cellDaysLabel setFont:[UIFont fontWithName:@"OpenSans-Bold" size:14]];
    [cellDaysLabel setTextColor:[UIColor blackColor]];
    [cellDaysLabel setAdjustsFontSizeToFitWidth:TRUE];
    [cellDaysLabel setMinimumFontSize:10];
    [cell addSubview:cellDaysLabel];
    [cell bringSubviewToFront:cellDaysLabel];
    
    NSString *completeStatus = [NSString stringWithString:[tmp valueForKey:@"completeStatus"]];
    if ([completeStatus isEqualToString:@"Open"]) {
        [cell setTag:0];
    } else {
        [cell setTag:1];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    adUniversal *universal = (adUniversal *)[[UIApplication sharedApplication] delegate];
    universal.selectedProgramItem = [[keysCellSorted objectAtIndex:row] valueForKey:@"req_id"];
    UIViewController *maintenanceRequestIndividual = [[vcMaintRequestsIndividual alloc]initWithNibName:@"vcMaintRequestsIndividual"bundle:nil];
    [[self navigationController] pushViewController:maintenanceRequestIndividual animated:YES];
}

- (void)addMaintRequest
{
    UIViewController *maintRequestForm = [[vcMaintRequestsFormRequest alloc]initWithNibName:@"vcMaintRequestsFormRequest"bundle:nil];
    [[self navigationController] pushViewController:maintRequestForm animated:YES];
}

- (IBAction)logout:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)filterRequests:(UISegmentedControl*)sender
{
    switch (btnOpenClose.selectedSegmentIndex) {
        case 0:
            filterSetting = 0;
            [self viewDidAppear:YES];
            break;
        case 1:
            filterSetting = 1;
            [self viewDidAppear:YES];
            break;
        default:
            break;
    }
    [tableReload scrollRectToVisible:CGRectMake(0, 50, 320, 370) animated:YES];
    [searchBarInput setText:@""];
    [searchBarInput resignFirstResponder];
}

- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    adUniversal *universal = (adUniversal *)[[UIApplication sharedApplication] delegate];
    
    NSPredicate *predOpen = [NSPredicate predicateWithFormat:@"completeStatus == %@", @"Open"];
    NSPredicate *predClosed = [NSPredicate predicateWithFormat:@"completeStatus == %@", @"Closed"];
    
    keysCellSorted = [[NSMutableArray alloc] init];
    
    if (searchText.length != 0)
    {
        for (id key in [universal.currentDictMaintRequests objectForKey:universal.selectedProgram])
        {
            NSMutableString *tmp = [[NSMutableString alloc] init];
            [tmp appendString:[[[universal.currentDictMaintRequests objectForKey:universal.selectedProgram] objectForKey:key] objectForKey:@"streetnum"]];
            [tmp appendString:@" "];
            [tmp appendString:[[[universal.currentDictMaintRequests objectForKey:universal.selectedProgram] objectForKey:key] objectForKey:@"address"]];
            [tmp appendString:[[[universal.currentDictMaintRequests objectForKey:universal.selectedProgram] objectForKey:key] objectForKey:@"type_name"]];
            [tmp appendString:[[[universal.currentDictMaintRequests objectForKey:universal.selectedProgram] objectForKey:key] objectForKey:@"info"]];
            [tmp appendString:[[[universal.currentDictMaintRequests objectForKey:universal.selectedProgram] objectForKey:key] objectForKey:@"description"]];
            NSRange rangeSearch = [tmp rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if(rangeSearch.location != NSNotFound)
            {
                [keysCellSorted addObject:[[universal.currentDictMaintRequests objectForKey:universal.selectedProgram] objectForKey:key]];
            }
        }
    }
    else {
        NSArray *keys = [[universal.currentDictMaintRequests objectForKey:universal.selectedProgram] allKeys];
        for (int i = 0; i < [keys count]; i++) {
            [keysCellSorted addObject:[[universal.currentDictMaintRequests objectForKey:universal.selectedProgram] objectForKey:[keys objectAtIndex:i]]];
        }
    }
    
    // sort by numDays
    NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:@"numDays" ascending:NO];
    [keysCellSorted sortUsingDescriptors:[NSMutableArray arrayWithObject:sorter]];
    if (filterSetting == 0)
    {
        [keysCellSorted filterUsingPredicate:predOpen];
    } else if (filterSetting == 1) {
        [keysCellSorted filterUsingPredicate:predClosed];
    }
    // RELOAD TABLE
    
    [tableReload reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBarInput resignFirstResponder];
    // Do the search...
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [tableReload scrollRectToVisible:CGRectMake(0, 50, 320, 370) animated:YES];
    [searchBarInput setText:@""];
    [searchBarInput resignFirstResponder];
}

@end

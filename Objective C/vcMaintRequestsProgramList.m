//
//  vcMaintRequestsProgramList.m
//  MaintenanceRequestsBBB
//
//  Created by Brian Adams on 6/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "adUniversal.h"
#import "ViewController.h"
#import "vcMaintRequestsProgramList.h"
#import "vcMaintRequestsRequestList.h"

@interface vcMaintRequestsProgramList ()

@end

@implementation vcMaintRequestsProgramList

@synthesize tablePrograms;
@synthesize keysCellsSorted;
@synthesize activityIndicator;

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
    activityIndicator = [adUniversal loadActivityIndicator:@"Loading Programs..."];
    [self.view addSubview: activityIndicator];
    [self.view bringSubviewToFront: activityIndicator];
    
    // Needed to acces global variables
    adUniversal *universal = (adUniversal *)[[UIApplication sharedApplication] delegate];
    
    // download current dictionary
    universal.currentDictMaintRequests = [adUniversal downloadCurrentDict :universal.email :universal.password :@"maintReports"];
    
    // NAVIGATION BAR
    
    // Set Title in Nav Bar
    [self setTitle:@"Programs"];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
    // Hide Back Button - this is done so it can be replaced with Cancel Button
/*    [self.navigationItem setHidesBackButton:FALSE];
    
    UIBarButtonItem *homeButtom = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    [self.navigationItem setLeftBarButtonItem:homeButtom];
*/
    // TOOLBAR FOR ENTIRE NAVIGATION CONTROLLER
    /*
    CGRect frToolbar = CGRectMake(0, 372, 320, 44);
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:frToolbar];
    [self.view addSubview:toolbar];
    [self.view bringSubviewToFront:toolbar];
    [toolbar setBarStyle:UIBarStyleBlack];
    //[toolbar removeFromSuperview];
    
    // toolbar buttons
    UIBarButtonItem *btnRefresh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshView)];
    NSMutableArray *newItems = [NSMutableArray arrayWithObjects:btnRefresh, nil];
    [toolbar setItems:newItems animated:NO];
    btnRefresh.enabled = TRUE;
    
    // toolbar timestamp
    CGRect frTimestamp = CGRectMake(44, 13, 232, 14);
    UILabel *timestamp = [[UILabel alloc] initWithFrame:frTimestamp];
    [timestamp setBackgroundColor:[UIColor clearColor]];
    [timestamp setTextColor:[UIColor whiteColor]];
    [timestamp setTextAlignment:UITextAlignmentCenter];
    [timestamp setFont:[UIFont fontWithName:@"OpenSans-Bold" size:11]];
        
    NSDate *selectedDate = [NSDate date];
    NSDateFormatter *dateToFormat = [[NSDateFormatter alloc] init];
    [dateToFormat setDateFormat:@"EEE MMM dd, HH:mm:ss"];
    NSString *formattedDate = [dateToFormat stringFromDate:selectedDate];
    [timestamp setText:[NSString stringWithFormat:@"Last Updated: %@",formattedDate]];
    
    [toolbar addSubview:timestamp];
     
    [tablePrograms setFrame:CGRectMake(0, 0, 320, 372)];
    */

    // LOAD DATA AND TABLE
    [self viewDidAppear:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    // Needed to acces global variables
    adUniversal *universal = (adUniversal *)[[UIApplication sharedApplication] delegate];
    
    // SORTED ARRAY OF PROGRAMS
    NSArray *keys = [universal.userProgramsDict allValues];
    keysCellsSorted = [keys sortedArrayUsingComparator:^(id firstObject, id secondObject) {
        return [((NSString *)firstObject) compare:((NSString *)secondObject) options:NSNumericSearch];
    }];
    
    // RELOAD TABLE
    [tablePrograms reloadData];
    
    // HIDE ACTIVITY INDICATOR
    [activityIndicator setHidden:YES];
}

-(void)viewWillAppear:(BOOL)animated
{

}

- (void)viewWillDisappear:(BOOL)animated
{

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return number of sections in table
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return number of rows in section
    adUniversal *universal = (adUniversal *)[[UIApplication sharedApplication] delegate];
    return [universal.userProgramsDict count];
    
    //[universal.userProgramsDict allKeysForObject:[keysCellsSorted objectAtIndex:indexPath.row]]
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    // Configure the cell
    adUniversal *universal = (adUniversal *)[[UIApplication sharedApplication] delegate];
    cell.textLabel.text = [keysCellsSorted objectAtIndex:indexPath.row];
    [cell.textLabel setFont:[UIFont fontWithName:@"OpenSans-Bold" size:16]];
    [cell.textLabel setTextColor:[UIColor blackColor]];
    [cell.textLabel setAdjustsFontSizeToFitWidth:FALSE];
    [cell.textLabel setMinimumFontSize:10];
    NSString *tmpProg = [[NSString alloc] initWithFormat:@"%@", [[universal.userProgramsDict allKeysForObject:[keysCellsSorted objectAtIndex:indexPath.row]] objectAtIndex:0]];
    if (![[[universal.userDict objectForKey:@"programs"] objectForKey:tmpProg] objectForKey:@"maintenanceTypes"] || [[[[universal.userDict objectForKey:@"programs"] objectForKey:tmpProg] objectForKey:@"maintenanceTypes"] count] == 0 || ![[[universal.userDict objectForKey:@"programs"] objectForKey:tmpProg] objectForKey:@"maintenanceDepartments"] || [[[[universal.userDict objectForKey:@"programs"] objectForKey:tmpProg] objectForKey:@"maintenanceDepartments"] count] == 0)
    {
        cell.userInteractionEnabled = NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.enabled = NO;
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        cell.userInteractionEnabled = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.textLabel.enabled = YES;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    [cell setTag:[tmpProg intValue]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    adUniversal *universal = (adUniversal *)[[UIApplication sharedApplication] delegate];
    universal.selectedProgram = [[NSString alloc] initWithFormat:@"%i", [tablePrograms cellForRowAtIndexPath:indexPath].tag];
    UIViewController *maintenanceRequestList = [[vcMaintRequestsRequestList alloc]initWithNibName:@"vcMaintRequestsRequestList"bundle:nil];
    [[self navigationController] pushViewController:maintenanceRequestList animated:YES];
}

- (void) refreshView
{
    [activityIndicator setHidden:NO];

    adUniversal *universal = (adUniversal *)[[UIApplication sharedApplication] delegate];
    [adUniversal uploadChangesMaintRequests:universal.localDictMaintRequests :FALSE];
    [adUniversal downloadCurrentDict:universal.email :universal.password :@"maintReports"];
    [tablePrograms reloadData];
    
    [activityIndicator removeFromSuperview];
}

@end

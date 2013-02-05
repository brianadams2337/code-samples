//
//  vcMaintRequestsPicker.m
//  MaintenanceRequestsBBB
//
//  Created by Brian Adams on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "adUniversal.h"
#import "vcMaintRequestsPicker.h"
#import "vcMaintRequestsFormRequest.h"

@interface vcMaintRequestsPicker ()

@end

@implementation vcMaintRequestsPicker

@synthesize tableToLoad;
@synthesize tablePicker;
@synthesize keys;
@synthesize optionsDict;

@synthesize selector;
@synthesize target;
@synthesize selectedRow;
@synthesize fieldTag;
@synthesize progID;
@synthesize pickedValue;
@synthesize pickedID;

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
    activityIndicator = [adUniversal loadActivityIndicator:@"Loading Options..."];
    [self.view addSubview: activityIndicator];
    [self.view bringSubviewToFront: activityIndicator];
    
    // NAVIGATION BAR
    
    // Set Title in Nav Bar
    [self setTitle:@"Pick"];
    
    // Hide Back Button - this is done so it can be replaced with Cancel Button
    [self.navigationItem setHidesBackButton:FALSE];
    
    // Nav Bar Buttons (done, cancel)
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(goBack)];
    [self.navigationItem setLeftBarButtonItem:leftBarButton];
    UIBarButtonItem *setPicked = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(setPickedOption:)];
    [[self navigationItem] setRightBarButtonItem:setPicked];
    
    // TABLE VIEW
    
    CGRect frTable = CGRectMake(0, 0, 320, 480);
    tablePicker = [[UITableView alloc] initWithFrame:frTable style:UITableViewStyleGrouped];
    tablePicker.autoresizingMask =  UIViewAutoresizingFlexibleHeight;
    tablePicker.backgroundColor = [UIColor clearColor];
    tablePicker.backgroundView = nil;
    tablePicker.delegate = self;
    tablePicker.dataSource = self;
    [self.view addSubview:tablePicker];
    
    // RELAOD TABLE
    
    [tablePicker reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    // HIDE ACTIVITY INDICATOR
    
    [activityIndicator setHidden:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)goBack
{
    [[self navigationController] popViewControllerAnimated:YES];
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
    if (tableToLoad == @"prog_name")
    {
        return [[universal.userDict objectForKey:@"programs"] count];
    } 
    else if (tableToLoad == @"type_name")
    {
        return [[[[universal.userDict objectForKey:@"programs"] objectForKey:universal.selectedProgram] objectForKey:@"maintenanceTypes"] count];
    }
    else if (tableToLoad == @"dep_name")
    {
        return [[[[universal.userDict objectForKey:@"programs"] objectForKey:universal.selectedProgram] objectForKey:@"maintenanceDepartments"] count];
    }
    else
    {
        return YES;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    // Configure the cell
    adUniversal *universal = (adUniversal *)[[UIApplication sharedApplication] delegate];
    if (tableToLoad == @"prog_name")
    {
        keys = [universal.userProgramsDict allValues];
        NSArray *keysSorted = [keys sortedArrayUsingComparator:^(id firstObject, id secondObject) {
            return [((NSString *)firstObject) compare:((NSString *)secondObject) options:NSNumericSearch];
        }];
        
        optionsDict = universal.userProgramsDict;
        
        cell.textLabel.text = [keysSorted objectAtIndex:indexPath.row];
        [cell setTag:[[[optionsDict allKeysForObject:[keysSorted objectAtIndex:indexPath.row]] objectAtIndex:0] intValue]];
        
        if (![[[universal.userDict objectForKey:@"programs"] objectForKey:[keys objectAtIndex:indexPath.row]] objectForKey:@"maintenanceTypes"] || [[[[universal.userDict objectForKey:@"programs"] objectForKey:[keys objectAtIndex:indexPath.row]] objectForKey:@"maintenanceTypes"] count] == 0 || ![[[universal.userDict objectForKey:@"programs"] objectForKey:[keys objectAtIndex:indexPath.row]] objectForKey:@"maintenanceDepartments"] || [[[[universal.userDict objectForKey:@"programs"] objectForKey:[keys objectAtIndex:indexPath.row]] objectForKey:@"maintenanceDepartments"] count] == 0)
        {
            cell.userInteractionEnabled = NO;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.enabled = NO;
        } else {
            cell.userInteractionEnabled = YES;
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            cell.textLabel.enabled = YES;
        }
    } 
    else if (tableToLoad == @"type_name")
    {
        keys = [[[[universal.userDict objectForKey:@"programs"] objectForKey:[NSString stringWithFormat:@"%i", progID]] objectForKey:@"maintenanceTypes"] allValues];
        NSArray *keysSorted = [keys sortedArrayUsingComparator:^(id firstObject, id secondObject) {
            return [((NSString *)firstObject) compare:((NSString *)secondObject) options:NSNumericSearch];
        }];
        
        optionsDict = [[[universal.userDict objectForKey:@"programs"] objectForKey:[NSString stringWithFormat:@"%i", progID]] objectForKey:@"maintenanceTypes"];
        cell.textLabel.text = [keysSorted objectAtIndex:indexPath.row];
        [cell setTag:[[[optionsDict allKeysForObject:[keysSorted objectAtIndex:indexPath.row]] objectAtIndex:0] intValue]];
        
        if (cell.tag == selectedRow)
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    else if (tableToLoad == @"dep_name")
    {
        keys = [[[[universal.userDict objectForKey:@"programs"] objectForKey:[NSString stringWithFormat:@"%i", progID]] objectForKey:@"maintenanceDepartments"] allValues];
        NSArray *keysSorted = [keys sortedArrayUsingComparator:^(id firstObject, id secondObject) {
            return [((NSString *)firstObject) compare:((NSString *)secondObject) options:NSNumericSearch];
        }];
        
        optionsDict = [[[universal.userDict objectForKey:@"programs"] objectForKey:[NSString stringWithFormat:@"%i", progID]] objectForKey:@"maintenanceDepartments"];
        cell.textLabel.text = [keysSorted objectAtIndex:indexPath.row];
        [cell setTag:[[[optionsDict allKeysForObject:[keysSorted objectAtIndex:indexPath.row]] objectAtIndex:0] intValue]];
        
        if (cell.tag == selectedRow)
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    /*
    // add double tap to select option
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setPickedOption:)];
    doubleTap.numberOfTapsRequired = 2;
    [cell addGestureRecognizer:doubleTap];
    */
    // check selected cell
    if (cell.tag == selectedRow)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else 
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    adUniversal *universal = (adUniversal *)[[UIApplication sharedApplication] delegate];
    NSIndexPath *pathOld = [NSIndexPath indexPathForRow:[keys indexOfObject:[NSString stringWithFormat:@"%i", selectedRow]] inSection:0];
    UITableViewCell *cellOld = [[self tablePicker] cellForRowAtIndexPath:pathOld];
    UITableViewCell *cellNew = [[self tablePicker] cellForRowAtIndexPath:indexPath];
    cellOld.accessoryType = UITableViewCellAccessoryNone;
    cellNew.accessoryType = UITableViewCellAccessoryCheckmark;
    selectedRow = cellNew.tag;
    if (tableToLoad == @"prog_name")
    {
        universal.selectedProgram = [[NSString alloc] initWithFormat:@"%i", selectedRow];
    }
    pickedValue = cellNew.textLabel.text;
    pickedID = [NSString stringWithFormat:@"%i", cellNew.tag];
    [self setPickedOption:self];
}

- (IBAction)setPickedOption:(id)sender
{
    NSMethodSignature *signature = [target methodSignatureForSelector:selector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:target];
    [invocation setSelector:selector];
    NSMutableString *arg1 = [NSMutableString stringWithFormat:@"%i", fieldTag]; 
    [invocation setArgument:&arg1 atIndex:2];
    if ((pickedID) && !(pickedID == @""))
    {
        [invocation setArgument:&pickedValue atIndex:3];
        [invocation setArgument:&pickedID atIndex:4];
    }
    [invocation invoke];

    [[self navigationController] popViewControllerAnimated:YES];    
}

@end

//
//  vcMaintRequestsIndividual.m
//  MaintenanceRequestsBBB
//
//  Created by Brian Adams on 6/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "adUniversal.h"
#import "ViewController.h"
#import "vcMaintRequestsProgramList.h"
#import "vcMaintRequestsIndividual.h"
#import "PhotoViewController.h"
#import "vcMaintRequestsFormRequest.h"
#import "vcMaintRequestsFormComment.h"


@interface vcMaintRequestsIndividual ()

@end

@implementation vcMaintRequestsIndividual

@synthesize progText;
@synthesize typeText;
@synthesize daysLabel;
@synthesize daysText;
@synthesize dateLabel;
@synthesize dateText;
@synthesize depLabel;
@synthesize depText;
@synthesize locationLabel;
@synthesize locationText;
@synthesize infoText;
@synthesize descriptionLabel;
@synthesize messageLabel;

@synthesize descriptionText;

@synthesize scroll;
@synthesize mainView;
@synthesize imageGrid;
@synthesize messageView;

@synthesize req_id;
@synthesize streetnum;
@synthesize address;
@synthesize info;
@synthesize description;
@synthesize completeStatus;
@synthesize numDays;
@synthesize date;
@synthesize dep_name;
@synthesize type_name;
@synthesize prog_name;

@synthesize imgDict;
@synthesize messageDict;

@synthesize addCommentButton;
@synthesize updateStatusButton;

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
    
    // INITIALIZE VARIABLES
    
    progText = [[UILabel alloc] init];
    typeText = [[UILabel alloc] init];
    daysLabel = [[UILabel alloc] init];
    daysText = [[UILabel alloc] init];
    dateLabel = [[UILabel alloc] init];
    dateText = [[UILabel alloc] init];
    depLabel = [[UILabel alloc] init];
    depText = [[UILabel alloc] init];
    locationLabel = [[UILabel alloc] init];
    locationText = [[UILabel alloc] init];
    infoText = [[UILabel alloc] init];
    descriptionLabel = [[UILabel alloc] init];
    messageLabel = [[UILabel alloc] init];
    
    descriptionText = [[UITextView alloc] init];
    
    scroll = [[UIScrollView alloc] init];
    mainView = [[UIView alloc] init];
    imageGrid = [[UIView alloc] init];
    messageView = [[UIView alloc] init];
    
    imgDict = [[NSMutableDictionary alloc] init];
    messageDict = [[NSMutableDictionary alloc] init];
    
    addCommentButton = [[UIButton alloc] init];
    updateStatusButton = [[UIButton alloc] init];
    
    // NAV BAR
    // nav bar title
    [self setTitle:[NSString stringWithFormat:@"View Request"]];
    
    // CREATE SCROLL VIEW
    // scroll view to hold main view
    CGRect frScroll = CGRectMake(0, 0, 320, 420);
    [scroll setFrame:frScroll];
    [scroll setScrollEnabled:YES];
    [self.view addSubview:scroll];
    [self.view bringSubviewToFront:scroll];
    // view to hold request within scroll view
    [mainView setFrame:frScroll];
    [scroll addSubview:mainView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    // ACTIVITY INDICATOR
    [self showUploadIndicator:self];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    adUniversal *universal = (adUniversal *)[[UIApplication sharedApplication] delegate];

    // VARIABLES
    // unique id
    req_id = [[NSString alloc] initWithString:[[[universal.currentDictMaintRequests objectForKey:universal.selectedProgram] objectForKey:universal.selectedProgramItem] valueForKey:@"req_id"]];
    // street address - number
    streetnum = [[NSString alloc] initWithString:[[[universal.currentDictMaintRequests objectForKey:universal.selectedProgram] objectForKey:universal.selectedProgramItem] valueForKey:@"streetnum"]];
    // street address - name
    address = [[NSString alloc] initWithString:[[[universal.currentDictMaintRequests objectForKey:universal.selectedProgram] objectForKey:universal.selectedProgramItem] valueForKey:@"address"]];
    // additional info about address
    info = [[NSString alloc] initWithString:[[[universal.currentDictMaintRequests objectForKey:universal.selectedProgram] objectForKey:universal.selectedProgramItem] valueForKey:@"info"]];
    // description of request
    description = [[NSString alloc] initWithString:[[[universal.currentDictMaintRequests objectForKey:universal.selectedProgram] objectForKey:universal.selectedProgramItem] valueForKey:@"description"]];
    // completetion status of request
    completeStatus = [[NSString alloc] initWithString:[[[universal.currentDictMaintRequests objectForKey:universal.selectedProgram] objectForKey:universal.selectedProgramItem] valueForKey:@"completeStatus"]];
    // number of days request has been open
    numDays = [[NSString alloc] initWithFormat:@"%@", [[[universal.currentDictMaintRequests objectForKey:universal.selectedProgram] objectForKey:universal.selectedProgramItem] valueForKey:@"numDays"]];
    // request date
    date = [[NSString alloc] initWithFormat:@"%@", [[[universal.currentDictMaintRequests objectForKey:universal.selectedProgram] objectForKey:universal.selectedProgramItem] valueForKey:@"date"]];
    // department name
    dep_name = [[NSString alloc] initWithString:[[[universal.currentDictMaintRequests objectForKey:universal.selectedProgram] objectForKey:universal.selectedProgramItem] valueForKey:@"dep_name"]];
    // maintenance type
    type_name = [[NSString alloc] initWithString:[[[universal.currentDictMaintRequests objectForKey:universal.selectedProgram] objectForKey:universal.selectedProgramItem] valueForKey:@"type_name"]];
    // program name
    prog_name = [[NSString alloc] initWithString:[[[universal.currentDictMaintRequests objectForKey:universal.selectedProgram] objectForKey:universal.selectedProgramItem] valueForKey:@"prog_name"]];
    
    // dictionary to hold images for the request, not the message images
    imgDict = [[NSMutableDictionary alloc] init];
    int imgCount = [[[[universal.currentDictMaintRequests objectForKey:universal.selectedProgram] objectForKey:universal.selectedProgramItem] objectForKey:@"images"] count];
    if (!(imgCount == 0))
    {
        NSMutableDictionary *galleryImgDict = [[NSMutableDictionary alloc] init];
        NSArray *keys = [[[[universal.currentDictMaintRequests objectForKey:universal.selectedProgram] objectForKey:universal.selectedProgramItem] objectForKey:@"images"] allKeys];
        NSArray *keysSorted = [keys sortedArrayUsingComparator:^(id firstObject, id secondObject) {
            return [((NSString *)firstObject) compare:((NSString *)secondObject) options:NSNumericSearch];
        }];
        
        for (int i = 0; i < imgCount; i++) {
            NSString *key = [[NSString alloc] initWithFormat:@"%i", i];
            NSMutableDictionary *tmp = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                        @"request", @"type",
                                        [[[[[universal.currentDictMaintRequests objectForKey:universal.selectedProgram] objectForKey:universal.selectedProgramItem] objectForKey:@"images"] objectForKey:[keysSorted objectAtIndex:i]] objectForKey:@"150"], @"pathThumb",
                                        [[[[[universal.currentDictMaintRequests objectForKey:universal.selectedProgram] objectForKey:universal.selectedProgramItem] objectForKey:@"images"] objectForKey:[keysSorted objectAtIndex:i]] objectForKey:@"600"], @"pathFull",
                                        nil];
            [galleryImgDict setObject:tmp forKey:key];
        }
        [imgDict setObject:galleryImgDict forKey:@"gallery"];
    }
    
    // dictionary to hold any messages for the request
    if (!([[[[universal.currentDictMaintRequests objectForKey:universal.selectedProgram] objectForKey:universal.selectedProgramItem] objectForKey:@"messages"] count] == 0))
    {
        messageDict = [[[universal.currentDictMaintRequests objectForKey:universal.selectedProgram] objectForKey:universal.selectedProgramItem] objectForKey:@"messages"];
    }
    
    // LOAD THE REQUEST INTO THE VIEW
    [self loadRequest];
    
    // NAV BAR EDIT BUTTON
    // this is doen in appear instead of load so it updates with the request status
    UIBarButtonItem *btnEdit = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editMaintRequest)];
    if ([[[NSString alloc] initWithString:[[[universal.currentDictMaintRequests objectForKey:universal.selectedProgram] objectForKey:universal.selectedProgramItem] valueForKey:@"completeStatus"]] isEqualToString:@"Open"])
    {
        [[self navigationItem] setRightBarButtonItem:btnEdit];
    } else {
        [[self navigationItem] setRightBarButtonItem:nil];
    }

    // HIDE ACTIVITY INDICATOR
    [activityIndicator setHidden:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

// GALLERY
- (IBAction)openImage:(id)sender
{
    PhotoViewController *imageGallery = [[PhotoViewController alloc]initWithNibName:@"PhotoViewController" bundle:nil];
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    NSMutableArray *tmp = [[NSMutableArray alloc] init];
    NSSortDescriptor *sorter = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES];

    if ([sender currentTitle] == @"gallery") {
        [keys setArray:[[imgDict objectForKey:@"gallery"] allKeys]];
        [keys sortUsingDescriptors:[NSMutableArray arrayWithObject:sorter]];
        for (int i = 0; i < [[imgDict objectForKey:@"gallery"] count]; i++) {
            [tmp addObject:[[[imgDict objectForKey:@"gallery"] objectForKey:[keys objectAtIndex:i]] objectForKey:@"pathFull"]];
        }
    } else {
        NSString *key = [[NSString alloc] initWithFormat:@"m%i", [[[sender superview] superview] tag]];
        [keys setArray:[[imgDict objectForKey:key] allKeys]];
        [keys sortUsingDescriptors:[NSMutableArray arrayWithObject:sorter]];
        for (int i = 0; i < [[imgDict objectForKey:key] count]; i++) {
            [tmp addObject:[[[imgDict objectForKey:key] objectForKey:[keys objectAtIndex:i]] objectForKey:@"pathFull"]];
        }
    }
    imageGallery.imagesArrayURL = tmp;
    imageGallery.selectedPage = [sender tag];
    [[self navigationController] pushViewController:imageGallery animated:YES];
}

// REFRESH
- (IBAction)refreshView
{
    [self viewDidAppear:YES];
}

// SHOW ACTIVITY INDICATOR - FOR NEW MAINTENANCE REQUESTS - this must be done in two methods to show the activity indicator because the upload request is synchronous.
- (IBAction)showUploadIndicator:(id)sender
{
    if (sender == updateStatusButton) {
        activityIndicator = [adUniversal loadActivityIndicator:@"Updating Request Status..."];
        [self performSelector:@selector(updateRequest:) withObject:nil afterDelay:0];
    } else {
        activityIndicator = [adUniversal loadActivityIndicator:@"Loading Maintenance Request..."];
    }
    
    [self.view addSubview: activityIndicator];
    [self.view bringSubviewToFront: activityIndicator];
}
// UPDATE STATUS
- (IBAction)updateRequest:(id)sender
{
    // SHOW ACTIVITY INDICATOR
    [activityIndicator setHidden:NO];
    
    // UPDATE REQUEST
    
    adUniversal *universal = (adUniversal *)[[UIApplication sharedApplication] delegate];
    
    // get current status and date
    NSString *currentStatus = [[NSString alloc] initWithString:[[[universal.currentDictMaintRequests objectForKey:universal.selectedProgram] objectForKey:universal.selectedProgramItem] valueForKey:@"completeStatus"]];
    NSString *completeDate = [[NSString alloc] init];

    // set new status variables
    if ([currentStatus isEqualToString:@"Open"]) {
        // complete request
        currentStatus = @"1";
        // complete date
        NSDate *selectedDate = [NSDate date];
        NSDateFormatter *dateToFormat = [[NSDateFormatter alloc] init];
        [dateToFormat setDateFormat:@"MM-dd-yyyy"];
        NSString *formattedDate = [dateToFormat stringFromDate:selectedDate];
        completeDate = [NSString stringWithString:formattedDate];
    } else {
        currentStatus = @"0";
    }
    
    // create new request and add to the local dictionary
    NSMutableDictionary *newRequest = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       [[[universal.currentDictMaintRequests objectForKey:universal.selectedProgram] objectForKey:universal.selectedProgramItem] valueForKey:@"req_id"], @"req_id",
                                       [universal.userDict valueForKey:@"id"], @"user_id",
                                       currentStatus, @"complete",
                                       completeDate, @"completeDate",
                                       nil];
    [universal.localDictMaintRequests setObject:newRequest forKey:[NSNumber numberWithInt:[universal.localDictMaintRequests count]]];
    
    // upload local dictionary to server synchronously
    [adUniversal uploadChangesMaintRequests:universal.localDictMaintRequests:FALSE];
    
    // update current dictionary to show new request(s) and reload view
    universal.currentDictMaintRequests = [adUniversal downloadCurrentDict :universal.email :universal.password :@"maintReports"];
    
    [self refreshView];
}

- (void)editMaintRequest
{
    adUniversal *universal = (adUniversal *)[[UIApplication sharedApplication] delegate];
    vcMaintRequestsFormRequest *maintRequestForm = [[vcMaintRequestsFormRequest alloc]initWithNibName:@"vcMaintRequestsFormRequest"bundle:nil];
    maintRequestForm.keyToEdit = universal.selectedProgramItem;
    [[self navigationController] pushViewController:maintRequestForm animated:YES];
}

- (void)addComment
{    
    adUniversal *universal = (adUniversal *)[[UIApplication sharedApplication] delegate];
    vcMaintRequestsFormComment *messageForm = [[vcMaintRequestsFormComment alloc]initWithNibName:@"vcMaintRequestsFormComment"bundle:nil];
    messageForm.keyToEdit = universal.selectedProgramItem;
    [[self navigationController] pushViewController:messageForm animated:YES];
}

- (void)loadRequest
{    
    adUniversal *universal = (adUniversal *)[[UIApplication sharedApplication] delegate];
    // PROGRAM
    CGRect frProgText = CGRectMake(15, 15, 290, 20);
    [progText setFrame:frProgText];
    [progText setText:prog_name];
    [progText setFont:[UIFont fontWithName:@"OpenSans-Bold" size:12]];
    [progText setAdjustsFontSizeToFitWidth:TRUE];
    [progText setMinimumFontSize:10];
    [mainView addSubview:progText];
    
    // MAINTENANCE TYPE
    CGRect frTypeText = CGRectMake(15, (progText.frame.size.height + progText.frame.origin.y + 5), 290, 40);
    [typeText setFrame:frTypeText];
    [typeText setText:type_name];
    [typeText setFont:[UIFont fontWithName:@"OpenSans-Bold" size:24]];
    [typeText setAdjustsFontSizeToFitWidth:TRUE];
    [typeText setMinimumFontSize:10];
    [mainView addSubview:typeText];
    
    // NUMBER OF DAYS OPEN
    // label
    CGRect frDaysLabel = CGRectMake(15, (typeText.frame.size.height + typeText.frame.origin.y + 5), 100, 15);
    [daysLabel setFrame:frDaysLabel];
    [daysLabel setText:@"Days Aged"];
    [daysLabel setFont:[UIFont fontWithName:@"OpenSans" size:13]];
    [daysLabel setAdjustsFontSizeToFitWidth:FALSE];
    [daysLabel setMinimumFontSize:10];
    [mainView addSubview:daysLabel];
    // text
    CGRect frDaysText = CGRectMake((daysLabel.frame.size.width + daysLabel.frame.origin.x + 5), (typeText.frame.size.height + typeText.frame.origin.y + 5), 180, 20);
    [daysText setFrame:frDaysText];
    [daysText setText:numDays];
    [daysText setFont:[UIFont fontWithName:@"OpenSans-Bold" size:13]];
    [daysText setAdjustsFontSizeToFitWidth:TRUE];
    [daysText setMinimumFontSize:10];
    [mainView addSubview:daysText];
    
    // REPORTED DATE
    // label
    CGRect frDateLabel = CGRectMake(15, (daysLabel.frame.size.height + daysLabel.frame.origin.y + 5), 100, 15);
    [dateLabel setFrame:frDateLabel];
    [dateLabel setText:@"Date Reported"];
    [dateLabel setFont:[UIFont fontWithName:@"OpenSans" size:13]];
    [dateLabel setAdjustsFontSizeToFitWidth:FALSE];
    [dateLabel setMinimumFontSize:10];
    [mainView addSubview:dateLabel];
    // text
    CGRect frDateText = CGRectMake((dateLabel.frame.size.width + dateLabel.frame.origin.x + 5), (daysLabel.frame.size.height + daysLabel.frame.origin.y + 5), 180, 20);
    [dateText setFrame:frDateText];
    [dateText setText:date];
    [dateText setFont:[UIFont fontWithName:@"OpenSans-Bold" size:13]];
    [dateText setAdjustsFontSizeToFitWidth:TRUE];
    [dateText setMinimumFontSize:10];
    [mainView addSubview:dateText];
    
    // DEPARTMENT
    //label
    CGRect frDepLabel = CGRectMake(15, (dateLabel.frame.size.height + dateLabel.frame.origin.y + 5), 100, 15);
    [depLabel setFrame:frDepLabel];
    [depLabel setText:@"Department"];
    [depLabel setFont:[UIFont fontWithName:@"OpenSans" size:13]];
    [depLabel setAdjustsFontSizeToFitWidth:FALSE];
    [depLabel setMinimumFontSize:10];
    [mainView addSubview:depLabel];
    // text
    CGRect frDepText = CGRectMake((depLabel.frame.size.width + depLabel.frame.origin.x + 5), (dateLabel.frame.size.height + dateLabel.frame.origin.y + 5), 180, 20);
    [depText setFrame:frDepText];
    [depText setText:dep_name];
    [depText setFont:[UIFont fontWithName:@"OpenSans-Bold" size:13]];
    [depText setAdjustsFontSizeToFitWidth:TRUE];
    [depText setMinimumFontSize:10];
    [mainView addSubview:depText];
    
    // LOCATION
    // label
    CGRect frLocationLabel = CGRectMake(15, 155, 280, 15);
    [locationLabel setFrame:frLocationLabel];
    [locationLabel setText:@"Location:"];
    [locationLabel setFont:[UIFont fontWithName:@"OpenSans-Italic" size:12]];
    [locationLabel setTextColor:[UIColor grayColor]];
    [locationLabel setAdjustsFontSizeToFitWidth:TRUE];
    [locationLabel setMinimumFontSize:10];
    [mainView addSubview:locationLabel];
    // text
    CGRect frLocationText = CGRectMake(15, (locationLabel.frame.size.height + locationLabel.frame.origin.y), 280, 25);
    [locationText setFrame:frLocationText];
    [locationText setText:[NSString stringWithFormat:@"%@ %@", streetnum, address]];
    [locationText setFont:[UIFont fontWithName:@"OpenSans-Bold" size:18]];
    [locationText setTextColor:[UIColor blackColor]];
    [locationText setAdjustsFontSizeToFitWidth:TRUE];
    [locationText setMinimumFontSize:10];
    [mainView addSubview:locationText];
    // extra info
    CGRect frInfoText = CGRectMake(15, (locationText.frame.size.height + locationText.frame.origin.y), 280, 0);
    [infoText setFrame:frInfoText];
    [mainView addSubview:infoText];
    if (![info isEqualToString:@""])
    {
        CGRect frInfoText = CGRectMake(15, (locationText.frame.size.height + locationText.frame.origin.y), 280, 18);
        [infoText setFrame:frInfoText];
        [infoText setText:info];
        [infoText setFont:[UIFont fontWithName:@"OpenSans" size:13]];
        [infoText setTextColor:[UIColor blackColor]];
        [infoText setAdjustsFontSizeToFitWidth:TRUE];
        [infoText setMinimumFontSize:10];
    }
    
    // DESCRIPTION
    CGRect frDescriptionLabel = CGRectMake(15, (infoText.frame.size.height + infoText.frame.origin.y + 15), 280, 0);
    [descriptionLabel setFrame:frDescriptionLabel];
    CGRect frDescriptionText = CGRectMake(15, (descriptionLabel.frame.size.height + descriptionLabel.frame.origin.y), 280, 0);
    [descriptionText setFrame:frDescriptionText];
    [mainView addSubview:descriptionLabel];
    [mainView addSubview:descriptionText];
    if (![description isEqualToString:@""])
    {
        description = [adUniversal stripTags:description];
        // label
        CGRect frDescriptionnLabel = CGRectMake(15, (infoText.frame.size.height + infoText.frame.origin.y + 15), 280, 15);
        [descriptionLabel setFrame:frDescriptionnLabel];
        [descriptionLabel setText:@"Description:"];
        [descriptionLabel setFont:[UIFont fontWithName:@"OpenSans-Italic" size:12]];
        [descriptionLabel setTextColor:[UIColor grayColor]];
        [descriptionLabel setAdjustsFontSizeToFitWidth:TRUE];
        [descriptionLabel setMinimumFontSize:10];
        // text
        CGRect frDescriptionText = CGRectMake(15, (descriptionLabel.frame.size.height + descriptionLabel.frame.origin.y), 280, 20);
        [descriptionText setFrame:frDescriptionText];
        [descriptionText setText:description];
        [descriptionText setFont:[UIFont fontWithName:@"OpenSans-Bold" size:14]];
        [descriptionText setTextColor:[UIColor blackColor]];
        // resize view to fit to text
        CGRect fr = descriptionText.frame;
        fr.size.height = [descriptionText contentSize].height;
        descriptionText.frame = fr;
        descriptionText.contentInset = UIEdgeInsetsMake(-4, -8, 0, 0);
        [descriptionText setDelegate:self];
        
    }
    
    // IMAGES
    CGRect frImageGrid = CGRectMake(15, (descriptionText.frame.size.height + descriptionText.frame.origin.y), 290, 0);
    [imageGrid setFrame:frImageGrid];
    [mainView addSubview:imageGrid];
    [mainView bringSubviewToFront:imageGrid];
    
    if ([[imgDict objectForKey:@"gallery"] count] > 0)
    {
        int imgHeight = 71;
        int imgWidth = 71;
        int picsPerRow = 4;
        float imgMargin = 2;
        int rows = (int)ceil((float)[[imgDict objectForKey:@"gallery"] count]/4);
        int imgGridWidth = (int)ceil((float)((imgWidth * picsPerRow) + ((picsPerRow - 1) * imgMargin)));
        int imgGridHeight = (int)ceil((float)(rows * imgHeight));
        CGRect fr = CGRectMake(15, (descriptionText.frame.size.height + descriptionText.frame.origin.y) + 20, imgGridWidth, imgGridHeight);
        [imageGrid setFrame:fr];
        
        NSMutableArray *keys = [[NSMutableArray alloc] initWithArray:[[imgDict objectForKey:@"gallery"] allKeys]];
        NSSortDescriptor *sorter = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES];
        [keys sortUsingDescriptors:[NSMutableArray arrayWithObject:sorter]];

        for (int i = 0; i < rows; i++)
        {
            for (int j = 0; j < picsPerRow; j++)
            {
                if (((i * picsPerRow) + j) < [[imgDict objectForKey:@"gallery"] count])
                {
                    NSString *urlString = [NSString stringWithString:[[[imgDict objectForKey:@"gallery"] objectForKey:[keys objectAtIndex:((i * picsPerRow) + j)]] objectForKey:@"pathThumb"]];
                    NSURL *imageUrl = [NSURL URLWithString: urlString];
                    UIImage *image = [UIImage imageWithData: [NSData dataWithContentsOfURL:imageUrl]];
                    
                    UIButton *imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
                    imageButton.frame = CGRectMake((imgWidth + 2.5) * j, (imgHeight + 2.5) * i, imgWidth, imgHeight);
                    [imageButton setImage:image forState:UIControlStateNormal];
                    [imageButton setTag:((i * picsPerRow) + j)];
                    [imageButton setTitle:@"gallery" forState:UIControlStateNormal];
                    [imageGrid addSubview:imageButton];
                    
                    [imageButton addTarget:self action:@selector(openImage:) forControlEvents:UIControlEventTouchDown];
                }
            }
        }
    }
    
    // MESSAGES
    CGRect frMessageView = CGRectMake(15, (imageGrid.frame.size.height + imageGrid.frame.origin.y + 20), 290, 0);
    [messageView setFrame:frMessageView];
    [mainView addSubview:messageView];
    [mainView bringSubviewToFront:messageView];
    NSArray *keys = [messageDict allKeys];
    NSArray *keysSorted = [keys sortedArrayUsingComparator:^(id firstObject, id secondObject) {
        return [((NSString *)firstObject) compare:((NSString *)secondObject) options:NSNumericSearch];
    }];
    if ([messageDict count] > 0)
    {
        CGRect frMessageLabel = CGRectMake(0, 0, 290, 20);
        [messageLabel setFrame:frMessageLabel];
        [messageView addSubview:messageLabel];
        [messageView bringSubviewToFront:messageLabel];
        [messageLabel setText:@"Comments:"];
        [messageLabel setFont:[UIFont fontWithName:@"OpenSans-Bold" size:18]];
        [messageLabel setTextColor:[UIColor blackColor]];
        for (int i = 0; i < [keysSorted count]; i++)
        {
            CGRect frMsg = CGRectMake(0, messageView.frame.size.height, 290, 0);

            UIView *msg = [[UIView alloc] initWithFrame:frMsg];
            [messageView addSubview:msg];
            [messageView bringSubviewToFront:msg];
            [msg setTag:[[keysSorted objectAtIndex:i] intValue]];

            NSString *msgFirstName = [[NSString alloc] initWithString:[[messageDict objectForKey:[keysSorted objectAtIndex:i]] objectForKey:@"firstname"]];
            NSString *msgLastName = [[NSString alloc] initWithString:[[messageDict objectForKey:[keysSorted objectAtIndex:i]] objectForKey:@"lastname"]];
            NSString *msgDate = [[NSString alloc] initWithString:[[messageDict objectForKey:[keysSorted objectAtIndex:i]] objectForKey:@"pubdate"]];
            NSString *msgBody = [[NSString alloc] initWithString:[[messageDict objectForKey:[keysSorted objectAtIndex:i]] objectForKey:@"message"]];
            NSArray *imgArrayMessageKeys = [[NSArray alloc] init];
            if (!([[[messageDict objectForKey:[keysSorted objectAtIndex:i]] objectForKey:@"images"] count] == 0))
            {
                imgArrayMessageKeys = [[[messageDict objectForKey:[keysSorted objectAtIndex:i]] objectForKey:@"images"] allKeys];
            }
            
            msgBody = [adUniversal stripTags:msgBody];
            NSString *msgUsername = [NSString stringWithFormat:@"%@ %@ - %@", msgFirstName, msgLastName, msgDate];

            // message username
            CGRect frMessageUser = CGRectMake(0, (messageLabel.frame.size.height + messageLabel.frame.origin.y + 10), 200, 12);
            UILabel *messageBodyUser = [[UILabel alloc] initWithFrame:frMessageUser];
            [msg addSubview:messageBodyUser];
            [msg bringSubviewToFront:messageBodyUser];
            [messageBodyUser setText:msgUsername];
            [messageBodyUser setFont:[UIFont fontWithName:@"OpenSans-Italic" size:11]];
            [messageBodyUser setTextColor:[UIColor grayColor]];
            [messageBodyUser setAdjustsFontSizeToFitWidth:TRUE];
            [messageBodyUser setMinimumFontSize:8];
            
            // message body
            CGRect frMessageBody = CGRectMake(0, (messageBodyUser.frame.size.height + messageBodyUser.frame.origin.y), 290, 18);
            UITextView *messageBodyText = [[UITextView alloc] initWithFrame:frMessageBody];
            [msg addSubview:messageBodyText];
            [msg bringSubviewToFront:messageBodyText];
            [messageBodyText setText:msgBody];
            [messageBodyText setFont:[UIFont fontWithName:@"OpenSans-Bold" size:13]];
            [messageBodyText setTextColor:[UIColor blackColor]];
            [messageBodyText setDelegate:self];
            // resize view to fit to text
            CGRect fr = messageBodyText.frame;
            fr.size.height = [messageBodyText contentSize].height;
            messageBodyText.frame = fr;
            messageBodyText.contentInset = UIEdgeInsetsMake(-4, -8, 0, 0);
            
            //message images
            CGRect frMessageImagesGrid = CGRectMake(0, (messageBodyText.frame.size.height + messageBodyText.frame.origin.y), 290, 0);
            UIView *messageImageGrid = [[UIView alloc] initWithFrame:frMessageImagesGrid];
            [msg addSubview:messageImageGrid];
            [msg bringSubviewToFront:messageImageGrid];
            
            if ([imgArrayMessageKeys count] > 0)
            {
                int imgHeight = 71;
                int imgWidth = 71;
                int picsPerRow = 4;
                float imgMargin = 2;
                int rows = (int)ceil((float)[imgArrayMessageKeys count]/4);
                int imgGridWidth = (int)ceil((float)((imgWidth * picsPerRow) + ((picsPerRow - 1) * imgMargin)));
                int imgGridHeight = (int)ceil((float)(rows * imgHeight));
                CGRect frNew = CGRectMake(0, (messageBodyText.frame.size.height + messageBodyText.frame.origin.y), imgGridWidth, imgGridHeight);
                [messageImageGrid setFrame:frNew];
                NSMutableDictionary *messageImgDict = [[NSMutableDictionary alloc] init];
                for (int j = 0; j < rows; j++)
                {
                    for (int k = 0; k < picsPerRow; k++)
                    {
                        if (((j * picsPerRow) + k) < [imgArrayMessageKeys count])
                        {
                            NSString *urlStringThumb = [NSString stringWithString:[[[[messageDict objectForKey:[keysSorted objectAtIndex:i]] objectForKey:@"images"] objectForKey:[imgArrayMessageKeys objectAtIndex:((j * picsPerRow) + k)]] objectForKey:@"150"]];
                            NSString *urlStringFull = [NSString stringWithString:[[[[messageDict objectForKey:[keysSorted objectAtIndex:i]] objectForKey:@"images"] objectForKey:[imgArrayMessageKeys objectAtIndex:((j * picsPerRow) + k)]] objectForKey:@"600"]];
                            
                            NSURL *imageUrl = [NSURL URLWithString: urlStringThumb];
                            UIImage *image = [UIImage imageWithData: [NSData dataWithContentsOfURL:imageUrl]];
                            
                            NSString *key = [[NSString alloc] initWithFormat:@"%i", ((j * picsPerRow) + k)];
                            NSMutableDictionary *tmp = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                                        @"message", @"type",
                                                        urlStringThumb, @"pathThumb",
                                                        urlStringFull, @"pathFull",
                                                        nil];
                            [messageImgDict setObject:tmp forKey:key];
                            
                            UIButton *imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
                            imageButton.frame = CGRectMake((imgWidth + 2.5) * k, (imgHeight + 2.5) * j, imgWidth, imgHeight);
                            [imageButton setImage:image forState:UIControlStateNormal];
                            [imageButton setTag:((j * picsPerRow) + k)];
                            [imageButton setTitle:@"message" forState:UIControlStateNormal];
                            [messageImageGrid addSubview:imageButton];
                            
                            [imageButton addTarget:self action:@selector(openImage:) forControlEvents:UIControlEventTouchDown];
                        }
                    }
                }
                NSString *key = [[NSString alloc] initWithFormat:@"m%@", [keysSorted objectAtIndex:i]];
                [imgDict setObject:messageImgDict forKey:key];
            }
            
            CGRect frMsgNew = CGRectMake(msg.frame.origin.x, msg.frame.origin.y, 290, (messageImageGrid.frame.size.height + messageImageGrid.frame.origin.y));
            [msg setFrame:frMsgNew];
            
            CGRect frMessageViewNew = CGRectMake(messageView.frame.origin.x, messageView.frame.origin.y, 290, (msg.frame.size.height + msg.frame.origin.y));
            [messageView setFrame:frMessageViewNew];
            
        }
    }
    
    // ADD COMMENT BUTTON
    CGRect frAddCommentButton = CGRectMake(15, (messageView.frame.size.height + messageView.frame.origin.y) + 20, 290, 40);
    [addCommentButton setFrame:frAddCommentButton];
    [addCommentButton setTitle:@"ADD COMMENT" forState:UIControlStateNormal];
    [addCommentButton setBackgroundImage:[UIImage imageNamed:@"bgButton.png"] forState:UIControlStateNormal];
    addCommentButton.titleLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:18];
    addCommentButton.titleLabel.textColor = [UIColor whiteColor];
    [mainView addSubview:addCommentButton];
    [mainView bringSubviewToFront:addCommentButton];
    [addCommentButton addTarget:self action:@selector(addComment) forControlEvents:UIControlEventTouchDown];
    
    // UPDATE STATUS BUTTON
    CGRect frUpdateStatusButton = CGRectMake(15, (addCommentButton.frame.size.height + addCommentButton.frame.origin.y) + 10, 290, 40);
    [updateStatusButton setFrame:frUpdateStatusButton];
    if ([[[NSString alloc] initWithString:[[[universal.currentDictMaintRequests objectForKey:universal.selectedProgram] objectForKey:universal.selectedProgramItem] valueForKey:@"completeStatus"]] isEqualToString:@"Open"]) {
        [updateStatusButton setTitle:@"CLOSE REQUEST" forState:UIControlStateNormal];
        [updateStatusButton setBackgroundImage:[UIImage imageNamed:@"bgButton.png"] forState:UIControlStateNormal];
    } else {
        [updateStatusButton setTitle:@"REOPEN REQUEST" forState:UIControlStateNormal];
        [updateStatusButton setBackgroundImage:[UIImage imageNamed:@"bgButton.png"] forState:UIControlStateNormal];
    }
    updateStatusButton.titleLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:18];
    updateStatusButton.titleLabel.textColor = [UIColor whiteColor];
    [mainView addSubview:updateStatusButton];
    [mainView bringSubviewToFront:updateStatusButton];
    [updateStatusButton addTarget:self action:@selector(showUploadIndicator:) forControlEvents:UIControlEventTouchDown];
    
    // SET SCROLL HEIGHT
    [mainView setFrame:CGRectMake(0, 0, 320, (updateStatusButton.frame.origin.y + updateStatusButton.frame.size.height + 20))];
    [scroll setScrollEnabled:YES];
    [scroll setContentSize:CGSizeMake(320, mainView.frame.size.height)];

}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return NO;
}

@end

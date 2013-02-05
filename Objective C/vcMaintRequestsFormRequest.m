//
//  vcMaintRequestsFormRequest.m
//  MaintenanceRequestsBBB
//
//  Created by Brian Adams on 7/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "adUniversal.h"
#import "vcMaintRequestsFormRequest.h"
#import "vcMaintRequestsIndividual.h"
#import "vcMaintRequestsPicker.h"
#import "PhotoViewController.h"

@interface vcMaintRequestsFormRequest ()

@end

@implementation vcMaintRequestsFormRequest

@synthesize tableInput;
@synthesize imageGrid;
@synthesize scroll;
@synthesize mainView;
@synthesize pickerView;
@synthesize datePicker;

@synthesize btnSave;
@synthesize btnPickerDone;
@synthesize btnPickerCancel;

@synthesize dateField;
@synthesize programField;
@synthesize typeField;
@synthesize departmentField;
@synthesize streetNumField;
@synthesize addressField;
@synthesize infoField;
@synthesize descriptionField;

@synthesize fieldsArray;

@synthesize imagePicker;
@synthesize imgArray;

@synthesize keyToEdit;

@synthesize req_idText;
@synthesize user_idText;
@synthesize prog_idText;
@synthesize type_idText;
@synthesize dep_idText;
@synthesize streetnumText;
@synthesize addressText;
@synthesize infoText;
@synthesize descriptionText;
@synthesize dateText;

@synthesize complete;
@synthesize completeDate;
@synthesize statusText;
@synthesize completeStatusText;
@synthesize dep_nameText;
@synthesize type_nameText;
@synthesize prog_nameText;

@synthesize resignResponder;

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
    
    // views
    scroll = [[UIScrollView alloc] init];
    mainView = [[UIView alloc] init];
    pickerView = [[UIView alloc] init];
    datePicker = [[UIDatePicker alloc] init];
    
    // individual fields
    programField = [[UITextField alloc] init];
    typeField = [[UITextField alloc] init];
    departmentField = [[UITextField alloc] init];
    streetNumField = [[UITextField alloc] init];
    addressField = [[UITextField alloc] init];
    dateField = [[UITextField alloc] init];
    infoField = [[UITextField alloc] init];
    descriptionField = [[UITextField alloc] init];
    
    // array of fields to display
    fieldsArray = [[NSMutableArray alloc] initWithObjects:programField, typeField, departmentField, streetNumField, addressField, dateField, infoField, descriptionField, nil];
    
    // NAVIGATION BAR
    
    // Set Title in Nav Bar
    if (keyToEdit)
    {
        [self setTitle:@"Edit Request"];
    }
    else {
        [self setTitle:@"Add Request"];
    }
    
    // Hide Back Button - this is done so it can be replaced with Cancel Button
    [self.navigationItem setHidesBackButton:FALSE];
    
    // Set Nav Bar Buttons (save)
    UIImage *imgSave = [UIImage imageNamed:@"bgButtonSmall.png"];
    CGRect frBtnSave = CGRectMake(0, 0, 70, 24);
    btnSave = [[UIButton alloc]initWithFrame:frBtnSave];
    [btnSave setTitle:@"SAVE" forState:UIControlStateNormal];
    btnSave.titleLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:14];
    btnSave.titleLabel.textColor = [UIColor whiteColor];
    [btnSave setBackgroundImage:imgSave forState:UIControlStateNormal];
    [btnSave addTarget:self action:@selector(showUploadIndicator:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *saveNewRequest = [[UIBarButtonItem alloc] initWithCustomView:btnSave];
    [[self navigationItem] setRightBarButtonItem:saveNewRequest];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(goBack)];
    [self.navigationItem setLeftBarButtonItem:leftBarButton];

    // CREATE SCROLL VIEW
    
    // scroll view
    CGRect frScroll = CGRectMake(0, 0, 320, 420);
    [scroll setFrame:frScroll];
    [scroll setScrollEnabled:YES];
    [self.view addSubview:scroll];
    [self.view bringSubviewToFront:scroll];
    // main view to hold form with in scroll view
    [mainView setFrame:frScroll];
    [scroll addSubview:mainView];
    
    // TABLE VIEW
    
    // create table
    CGRect fr = CGRectMake(0, 0, 320, 480);
    tableInput = [[UITableView alloc] initWithFrame:fr style:UITableViewStyleGrouped];
    tableInput.autoresizingMask =  UIViewAutoresizingFlexibleHeight;
    tableInput.backgroundColor = [UIColor clearColor];
    tableInput.backgroundView = nil;
    tableInput.delegate = self;
    tableInput.dataSource = self;
    
    // add to view
    [mainView addSubview:tableInput];
    
    // REQUEST VALUES
    
    adUniversal *universal = (adUniversal *)[[UIApplication sharedApplication] delegate];
    
    // user editing/creating
    user_idText = [universal.userDict valueForKey:@"id"];
    
    // set ids
    if (keyToEdit && !(keyToEdit == @""))
    {
        prog_idText = [NSMutableString stringWithString:[[[universal.currentDictMaintRequests objectForKey:universal.selectedProgram] objectForKey:keyToEdit] valueForKey:@"prog_id"]];
        type_idText = [NSMutableString stringWithString:[[[universal.currentDictMaintRequests objectForKey:universal.selectedProgram] objectForKey:keyToEdit] valueForKey:@"type_id"]];
        dep_idText = [NSMutableString stringWithString:[[[universal.currentDictMaintRequests objectForKey:universal.selectedProgram] objectForKey:keyToEdit] valueForKey:@"dep_id"]];
    }
    else
    {
        prog_idText = [NSMutableString stringWithString:universal.selectedProgram];
        type_idText = [NSMutableString stringWithString:@""];
        dep_idText = [NSMutableString stringWithString:@""];
    }
    
    // CAMERA AND IMAGES
    
    // add photos button
    UIButton *cameraButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 380, 300, 40)];
    [cameraButton setBackgroundImage:[UIImage imageNamed:@"bgButton.png"] forState:UIControlStateNormal];
    [cameraButton setTitle:@"ADD PHOTOS" forState:UIControlStateNormal];
    cameraButton.titleLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:18];
    cameraButton.titleLabel.textColor = [UIColor whiteColor];
    [mainView addSubview:cameraButton];
    [mainView bringSubviewToFront:cameraButton];
    [cameraButton addTarget:self action:@selector(openCamera:) forControlEvents:UIControlEventTouchDown];
    
    // array and view to hold images
    imgArray = [[NSMutableArray alloc] init];
    imageGrid = [[UIView alloc] initWithFrame:CGRectMake(15, 440, 290, 0)];
    
    // DATE PICKER
    
    // date picker view
    [pickerView setFrame:CGRectMake(0, 416, 320, 304)];
    [datePicker setFrame:CGRectMake(0, 44, 320, 260)];
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    [pickerView addSubview:datePicker];
    [self.view addSubview:pickerView];
    [self.view bringSubviewToFront:pickerView];
    
    // date picker toolbar
    UIToolbar *toolbarDatePicker = [[UIToolbar alloc] init];
    CGRect frToolbarDatePicker = CGRectMake(0, 0, 320, 44);
    [toolbarDatePicker setFrame:frToolbarDatePicker];
    [toolbarDatePicker setBarStyle:UIBarStyleBlackOpaque];
    
    // date picker toolbar buttons
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [fixedSpace setWidth:250];
    btnPickerCancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(closePicker:)];
    btnPickerDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(updateDate:)];
    NSMutableArray *newItems = [NSMutableArray arrayWithObjects:fixedSpace, btnPickerDone, nil];
    [toolbarDatePicker setItems:newItems animated:NO];
    [pickerView addSubview:toolbarDatePicker];
    
    // ACTIVITY INDICATOR
    [self showUploadIndicator:self];
    
    // TAP RECOGNIZER TO REMOVE KEYBOARD ON BG TAP FOR SCROLL VIEW
    /* currently causes a slight delay to photo button and not really needed.
    resignResponder = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTap:)];
    [scroll addGestureRecognizer:resignResponder];
    */
    // RELOAD FORM
    
    [tableInput reloadData];
    
    // LOAD ANY IMAGES
    
    [self loadImages];
}

- (void)viewDidAppear:(BOOL)animated
{
    // HIDE ACTIVITY INDICATOR
    [activityIndicator setHidden:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)goBack
{
    [[self navigationController] popViewControllerAnimated:YES];
}

// SHOW ACTIVITY INDICATOR - FOR NEW MAINTENANCE REQUESTS - this must be done in two methods to show the activity indicator because the upload request is synchronous.
- (IBAction)showUploadIndicator:(id)sender
{
    [self backgroundTap:self];

    if (sender == btnSave) {
        activityIndicator = [adUniversal loadActivityIndicator:@"Saving Request..."];
        [self performSelector:@selector(saveNewMaintRequest:) withObject:nil afterDelay:0];
    } else {
        activityIndicator = [adUniversal loadActivityIndicator:@"Loading Form..."];
    }
    
    [self.view addSubview: activityIndicator];
    [self.view bringSubviewToFront: activityIndicator];
}
// upload request
- (IBAction)saveNewMaintRequest:(id)sender
{
    NSMutableArray *errors = [[NSMutableArray alloc] init];
    
    if (!(type_idText) || [type_idText isEqualToString:@""] || type_idText == nil)
    {
        [errors addObject:@"•\tMaintenance Type\n"];
    }
    if (!(dep_idText) || [dep_idText isEqualToString:@""] || dep_idText == nil)
    {
        [errors addObject:@"•\tDepartment\n"];
    }
    if (!([NSMutableString stringWithString: ((UITextField *)[scroll viewWithTag:4]).text]) || [[NSMutableString stringWithString: ((UITextField *)[scroll viewWithTag:4]).text] isEqualToString:@""] || [NSMutableString stringWithString: ((UITextField *)[scroll viewWithTag:4]).text] == nil)
    {
        [errors addObject:@"•\tStreet Address\n"];
    }
    if (!([NSMutableString stringWithString: ((UITextField *)[scroll viewWithTag:5]).text]) || [[NSMutableString stringWithString: ((UITextField *)[scroll viewWithTag:5]).text] isEqualToString:@""] || [NSMutableString stringWithString: ((UITextField *)[scroll viewWithTag:5]).text] == nil)
    {
        [errors addObject:@"•\tStreet Name\n"];
    }
    if ([errors count] > 0)
    {
        // HIDE ACTIVITY INDICATOR
        [activityIndicator setHidden:YES];
        
        NSMutableString *alertText = [[NSMutableString alloc] init];
        for (int i = 0; i < [errors count]; i++)
        {
            [alertText appendString:[errors objectAtIndex:i]];
        }
        UIAlertView *alertErrors = [[UIAlertView alloc] initWithTitle:@"Required Fields" message:alertText delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertErrors show];
    }
    
    if ([errors count] == 0)
    {
        adUniversal *universal = (adUniversal *)[[UIApplication sharedApplication] delegate];
        
        // get a unique id
        if (keyToEdit && !(keyToEdit == @""))
        {
            req_idText = [NSString stringWithString:keyToEdit];
        }
        else
        {
            req_idText = [NSMutableString stringWithString: @""];
        }
        
        // create new request and add to the local dictionary
        NSMutableDictionary *newRequestImages = [NSMutableDictionary dictionary];
        if ([imgArray count] > 0) {
            for (int i = 0; i < [imgArray count]; i++) {
                [newRequestImages setObject:[imgArray objectAtIndex:i] forKey:[NSString stringWithFormat:@"%i", i]];
            }
        }
        
        streetnumText = [NSMutableString stringWithString: ((UITextField *)[scroll viewWithTag:4]).text];
        addressText = [NSMutableString stringWithString: ((UITextField *)[scroll viewWithTag:5]).text];
        infoText = [NSMutableString stringWithString: ((UITextField *)[scroll viewWithTag:7]).text];
        descriptionText = [NSMutableString stringWithString: ((UITextField *)[scroll viewWithTag:8]).text];
        dateText = [NSMutableString stringWithString: ((UITextField *)[scroll viewWithTag:6]).text];
        
        complete = [NSMutableString stringWithString: @""];
        completeDate = [NSMutableString stringWithString: @""];
        statusText = [NSMutableString stringWithString: @""];
        
        dep_nameText = [NSMutableString stringWithString: ((UITextField *)[scroll viewWithTag:3]).text];
        dep_idText = [NSString stringWithString:[[[[[universal.userDict objectForKey:@"programs"] objectForKey:universal.selectedProgram] objectForKey:@"maintenanceDepartments"] allKeysForObject:dep_nameText] objectAtIndex:0]];
        
        type_nameText = [NSMutableString stringWithString: ((UITextField *)[scroll viewWithTag:2]).text];
        type_idText = [NSString stringWithString:[[[[[universal.userDict objectForKey:@"programs"] objectForKey:universal.selectedProgram] objectForKey:@"maintenanceTypes"] allKeysForObject:type_nameText] objectAtIndex:0]];
        
        prog_nameText = [NSMutableString stringWithString: ((UITextField *)[scroll viewWithTag:1]).text];
        prog_idText = [NSString stringWithString:universal.selectedProgram];
        
        NSMutableDictionary *newRequest = [NSMutableDictionary dictionary];
        newRequest = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                      req_idText, @"req_id",
                      user_idText, @"user_id",
                      dateText, @"date",
                      streetnumText, @"streetnum",
                      addressText, @"address",
                      infoText, @"info",
                      descriptionText, @"description",
                      dep_idText, @"dep_id",
                      type_idText, @"type_id",
                      prog_idText, @"prog_id",
                      complete, @"complete",
                      completeDate, @"completeDate",
                      newRequestImages, @"images",
                      nil];
        
        [universal.localDictMaintRequests setObject:newRequest forKey:[NSNumber numberWithInt:[universal.localDictMaintRequests count]]];
        
        // upload local dictionary to server synchronously
        [adUniversal uploadChangesMaintRequests:universal.localDictMaintRequests:FALSE];
        
        // update current dictionary to show new request(s)
        universal.currentDictMaintRequests = [adUniversal downloadCurrentDict :universal.email :universal.password :@"maintReports"];
        imgArray = [[NSMutableArray alloc] init];
        
        //return to list of maintenance requests
        [self goBack];
    }
}

// KEYBOARD
- (IBAction)textFieldDoneEditing:(id)sender
{
    [sender resignFirstResponder];
    // SET SCROLL HEIGHT
    float tmpPoint = 0;
    [self setScrollHeight:tmpPoint];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    // SET SCROLL HEIGHT
    float tmpPoint = 0;
    [self setScrollHeight:tmpPoint];
    
    return YES;
}

- (IBAction)backgroundTap:(id)sender
{
    [streetNumField resignFirstResponder];
    [addressField resignFirstResponder];
    [dateField resignFirstResponder];
    [infoField resignFirstResponder];
    [descriptionField resignFirstResponder];
    if (sender == resignResponder)
    {
        // set scroll
        float tmpPoint = 0;
        [self setScrollHeight:tmpPoint];
    }
}

// CAMERA
- (IBAction)openCamera:(id)sender
{
    if (self.imagePicker == nil) {
        imagePicker = [[UIImagePickerController alloc] init];
        [imagePicker setDelegate:self];
    }
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIActionSheet *pickerTypeSelector = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Use Camera", @"Choose from Library", nil];
        [pickerTypeSelector showInView:self.view];
        
    }
    else
    {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [[self navigationController] presentModalViewController:imagePicker animated:YES];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            // camera button
            [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
            [[self navigationController] presentModalViewController:imagePicker animated:YES];
            break;
        }
        case 1:
        {
            // library button
            [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            [[self navigationController] presentModalViewController:imagePicker animated:YES];
            break;
        }
        case 2:
        {
            // cancel button
            break;
        }
        default:
        {
            break;
        }
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [[self navigationController] dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)imgDict
{   
    UIImage *image = [imgDict objectForKey:UIImagePickerControllerOriginalImage];
    // overwrites same index to keep array at one object.
    /*
    if ([imgArray count] == 0)
    {
        [imgArray addObject:[adUniversal setImageOrientation:image]];
    }
    else
    {
        [imgArray replaceObjectAtIndex:0 withObject:[adUniversal setImageOrientation:image]];
    };
     */
    
    // creates array of images
    [imgArray addObject:[adUniversal setImageOrientation:image]];
    
    [self loadImages];
    [[self navigationController] dismissModalViewControllerAnimated:YES];
}

// IMAGES
- (void)loadImages
{
    CGRect frImageGrid = CGRectMake(15, 440, 290, 0);
    [imageGrid setFrame:frImageGrid];
    [mainView addSubview:imageGrid];
    [mainView bringSubviewToFront:imageGrid];
    
    if ([imgArray count] > 0)
    {
        int imgHeight = 71;
        int imgWidth = 71;
        int picsPerRow = 4;
        float imgMargin = 2;
        int rows = (int)ceil((float)[imgArray count]/4);
        int imgGridWidth = (int)ceil((float)((imgWidth * picsPerRow) + ((picsPerRow - 1) * imgMargin)));
        int imgGridHeight = (int)ceil((float)(rows * imgHeight));
        CGRect fr = CGRectMake(15, 440, imgGridWidth, imgGridHeight);
        [imageGrid setFrame:fr];
        for (int i = 0; i < rows; i++)
        {
            for (int j = 0; j < picsPerRow; j++)
            {
                if (((i * picsPerRow) + j) < [imgArray count])
                {
                    UIImage *image = [imgArray objectAtIndex:((i * picsPerRow) + j)];
                    
                    UIButton *imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
                    imageButton.frame = CGRectMake((imgWidth + 2.5) * j, (imgHeight + 2.5) * i, imgWidth, imgHeight);
                    [imageButton setImage:image forState:UIControlStateNormal];
                    [imageButton setTag:((i * picsPerRow) + j)];
                    [imageGrid addSubview:imageButton];
                    
                    [imageButton addTarget:self action:@selector(openImage:) forControlEvents:UIControlEventTouchDown];
                }
            }
        }
    }
    
    // SET MAIN VIEW HEIGHT
    [mainView setFrame:CGRectMake(mainView.frame.origin.x, mainView.frame.origin.y, mainView.frame.size.width, (imageGrid.frame.origin.y + imageGrid.frame.size.height + 20))];
    
    // SET SCROLL HEIGHT
    float tmpPoint = 0;
    [self setScrollHeight:tmpPoint];
    
    // HIDE ACTIVITY INDICATOR
    [activityIndicator setHidden:YES];
}

- (void)setScrollHeight:(float)point
{
    // SET SCROLL HEIGHT
    [scroll setScrollEnabled:YES];
    [UIScrollView beginAnimations:nil context:NULL];
    [UIScrollView setAnimationDuration:0.3];
    if (!(point == 0))
    {
        [scroll setContentSize:CGSizeMake(320, (mainView.frame.size.height + 220))];
    } else {
        [scroll setContentSize:CGSizeMake(320, mainView.frame.size.height)];
    }
    [scroll scrollRectToVisible:CGRectMake(0, point, 320, 420) animated:YES];
    [UIScrollView commitAnimations];
}

// GALLERY
- (IBAction)openImage:(id)sender
{
    PhotoViewController *imageGallery = [[PhotoViewController alloc]initWithNibName:@"PhotoViewController" bundle:nil];
    imageGallery.imagesArrayFiles = imgArray;
    imageGallery.selectedPage = [sender tag];
    [[self navigationController] pushViewController:imageGallery animated:YES];
}

// PICKER VIEW
- (IBAction)openPicker:(id)sender
{
    UIViewController *picker = [[vcMaintRequestsPicker alloc] initWithNibName:@"vcMaintRequestsPicker" bundle:nil];
    [[self navigationController] pushViewController:picker animated:YES];
}

// TABLE VIEW
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return number of rows in section
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return number of rows in section
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{  
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    // FORM VALUES
    adUniversal *universal = (adUniversal *)[[UIApplication sharedApplication] delegate];
        
    switch (indexPath.row + 1) {
        case 1:
        {
            // program
            [[fieldsArray objectAtIndex:indexPath.row] setPlaceholder:@"Program"];
            [[fieldsArray objectAtIndex:indexPath.row] setText:[universal.userProgramsDict objectForKey:universal.selectedProgram]];
            // disabled due to inablity to create new req_id for edited request
            cell.userInteractionEnabled = NO;
            cell.accessoryType = UITableViewCellAccessoryNone;
            break;
        }
        case 2:
        {
            [[fieldsArray objectAtIndex:indexPath.row] setPlaceholder:@"*Maintenance Type"];
            if (keyToEdit && !(keyToEdit == @""))
            {
                [[fieldsArray objectAtIndex:indexPath.row] setText:[[[universal.currentDictMaintRequests objectForKey:universal.selectedProgram] objectForKey:keyToEdit] valueForKey:@"type_name"]];
            }
            else
            {
                [[fieldsArray objectAtIndex:indexPath.row] setText:@""];
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        }
        case 3:
        {
            [[fieldsArray objectAtIndex:indexPath.row] setPlaceholder:@"*Department"];
            if (keyToEdit && !(keyToEdit == @""))
            {
                [[fieldsArray objectAtIndex:indexPath.row] setText:[[[universal.currentDictMaintRequests objectForKey:universal.selectedProgram] objectForKey:keyToEdit] valueForKey:@"dep_name"]];
            }
            else
            {
                [[fieldsArray objectAtIndex:indexPath.row] setText:@""];
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        }
        case 4:
        {
            [[fieldsArray objectAtIndex:indexPath.row] setPlaceholder:@"*Street Number"];
            if (keyToEdit && !(keyToEdit == @""))
            {
                [[fieldsArray objectAtIndex:indexPath.row] setText:[[[universal.currentDictMaintRequests objectForKey:universal.selectedProgram] objectForKey:keyToEdit] valueForKey:@"streetnum"]];
            }
            else
            {
                [[fieldsArray objectAtIndex:indexPath.row] setText:@""];
            }
            [[fieldsArray objectAtIndex:indexPath.row] setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
            [[fieldsArray objectAtIndex:indexPath.row] setReturnKeyType:UIReturnKeyDone];
            break;
        }
        case 5:
        {
            [[fieldsArray objectAtIndex:indexPath.row] setPlaceholder:@"*Street Address"];
            if (keyToEdit && !(keyToEdit == @""))
            {
                [[fieldsArray objectAtIndex:indexPath.row] setText:[[[universal.currentDictMaintRequests objectForKey:universal.selectedProgram] objectForKey:keyToEdit] valueForKey:@"address"]];
            }
            else
            {
                [[fieldsArray objectAtIndex:indexPath.row] setText:@""];
            }
            [[fieldsArray objectAtIndex:indexPath.row] setReturnKeyType:UIReturnKeyDone];
            break;
        }
        case 6:
        {
            // date
            [[fieldsArray objectAtIndex:indexPath.row] setPlaceholder:@"Date"];
            if (keyToEdit && !(keyToEdit == @""))
            {
                [[fieldsArray objectAtIndex:indexPath.row] setText:[[[universal.currentDictMaintRequests objectForKey:universal.selectedProgram] objectForKey:keyToEdit] valueForKey:@"date"]];
            }
            else
            {
                NSDate *selectedDate = [NSDate date];
                NSDateFormatter *dateToFormat = [[NSDateFormatter alloc] init];
                [dateToFormat setDateFormat:@"MM-dd-yyyy"];
                NSString *formattedDate = [dateToFormat stringFromDate:selectedDate];
                [[fieldsArray objectAtIndex:indexPath.row] setText:formattedDate];
            }
            break;
        }
        case 7:
        {
            [[fieldsArray objectAtIndex:indexPath.row] setPlaceholder:@"Describe the Location"];
            if (keyToEdit && !(keyToEdit == @""))
            {
                [[fieldsArray objectAtIndex:indexPath.row] setText:[[[universal.currentDictMaintRequests objectForKey:universal.selectedProgram] objectForKey:keyToEdit] valueForKey:@"info"]];
            }
            else
            {
                [[fieldsArray objectAtIndex:indexPath.row] setText:@""];
            }
            [[fieldsArray objectAtIndex:indexPath.row] setReturnKeyType:UIReturnKeyDone];
            break;
        }
        case 8:
        {
            [[fieldsArray objectAtIndex:indexPath.row] setPlaceholder:@"Describe the Request"];
            if (keyToEdit && !(keyToEdit == @""))
            {
                NSString *tmpDescriptionText = [[NSString alloc] initWithString:[[[universal.currentDictMaintRequests objectForKey:universal.selectedProgram] objectForKey:keyToEdit] valueForKey:@"description"]];
                [[fieldsArray objectAtIndex:indexPath.row] setText:[adUniversal stripTags:tmpDescriptionText]];
            }
            else
            {
                [[fieldsArray objectAtIndex:indexPath.row] setText:@""];
            }
            [[fieldsArray objectAtIndex:indexPath.row] setReturnKeyType:UIReturnKeyDone];
            break;
        }
        default:
        {
            break;
        }
    }
    
    [cell setBackgroundColor:[UIColor clearColor]];
    [[fieldsArray objectAtIndex:indexPath.row] setFont:[UIFont fontWithName:@"OpenSans-Bold" size:14]];
    [[fieldsArray objectAtIndex:indexPath.row] setTag:(indexPath.row + 1)];
    [[fieldsArray objectAtIndex:indexPath.row] setFrame:CGRectMake(20, 12, 285, 30)];
    [[fieldsArray objectAtIndex:indexPath.row] setDelegate:self];
    [cell addSubview:[fieldsArray objectAtIndex:indexPath.row]];
        
    CGFloat tableViewHeight = (([cell bounds].size.height * (indexPath.row + 1)) + 20);
    [tableInput setFrame:CGRectMake(0, 0, 320, tableViewHeight)];
    [tableInput setScrollEnabled:NO];
    // Configure the cell
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

// TEXT FIELD DELEGATES
- (BOOL)textFieldShouldBeginEditing:(UITextField *)sender
{
    adUniversal *universal = (adUniversal *)[[UIApplication sharedApplication] delegate];
    switch (sender.tag)
    {
        case 1:
        {
            // program request picker
            vcMaintRequestsPicker *picker = [[vcMaintRequestsPicker alloc]initWithNibName:@"vcMaintRequestsPicker"bundle:nil];
            picker.tableToLoad = @"prog_name";
            picker.selector = @selector(updateFieldWithSelectedOption:::);
            picker.target = self;
            picker.selectedRow = [universal.selectedProgram intValue];
            picker.fieldTag = sender.tag;
            [[self navigationController] pushViewController:picker animated:YES];
            [self closePicker:sender];
            return NO;
            break;
        }
        case 2:
        {
            // maintenance request picker
            vcMaintRequestsPicker *picker = [[vcMaintRequestsPicker alloc]initWithNibName:@"vcMaintRequestsPicker"bundle:nil];
            picker.tableToLoad = @"type_name";
            picker.selector = @selector(updateFieldWithSelectedOption:::);
            picker.target = self;
            NSArray *keys = [[[[universal.userDict objectForKey:@"programs"] objectForKey:universal.selectedProgram] objectForKey:@"maintenanceTypes"] allKeys];
            if (((UITextField *)[scroll viewWithTag:sender.tag]).text && !(((UITextField *)[scroll viewWithTag:sender.tag]).text == @""))
            {
                picker.selectedRow = [[keys objectAtIndex:[[[[[universal.userDict objectForKey:@"programs"] objectForKey:universal.selectedProgram] objectForKey:@"maintenanceTypes"] allValues] indexOfObject:((UITextField *)[scroll viewWithTag:sender.tag]).text]] intValue];
            } else {
                picker.selectedRow = 0;
            }
            picker.fieldTag = sender.tag;
            picker.progID = [universal.selectedProgram intValue];
            [self closePicker:sender];
            [[self navigationController] pushViewController:picker animated:YES];
            return NO;
        }
        case 3:
        {
            // department picker
            vcMaintRequestsPicker *picker = [[vcMaintRequestsPicker alloc]initWithNibName:@"vcMaintRequestsPicker"bundle:nil];
            picker.tableToLoad = @"dep_name";
            picker.selector = @selector(updateFieldWithSelectedOption:::);
            picker.target = self;
            NSArray *keys = [[[[universal.userDict objectForKey:@"programs"] objectForKey:universal.selectedProgram] objectForKey:@"maintenanceDepartments"] allKeys];
            if (((UITextField *)[scroll viewWithTag:sender.tag]).text && !(((UITextField *)[scroll viewWithTag:sender.tag]).text == @""))
            {
                picker.selectedRow = [[keys objectAtIndex:[[[[[universal.userDict objectForKey:@"programs"] objectForKey:universal.selectedProgram] objectForKey:@"maintenanceDepartments"] allValues] indexOfObject:((UITextField *)[scroll viewWithTag:sender.tag]).text]] intValue];
            } else {
                picker.selectedRow = 0;
            }
            picker.fieldTag = sender.tag;
            picker.progID = [universal.selectedProgram intValue];
            [self closePicker:sender];
            [[self navigationController] pushViewController:picker animated:YES];
            return NO;
        }
        case 6:
        {
            // remove keyboard
            [self backgroundTap:self];
            
            // date picker
            UIScreen *screen = [[UIScreen alloc] init];
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.3];
            [pickerView setFrame:CGRectMake(0, ([screen bounds].origin.x + 156), 320, 304)];
            [UIView commitAnimations];

            // set scroll
            float tmpPoint = (sender.superview.frame.origin.y - 156 + sender.superview.frame.size.height + 10);
            [self setScrollHeight:tmpPoint];

            return NO;
        }
        default:
        {
            [self closePicker:sender];
            
            // set scroll
            float tmpPoint = (sender.superview.frame.origin.y - 200 + sender.superview.frame.size.height + 10);
            [self setScrollHeight:tmpPoint];
            
            return YES;
            break;
        }
    }
}

- (IBAction)closePicker:(id)sender
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    pickerView.frame = CGRectMake(0, (scroll.frame.origin.x + scroll.frame.size.height + 50), 320, 260);
    [UIView commitAnimations];
    if (sender == btnPickerDone)
    {
        // set scroll
        float tmpPoint = 0;
        [self setScrollHeight:tmpPoint];
    }
}

- (IBAction)updateDate:(id)sender
{
    NSDate *selectedDate = datePicker.date;
    NSDateFormatter *dateToFormat = [[NSDateFormatter alloc] init];
    [dateToFormat setDateFormat:@"MM-dd-yyyy"];
    NSString *formattedDate = [dateToFormat stringFromDate:selectedDate];
    ((UITextField *)[scroll viewWithTag:6]).text = formattedDate;
    [self closePicker:sender];
}

- (IBAction)updateFieldWithSelectedOption:(NSString *)tagString:(NSString *)selectedOptionValue:(NSString *)selectedOptionID
{
    if (selectedOptionID)
    {
        int tagNum = [tagString intValue];
        [((UITextField *)[scroll viewWithTag:tagNum]) setText:selectedOptionValue];
        if (tagNum == 1)
        {
            // selecting new program and clearing the maint type
            prog_idText = [NSMutableString stringWithString:selectedOptionID];
            type_idText = [NSMutableString stringWithString:@""];
            [((UITextField *)[scroll viewWithTag:2]) setText:@""];
            dep_idText = [NSMutableString stringWithString:@""];
            [((UITextField *)[scroll viewWithTag:3]) setText:@""];
        }
        else if (tagNum == 2)
        {
            // selecting new maint type
            type_idText = [NSString stringWithString:selectedOptionID];
        }
        else if (tagNum == 3)
        {
            // selecting new maint type
            dep_idText = [NSString stringWithString:selectedOptionID];
        }
    }
}

@end

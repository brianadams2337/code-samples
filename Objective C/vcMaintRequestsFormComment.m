//
//  vcMaintRequestsFormComment.m
//  MaintenanceRequestsBBB
//
//  Created by Brian Adams on 8/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "adUniversal.h"
#import "vcMaintRequestsFormComment.h"
#import "PhotoViewController.h"

@interface vcMaintRequestsFormComment ()

@end

@implementation vcMaintRequestsFormComment

@synthesize messageField;

@synthesize imageGrid;
@synthesize scroll;
@synthesize mainView;

@synthesize imagePicker;
@synthesize imgArray;

@synthesize keyToEdit;

@synthesize req_idText;
@synthesize user_idText;
@synthesize prog_idText;
@synthesize messageText;
@synthesize dateText;

@synthesize btnSave;

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
    
    // ACTIVITY INDICATOR
    [self showUploadIndicator:self];
    
    // NAVIGATION BAR
    
    // Set Title in Nav Bar
    [self setTitle:@"Add Comment"];
    
    // Hide Back Button - this is done so it can be replaced with Cancel Button
    [self.navigationItem setHidesBackButton:FALSE];
    
    // Set Nav Bar Buttons (save, cancel)
    UIImage *imgSave = [UIImage imageNamed:@"bgButtonSmall.png"];
    CGRect frBtnSave = CGRectMake(0, 0, 70, 24);
    btnSave = [[UIButton alloc]initWithFrame:frBtnSave];
    [btnSave setTitle:@"SAVE" forState:UIControlStateNormal];
    btnSave.titleLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:14];
    btnSave.titleLabel.textColor = [UIColor whiteColor];
    [btnSave setBackgroundImage:imgSave forState:UIControlStateNormal];
    [btnSave addTarget:self action:@selector(showUploadIndicator:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *saveNewRequestMessage = [[UIBarButtonItem alloc] initWithCustomView:btnSave];
    [[self navigationItem] setRightBarButtonItem:saveNewRequestMessage];
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
    
    // REQUEST VALUES
    
    adUniversal *universal = (adUniversal *)[[UIApplication sharedApplication] delegate];
    
    // set ids
    user_idText = [universal.userDict valueForKey:@"id"];
    req_idText = [NSString stringWithString:keyToEdit];
    prog_idText = [NSMutableString stringWithString:[[[universal.currentDictMaintRequests objectForKey:universal.selectedProgram] objectForKey:keyToEdit] valueForKey:@"prog_id"]];
    
    // set date
    NSDate *selectedDate = [NSDate date];
    NSDateFormatter *dateToFormat = [[NSDateFormatter alloc] init];
    [dateToFormat setDateFormat:@"MM-dd-yyyy"];
    NSString *formattedDate = [dateToFormat stringFromDate:selectedDate];
    dateText = [NSString stringWithString:formattedDate];
    
    // message field
    CGRect frMessageField = CGRectMake(15, 15, 290, 150);
    [messageField setFrame:frMessageField];
    [messageField setFont:[UIFont fontWithName:@"OpenSans-Bold" size:14]];
    CALayer *viewLayer = messageField.layer;
    [viewLayer setCornerRadius:10];
    [viewLayer setBorderWidth:1];
    viewLayer.borderColor=[[UIColor lightGrayColor] CGColor];
    [messageField setKeyboardType:UIKeyboardTypeDefault];
    [messageField setReturnKeyType:UIReturnKeyDone];
    [messageField setDelegate:self];
    [messageField becomeFirstResponder];
    [mainView addSubview:messageField];
    [mainView bringSubviewToFront:messageField];
    
    // CAMERA AND IMAGES
    
    UIButton *cameraButton = [[UIButton alloc] initWithFrame:CGRectMake(15, (messageField.frame.size.height + messageField.frame.origin.y + 20), 290, 40)];
    [cameraButton setBackgroundImage:[UIImage imageNamed:@"bgButton.png"] forState:UIControlStateNormal];
    [cameraButton setTitle:@"ADD PHOTOS" forState:UIControlStateNormal];
    cameraButton.titleLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:18];
    cameraButton.titleLabel.textColor = [UIColor whiteColor];
    [mainView addSubview:cameraButton];
    [mainView bringSubviewToFront:cameraButton];
    [cameraButton addTarget:self action:@selector(openCamera:) forControlEvents:UIControlEventTouchDown];
    
    imgArray = [[NSMutableArray alloc] init];
    imageGrid = [[UIView alloc] initWithFrame:CGRectMake(15, 200, 290, 0)];
    
    // SET BACKGROUND TAP
    /*
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTap:)];
    tapRecognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapRecognizer];
    */
    // LOAD ANY IMAGES
    
    [self loadImages];
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

// NEW REQUEST MESSAGE - this must be done in two methods to show the activity indicator because the upload request is synchronous.
- (IBAction)showUploadIndicator:(id)sender
{
    [self backgroundTap:self];
    
    if (sender == btnSave) {
        activityIndicator = [adUniversal loadActivityIndicator:@"Saving Comment..."];
        [self performSelector:@selector(saveNewRequestMessage:) withObject:nil afterDelay:0];
    } else {
        activityIndicator = [adUniversal loadActivityIndicator:@"Loading Form..."];
    }
    
    [self.view addSubview: activityIndicator];
    [self.view bringSubviewToFront: activityIndicator];
}
// upload request
- (IBAction)saveNewRequestMessage:(id)sender
{
    NSMutableArray *errors = [[NSMutableArray alloc] init];
    if (!(messageField.text) || [messageField.text isEqualToString:@""] || messageField.text == nil)
    {
        [errors addObject:@"•\tYou must enter a Comment."];
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
    
    // create new request and add to the local dictionary
    NSMutableDictionary *commentImages = [NSMutableDictionary dictionary];
    if ([imgArray count] > 0) {
        for (int i = 0; i < [imgArray count]; i++) {
            [commentImages setObject:[imgArray objectAtIndex:i] forKey:[NSString stringWithFormat:@"%i", i]];
        }
    }
    
    messageText = [NSString stringWithString:messageField.text];
        
    NSMutableDictionary *newRequest = [NSMutableDictionary dictionary];
    newRequest = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                  req_idText, @"req_id",
                  user_idText, @"user_id",
                  dateText, @"date",
                  prog_idText, @"prog_id",
                  messageText, @"message",
                  commentImages, @"images",
                  nil];
    
    [universal.localDictMaintRequests setObject:newRequest forKey:[NSNumber numberWithInt:[universal.localDictMaintRequests count]]];
    
    // upload local dictionary to server synchronously
    [adUniversal uploadChangesMaintRequests:universal.localDictMaintRequests:TRUE];
    
    // update current dictionary to show new request(s)
        universal.currentDictMaintRequests = [adUniversal downloadCurrentDict :universal.email :universal.password :@"maintReports"];
    imgArray = [[NSMutableArray alloc] init];
    
    //return to list of maintenance requests
    [self goBack];
    }
}

// CAMERA
- (IBAction)openCamera:(id)sender
{
    imagePicker = [[UIImagePickerController alloc] init];
    [imagePicker setDelegate:self];
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
    CGRect frImageGrid = CGRectMake(15, 240, 290, 0);
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
        int imgGridHeight = (int)ceil((float)((rows * imgHeight) + 20));
        CGRect fr = CGRectMake(15, 240, imgGridWidth, imgGridHeight);
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
    [mainView setFrame:CGRectMake(0, 0, 320, (imageGrid.frame.origin.y + imageGrid.frame.size.height))];
    [messageField setFrame:CGRectMake(15, 15, 290, 150)];
    
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

// TEXT VIEW DELEGATES
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    // SET MAIN VIEW HEIGHT
    [mainView setFrame:CGRectMake(0, 0, 320, (imageGrid.frame.origin.y + imageGrid.frame.size.height))];
    [messageField setFrame:CGRectMake(15, 15, 290, 150)];
    
    // SET SCROLL HEIGHT
    float tmpPoint = (messageField.frame.origin.y - 10);
    [self setScrollHeight:tmpPoint];
    
    return YES;
}

// GALLERY
- (IBAction)openImage:(id)sender
{
    PhotoViewController *imageGallery = [[PhotoViewController alloc]initWithNibName:@"PhotoViewController" bundle:nil];
    imageGallery.imagesArrayFiles = imgArray;
    imageGallery.selectedPage = [sender tag];
    [[self navigationController] pushViewController:imageGallery animated:YES];
}

// KEYBOARD

- (IBAction)backgroundTap:(id)sender
{
    [messageField resignFirstResponder];
    // SET SCROLL HEIGHT
    float tmpPoint = 0;
    [self setScrollHeight:tmpPoint];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        // SET MAIN VIEW HEIGHT
        [mainView setFrame:CGRectMake(0, 0, 320, (imageGrid.frame.origin.y + imageGrid.frame.size.height))];
        [messageField setFrame:CGRectMake(15, 15, 290, 150)];
        
        // SET SCROLL HEIGHT
        float tmpPoint = 0;
        [self setScrollHeight:tmpPoint];
        
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

// GENERAL METHODS
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)goBack
{
    [[self navigationController] popViewControllerAnimated:YES];
}

@end

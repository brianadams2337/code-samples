//
//  vcMaintRequestsFormComment.h
//  MaintenanceRequestsBBB
//
//  Created by Brian Adams on 8/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@interface vcMaintRequestsFormComment : UIViewController <UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>
{
    IBOutlet UITextView *messageField;
    
    UIView *imageGrid;
    IBOutlet UIScrollView *scroll;
    IBOutlet UIView *mainView;
    
    UIImagePickerController *imagePicker;
    NSMutableArray *imgArray;
    
    NSString *keyToEdit;
    
    NSMutableString *req_idText;
    NSMutableString *user_idText;
    NSMutableString *prog_idText;
    NSMutableString *messageText;
    NSMutableString *dateText;
    
    UIButton *btnSave;
    
    UIView *activityIndicator;
}
- (IBAction)backgroundTap:(id)sender;
- (IBAction)saveNewRequestMessage:(id)sender;

@property (strong, nonatomic) UITextView *messageField;

// views
@property (nonatomic, retain) UIView *imageGrid;
@property (strong, nonatomic) IBOutlet UIScrollView *scroll;
@property (strong, nonatomic) IBOutlet UIView *mainView;

// images
@property (strong, nonatomic) UIImagePickerController *imagePicker;
@property (nonatomic, retain) NSMutableArray *imgArray;

@property (nonatomic, retain) NSString *keyToEdit;

@property (nonatomic, retain) NSMutableString *req_idText;
@property (nonatomic, retain) NSMutableString *user_idText;
@property (nonatomic, retain) NSMutableString *prog_idText;
@property (nonatomic, retain) NSMutableString *messageText;
@property (nonatomic, retain) NSMutableString *dateText;

@property (strong, nonatomic) UIButton *btnSave;

@property (nonatomic, retain) UIView *activityIndicator;

@end

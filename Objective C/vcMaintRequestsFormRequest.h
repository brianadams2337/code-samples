//
//  vcMaintRequestsFormRequest.h
//  MaintenanceRequestsBBB
//
//  Created by Brian Adams on 7/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface vcMaintRequestsFormRequest : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>
{
    IBOutlet UITableView *tableInput;
    IBOutlet UIView *imageGrid;
    IBOutlet UIScrollView *scroll;
    IBOutlet UIView *mainView;
    IBOutlet UIView *pickerView;
    IBOutlet UIDatePicker *datePicker;
    
    UIButton *btnSave;
    UIBarButtonItem *btnPickerDone;
    UIBarButtonItem *btnPickerCancel;
    
    IBOutlet UITextField *programField;
    IBOutlet UITextField *dateField;
    IBOutlet UITextField *typeField;
    IBOutlet UITextField *departmentField;
    IBOutlet UITextField *streetNumField;
    IBOutlet UITextField *addressField;
    IBOutlet UITextField *infoField;
    IBOutlet UITextField *descriptionField;
    
    NSMutableArray *fieldsArray;
    
    UIImagePickerController *imagePicker;
    NSMutableArray *imgArray;
    
    NSString *keyToEdit;
    
    NSMutableString *req_idText;
    NSMutableString *user_idText;
    NSMutableString *prog_idText;
    NSMutableString *type_idText;
    NSMutableString *dep_idText;
    NSMutableString *streetnumText;
    NSMutableString *addressText;
    NSMutableString *infoText;
    NSMutableString *descriptionText;
    NSMutableString *dateText;
    NSMutableString *complete;
    NSMutableString *completeDate;
    NSMutableString *statusText;
    NSMutableString *completeStatusText;
    NSMutableString *dep_nameText;
    NSMutableString *type_nameText;
    NSMutableString *prog_nameText;
    
    UITapGestureRecognizer *resignResponder;
    
    UIView *activityIndicator;
}

// actions
- (IBAction)textFieldDoneEditing:(id)sender;
- (IBAction)backgroundTap:(id)sender;
- (IBAction)saveNewMaintRequest:(id)sender;
- (IBAction)openCamera:(id)sender;
- (IBAction)closePicker:(id)sender;
- (IBAction)openPicker:(id)sender;
- (IBAction)updateDate:(id)sender;

// views
@property (strong, nonatomic) IBOutlet UITableView *tableInput;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
@property (strong, nonatomic) IBOutlet UIView *imageGrid;
@property (strong, nonatomic) IBOutlet UIScrollView *scroll;
@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) IBOutlet UIView *pickerView;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (strong, nonatomic) UIButton *btnSave;
@property (strong, nonatomic) UIBarButtonItem *btnPickerDone;
@property (strong, nonatomic) UIBarButtonItem *btnPickerCancel;

// text field inputs
@property (strong, nonatomic) UITextField *programField;
@property (strong, nonatomic) UITextField *dateField;
@property (strong, nonatomic) UITextField *typeField;
@property (strong, nonatomic) UITextField *departmentField;
@property (strong, nonatomic) UITextField *streetNumField;
@property (strong, nonatomic) UITextField *addressField;
@property (strong, nonatomic) UITextField *infoField;
@property (strong, nonatomic) UITextField *descriptionField;

@property (strong, nonatomic) NSMutableArray *fieldsArray;

// images
@property (strong, nonatomic) UIImagePickerController *imagePicker;
@property (nonatomic, retain) NSMutableArray *imgArray;

@property (nonatomic, retain) NSString *keyToEdit;

// variables
@property (nonatomic, retain) NSMutableString *req_idText;
@property (nonatomic, retain) NSMutableString *user_idText;
@property (nonatomic, retain) NSMutableString *prog_idText;
@property (nonatomic, retain) NSMutableString *type_idText;
@property (nonatomic, retain) NSMutableString *dep_idText;
@property (nonatomic, retain) NSMutableString *streetnumText;
@property (nonatomic, retain) NSMutableString *addressText;
@property (nonatomic, retain) NSMutableString *infoText;
@property (nonatomic, retain) NSMutableString *descriptionText;
@property (nonatomic, retain) NSMutableString *dateText;
@property (nonatomic, retain) NSMutableString *complete;
@property (nonatomic, retain) NSMutableString *completeDate;
@property (nonatomic, retain) NSMutableString *statusText;
@property (nonatomic, retain) NSMutableString *completeStatusText;
@property (nonatomic, retain) NSMutableString *dep_nameText;
@property (nonatomic, retain) NSMutableString *type_nameText;
@property (nonatomic, retain) NSMutableString *prog_nameText;

@property (nonatomic, retain) UITapGestureRecognizer *resignResponder;

@property (nonatomic, retain) UIView *activityIndicator;

@end

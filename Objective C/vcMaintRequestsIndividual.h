//
//  vcMaintRequestsIndividual.h
//  MaintenanceRequestsBBB
//
//  Created by Brian Adams on 6/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface vcMaintRequestsIndividual : UIViewController <UITextViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    IBOutlet UILabel *progText;
    IBOutlet UILabel *typeText;
    IBOutlet UILabel *daysLabel;
    IBOutlet UILabel *daysText;
    IBOutlet UILabel *dateLabel;
    IBOutlet UILabel *dateText;
    IBOutlet UILabel *depLabel;
    IBOutlet UILabel *depText;
    IBOutlet UILabel *locationLabel;
    IBOutlet UILabel *locationText;
    IBOutlet UILabel *infoText;
    IBOutlet UILabel *descriptionLabel;
    IBOutlet UILabel *messageLabel;
    
    IBOutlet UITextView *descriptionText;
    
    IBOutlet UIScrollView *scroll;
    IBOutlet UIView *mainView;
    IBOutlet UIView *imageGrid;
    IBOutlet UIView *messageView;
    
    NSString *req_id;
    NSString *streetnum;
    NSString *address;
    NSString *info;
    NSString *description;
    NSString *completeStatus;
    NSString *date;
    NSString *numDays;
    NSString *dep_name;
    NSString *type_name;
    NSString *prog_name;

    NSMutableDictionary *imgDict;
    NSMutableDictionary *messageDict;
    
    UIButton *addCommentButton;
    UIButton *updateStatusButton;
    
    UIView *activityIndicator;
}

- (IBAction)openImage:(id)sender;
- (IBAction)updateRequest:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *progText;
@property (strong, nonatomic) IBOutlet UILabel *typeText;
@property (strong, nonatomic) IBOutlet UILabel *daysLabel;
@property (strong, nonatomic) IBOutlet UILabel *daysText;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateText;
@property (strong, nonatomic) IBOutlet UILabel *depLabel;
@property (strong, nonatomic) IBOutlet UILabel *depText;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) IBOutlet UILabel *locationText;
@property (strong, nonatomic) IBOutlet UILabel *infoText;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *messageLabel;

@property (strong, nonatomic) IBOutlet UITextView *descriptionText;

@property (strong, nonatomic) IBOutlet UIScrollView *scroll;
@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) IBOutlet UIView *imageGrid;
@property (strong, nonatomic) IBOutlet UIView *messageView;

@property (strong, nonatomic) NSString *req_id;
@property (strong, nonatomic) NSString *streetnum;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *info;
@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) NSString *completeStatus;
@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSString *numDays;
@property (strong, nonatomic) NSString *dep_name;
@property (strong, nonatomic) NSString *type_name;
@property (strong, nonatomic) NSString *prog_name;

@property (strong, nonatomic) NSMutableDictionary *imgDict;
@property (strong, nonatomic) NSMutableDictionary *messageDict;

@property (strong, nonatomic)UIButton *addCommentButton;
@property (strong, nonatomic)UIButton *updateStatusButton;

@property (nonatomic, retain) UIView *activityIndicator;

@end
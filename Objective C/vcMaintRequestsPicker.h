//
//  vcMaintRequestsPicker.h
//  MaintenanceRequestsBBB
//
//  Created by Brian Adams on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface vcMaintRequestsPicker : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    // variable to tell table what info to populate
    NSString *tableToLoad;
    
    IBOutlet UITableView *tablePicker;
    NSArray *keys;
    NSDictionary *optionsDict;
    
    SEL selector;
    id target;
    NSUInteger selectedRow;
    NSUInteger fieldTag;
    NSUInteger progID;
    NSString *pickedValue;
    NSString *pickedID;
    
    UIView *activityIndicator;
}

-(IBAction)setPickedOption:(id)sender;

@property (strong, nonatomic) NSString *tableToLoad;

// table view
@property (nonatomic, retain) IBOutlet UITableView *tablePicker;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@property (nonatomic, retain) NSArray *keys;
@property (nonatomic, retain) NSDictionary *optionsDict;

@property (nonatomic) SEL selector;
@property (nonatomic, retain) id target;
@property (nonatomic) NSUInteger selectedRow;
@property (nonatomic) NSUInteger fieldTag;
@property (nonatomic) NSUInteger progID;
@property (nonatomic, retain) NSString *pickedValue;
@property (nonatomic, retain) NSString *pickedID;

@property (strong, nonatomic) UIView *activityIndicator;

@end

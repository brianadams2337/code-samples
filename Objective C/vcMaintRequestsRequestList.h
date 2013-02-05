//
//  vcMaintRequestsRequestList.h
//  MaintenanceRequestsBBB
//
//  Created by Brian Adams on 6/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface vcMaintRequestsRequestList : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
{
    IBOutlet UITableView *tableReload;
    IBOutlet UISearchBar *searchBarInput;
    
    NSMutableArray *keysCellSorted;
    
    UIView *activityIndicator;
    
    UIToolbar *footer;
    UISegmentedControl *btnOpenClose;
    
    NSInteger filterSetting;
}

- (IBAction)logout:(id)sender;
- (IBAction)filterRequests:(UISegmentedControl*)sender;

@property (nonatomic, retain) UITableView *tableReload;
@property (nonatomic, retain) UISearchBar *searchBarInput;

@property (nonatomic, retain) NSMutableArray *keysCellSorted;

@property (nonatomic, retain) UIView *activityIndicator;

@property (strong, nonatomic) UIToolbar *footer;
@property (strong, nonatomic) UISegmentedControl *btnOpenClose;

@property (nonatomic) NSInteger filterSetting;

@end

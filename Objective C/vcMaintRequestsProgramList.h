//
//  vcMaintRequestsProgramList.h
//  MaintenanceRequestsBBB
//
//  Created by Brian Adams on 6/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "vcMaintRequestsRequestList.h"

@interface vcMaintRequestsProgramList : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView *tablePrograms;
    NSArray *keysCellsSorted;
    UIView *activityIndicator;
}

@property (strong, nonatomic) UITableView *tablePrograms;
@property (nonatomic, retain) NSArray *keysCellsSorted;
@property (nonatomic, retain) UIView *activityIndicator;

@end

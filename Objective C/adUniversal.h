//
//  adUniversal.h
//  MaintenanceRequestsBBB
//
//  Created by Brian Adams on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "vcMaintRequestsProgramList.h"

@class ViewController;

@interface adUniversal : NSObject {
    UIWindow *window;
    ViewController *viewController;
    NSString *email;
    NSString *password;
    NSMutableDictionary *userDict;
    NSMutableDictionary *userProgramsDict;
    NSMutableDictionary *currentDictMaintRequests;
    NSMutableDictionary *currentDictPOI;
    NSMutableDictionary *localDictMaintRequests;
    NSMutableDictionary *localDictPOI;
    NSString *selectedProgram;
    NSString *selectedProgramItem;
    NSString *currentVersion;
}

+ (void)logout:(id)view;
+ (NSMutableDictionary *)downloadCurrentDict:(id)email:(id)pass:(NSString *)dict;
+ (void)uploadChangesMaintRequests:(id)dict:(BOOL)comment;
+ (void)uploadChangesPOI:(id)dict:(BOOL)interaction;
+ (NSString *) checkVersion;
+ (NSString *) stripTags:(NSString *)str;
+ (NSString *) stripSlashes:(NSString *)str;
+ (NSString *) convertUNIXtoDate:(NSString *)timestamp;
+ (UIImage *) setImageOrientation:(UIImage *)image;
+ (UIView *) loadActivityIndicator:(NSString *)message;

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ViewController *viewController;
@property (nonatomic, retain) UINavigationController *navController;

@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSMutableDictionary *userDict;
@property (strong, nonatomic) NSMutableDictionary *userProgramsDict;
@property (strong, nonatomic) NSMutableDictionary *currentDictMaintRequests;
@property (strong, nonatomic) NSMutableDictionary *currentDictPOI;
@property (strong, nonatomic) NSMutableDictionary *localDictMaintRequests;
@property (strong, nonatomic) NSMutableDictionary *localDictPOI;

@property (strong, nonatomic) NSString *selectedProgram;
@property (strong, nonatomic) NSString *selectedProgramItem;

@property (nonatomic, retain) NSString *currentVersion;

@end
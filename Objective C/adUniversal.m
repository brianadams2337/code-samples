//
//  adUniversal.m
//  MaintenanceRequestsBBB
//
//  Created by Brian Adams on 6/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "adUniversal.h"
#import "ViewController.h"

@implementation adUniversal

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize navController;
@synthesize email;
@synthesize password;
@synthesize userDict;
@synthesize userProgramsDict;
@synthesize currentDictMaintRequests;
@synthesize currentDictPOI;
@synthesize localDictMaintRequests;
@synthesize localDictPOI;
@synthesize selectedProgram;
@synthesize selectedProgramItem;
@synthesize currentVersion;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    // global variables
    userDict = [[NSMutableDictionary alloc] init];
    userProgramsDict = [[NSMutableDictionary alloc] init];
    currentDictMaintRequests = [[NSMutableDictionary alloc] init];
    currentDictPOI = [[NSMutableDictionary alloc] init];
    localDictMaintRequests = [[NSMutableDictionary alloc] init];
    localDictPOI = [[NSMutableDictionary alloc] init];
    selectedProgram = [[NSString alloc] init];
    selectedProgramItem = [[NSString alloc] init];
    currentVersion = [NSString stringWithFormat:@"%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

// LOGOUT FUNCTION
+ (void)logout:(id)view
{
    [view dismissModalViewControllerAnimated:YES];
}

// DOWNLOAD AND UPDATE CURRENT DICTIONARY
+ (NSMutableDictionary *)downloadCurrentDict:(id)email :(id)pass :(NSString *)dict
{
    NSString *urlString = [[NSString alloc] init];
    // URL to download db (json string) from
    if (dict == @"maintReports") {
        urlString = [NSString stringWithFormat:@"http://dev.blockbyblock.com/m/requests.php"];
    } else if (dict == @"POI") {
        urlString = [NSString stringWithFormat:@"http://dev.blockbyblock.com/m/persons.php"];
    }
    
    // error and respnse variables
    NSError *error;
    NSHTTPURLResponse *response = nil;
    
    // set up POST request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30.0];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[[NSString stringWithFormat:@"email=%@&pass=%@", email, pass] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // connect to server Synchronously to make sure data is completely downloaded before continuing
    NSData *connection = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if (connection) {
        
        // create universally accessible dictionary from downloaded data string
        NSError *error;
        NSMutableDictionary *tmpCurrentDict = [[NSMutableDictionary alloc] init];
        tmpCurrentDict = [NSJSONSerialization JSONObjectWithData:connection options:kNilOptions error:&error];
        
        // return dictionary for use within app
        return tmpCurrentDict;

    } else {
        
        // failsafe to make sure method finishes
        return 0;
        
    }
}

// UPLOAD CHANGES TO DATABASE
+ (void)uploadChangesMaintRequests:(id)dict:(BOOL)comment
{
    if (comment) {
        for (int i = 0; i < [dict count]; i++) {
            // set up connection method
            NSString *urlString = @"http://dev.blockbyblock.com/m/messageprocess.php";
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30.0];
            [request setHTTPMethod:@"POST"];
        
            // create body for the request
            NSMutableData *body = [NSMutableData data];

            // open request and set header
            NSString *boundary = @"---------------------------14737809831466499882746641449";
            NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
            [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
            
            // add text input values
            
            // processrequests
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Disposition: form-data; name=\"processmessages\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"1"] dataUsingEncoding:NSUTF8StringEncoding]];
            
            // unique id (req_id)
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Disposition: form-data; name=\"req_id\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"%@", [[dict objectForKey:[NSNumber numberWithInt:i]] valueForKey:@"req_id"]] dataUsingEncoding:NSUTF8StringEncoding]];
            
            // user id (user_id)
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Disposition: form-data; name=\"user_id\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"%@", [[dict objectForKey:[NSNumber numberWithInt:i]] valueForKey:@"user_id"]] dataUsingEncoding:NSUTF8StringEncoding]];
            
            // program id (prog)id)
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Disposition: form-data; name=\"prog_id\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"%@", [[dict objectForKey:[NSNumber numberWithInt:i]] valueForKey:@"prog_id"]] dataUsingEncoding:NSUTF8StringEncoding]];
            
            // date
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Disposition: form-data; name=\"date\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"%@", [[dict objectForKey:[NSNumber numberWithInt:i]] valueForKey:@"date"]] dataUsingEncoding:NSUTF8StringEncoding]];
            
            // message (comment)
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Disposition: form-data; name=\"message\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"%@", [[dict objectForKey:[NSNumber numberWithInt:i]] valueForKey:@"message"]] dataUsingEncoding:NSUTF8StringEncoding]];
            
            // add images (jpg) to upload form
            int imgCount = [[[dict objectForKey:[NSNumber numberWithInt:i]] objectForKey:@"images"] count];
            if (imgCount > 0) {
                for (int j = 0; j < imgCount; j++)
                {
                    UIImage *tmp = [[[dict objectForKey:[NSNumber numberWithInt:i]] objectForKey:@"images"] objectForKey:[NSString stringWithFormat:@"%i", j]];
                    NSData *imageData = UIImageJPEGRepresentation(tmp, 100);
                    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile%i\"; filename=\".jpg\"\r\n", j] dataUsingEncoding:NSUTF8StringEncoding]];
                    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                    [body appendData:[NSData dataWithData: imageData]];
                    NSLog(@"%i", j);
                }
            }
            
            // close request
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            
            [request setHTTPBody:body];
            
            // Connect to server Synchronously to make sure user data is completely downloaded before continuing
            NSError *error;
            NSHTTPURLResponse *response = nil;
            NSData *connection = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            
            NSMutableDictionary *uploadResult = [NSJSONSerialization JSONObjectWithData:connection options:kNilOptions error:&error];
            NSLog(@"%@", uploadResult);
            
            if (connection)
            {
                // remove object from local dictionary
                [dict removeObjectForKey:[NSNumber numberWithInt:i]];
                NSString *statusText = [NSString stringWithString:[uploadResult objectForKey:@"message"]];
                //NSString *statusText = [NSString stringWithString:@"comment verification"];
                UIAlertView *uploadStatus = [[UIAlertView alloc] initWithTitle:@"Comment Status" message:statusText delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [uploadStatus show];
            }
            
        }
        
    }
    else
    {
    for (int i = 0; i < [dict count]; i++) {
        
        // set up connection method
        NSString *urlString = @"http://dev.blockbyblock.com/m/maintenanceprocess.php";
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30.0];
        [request setHTTPMethod:@"POST"];
        
        // create body for the request
        NSMutableData *body = [NSMutableData data];
        
        // open request and set header
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
        [request addValue:contentType forHTTPHeaderField:@"Content-Type"];

        // add text input values
        
        // unique id (req_id)
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data; name=\"req_id\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@", [[dict objectForKey:[NSNumber numberWithInt:i]] valueForKey:@"req_id"]] dataUsingEncoding:NSUTF8StringEncoding]];
        
        // user id (user_id)
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data; name=\"user_id\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@", [[dict objectForKey:[NSNumber numberWithInt:i]] valueForKey:@"user_id"]] dataUsingEncoding:NSUTF8StringEncoding]];
        
        // processrequests
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data; name=\"processrequests\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"1"] dataUsingEncoding:NSUTF8StringEncoding]];
        
        // program id (prog)id)
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data; name=\"prog_id\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@", [[dict objectForKey:[NSNumber numberWithInt:i]] valueForKey:@"prog_id"]] dataUsingEncoding:NSUTF8StringEncoding]];
        
        // maintenance type id (type_id)
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data; name=\"main_id\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@", [[dict objectForKey:[NSNumber numberWithInt:i]] valueForKey:@"type_id"]] dataUsingEncoding:NSUTF8StringEncoding]];
        
        // department id (dep_id)
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data; name=\"dep_id\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@", [[dict objectForKey:[NSNumber numberWithInt:i]] valueForKey:@"dep_id"]] dataUsingEncoding:NSUTF8StringEncoding]];
        
        // date
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data; name=\"date\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@", [[dict objectForKey:[NSNumber numberWithInt:i]] valueForKey:@"date"]] dataUsingEncoding:NSUTF8StringEncoding]];
        
        // street address number (streetnum)
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data; name=\"streetnum\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@", [[dict objectForKey:[NSNumber numberWithInt:i]] valueForKey:@"streetnum"]] dataUsingEncoding:NSUTF8StringEncoding]];
        
        // street address name (address)
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data; name=\"address\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@", [[dict objectForKey:[NSNumber numberWithInt:i]] valueForKey:@"address"]] dataUsingEncoding:NSUTF8StringEncoding]];
        
        // additional information (info)
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data; name=\"info\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@", [[dict objectForKey:[NSNumber numberWithInt:i]] valueForKey:@"info"]] dataUsingEncoding:NSUTF8StringEncoding]];
        
        // status of request (completion)
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data; name=\"complete\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@", [[dict objectForKey:[NSNumber numberWithInt:i]] valueForKey:@"complete"]] dataUsingEncoding:NSUTF8StringEncoding]];
        
        // date of completion (completeDate)
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data; name=\"completeDate\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@", [[dict objectForKey:[NSNumber numberWithInt:i]] valueForKey:@"completeDate"]] dataUsingEncoding:NSUTF8StringEncoding]];
        
        // request description (description)
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data; name=\"description\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@", [[dict objectForKey:[NSNumber numberWithInt:i]] valueForKey:@"description"]] dataUsingEncoding:NSUTF8StringEncoding]];

        // add images (jpg) to upload form
        int imgCount = [[[dict objectForKey:[NSNumber numberWithInt:i]] objectForKey:@"images"] count];
        if (imgCount > 0) {
            for (int j = 0; j < imgCount; j++)
            {
                UIImage *tmp = [[[dict objectForKey:[NSNumber numberWithInt:i]] objectForKey:@"images"] objectForKey:[NSString stringWithFormat:@"%i", j]];
                NSData *imageData = UIImageJPEGRepresentation(tmp, 100);
                [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile%i\"; filename=\".jpg\"\r\n", j] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[NSData dataWithData: imageData]];
                NSLog(@"%i", j);
            }
        }
        
        // close request
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];

        // set body for the request
        [request setHTTPBody:body];
        
        // Connect to server Synchronously to make sure user data is completely downloaded before continuing
        NSError *error;
        NSHTTPURLResponse *response = nil;
        NSData *connection = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        NSMutableDictionary *uploadResult = [NSJSONSerialization JSONObjectWithData:connection options:kNilOptions error:&error];
        NSLog(@"%@", uploadResult);
        
        if (connection)
        {
            // remove object from local dictionary
            [dict removeObjectForKey:[NSNumber numberWithInt:i]];
            NSString *statusText = [NSString stringWithString:[uploadResult objectForKey:@"message"]];
            UIAlertView *uploadStatus = [[UIAlertView alloc] initWithTitle:@"Request Status" message:statusText delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [uploadStatus show];
        }
        
    }
        
    }
    
}

+ (NSString *) checkVersion
{
    // set up connection method
    NSString *urlString = @"http://dev.blockbyblock.com/m/updatecheck.php";
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30.0];
    [request setHTTPMethod:@"POST"];
    
    // create body for the request
    NSMutableData *body = [NSMutableData data];
    
    [request setHTTPBody:body];
    
    // Connect to server Synchronously to make sure user data is completely downloaded before continuing
    NSError *error;
    NSHTTPURLResponse *response = nil;
    NSData *connection = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSMutableDictionary *versionResult = [NSJSONSerialization JSONObjectWithData:connection options:kNilOptions error:&error];
    
    if (connection)
    {
        return [NSString stringWithString:[versionResult objectForKey:@"version"]];
    }
    else {
        return @"no connection";
    }
}

+ (NSString *) stripTags:(NSString *)str
{
    NSMutableString *ms = [NSMutableString stringWithCapacity:[str length]];
    
    NSScanner *scanner = [NSScanner scannerWithString:str];
    [scanner setCharactersToBeSkipped:nil];
    NSString *s = nil;
    while (![scanner isAtEnd])
    {
        [scanner scanUpToString:@"<" intoString:&s];
        if (s != nil)
            [ms appendString:s];
        [scanner scanUpToString:@">" intoString:NULL];
        if (![scanner isAtEnd])
            [scanner setScanLocation:[scanner scanLocation]+1];
        s = nil;
    }
    
    return ms;
}

+ (NSString *) stripSlashes:(NSString *)str
{
    str = [str stringByReplacingOccurrencesOfString:@"\'" withString:@"'"];
    str = [str stringByReplacingOccurrencesOfString:@"\\\"" withString:@"\""];
    
    return str;
}

+ (NSString *) convertUNIXtoDate:(NSString*)timestamp
{
    NSTimeInterval tmp = [timestamp doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:tmp];
    NSDateFormatter *formattedDate = [[NSDateFormatter alloc]init];
    [formattedDate setDateFormat:@"EEE MMM dd, yyyy"];
    
    return [formattedDate stringFromDate:date];
}

+ (UIImage *) setImageOrientation:(UIImage*)img
{
    // set max image size
    int imageSizeMax = 600;
    
    CGImageRef imageRef = img.CGImage;
    
    CGFloat width = CGImageGetWidth(imageRef);
    CGFloat height = CGImageGetHeight(imageRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds =  CGRectMake(0, 0, width, height);
    if (width > imageSizeMax || height > imageSizeMax) {  
        CGFloat ratio = width/height;  
        if (ratio > 1) {  
            bounds.size.width = imageSizeMax;  
            bounds.size.height = bounds.size.width / ratio;  
        }  
        else {  
            bounds.size.height = imageSizeMax;  
            bounds.size.width = bounds.size.height * ratio;  
        }  
    }  
    
    CGFloat scaleRatio = bounds.size.width / width;  
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imageRef), CGImageGetHeight(imageRef));  
    CGFloat boundHeight;  
    UIImageOrientation orient = img.imageOrientation;
    
    switch (orient) {
        case UIImageOrientationUp:
            // EXIF 0
            transform = CGAffineTransformIdentity;
            break;
        case UIImageOrientationUpMirrored:
            // EXIF 1
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
        case UIImageOrientationDown:
            // EXIF 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        case UIImageOrientationDownMirrored:
            // EXIF 3
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
        case UIImageOrientationLeftMirrored:
            // EXIF 4
            boundHeight = bounds.size.height;  
            bounds.size.height = bounds.size.width;  
            bounds.size.width = boundHeight;  
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);  
            transform = CGAffineTransformScale(transform, -1.0, 1.0);  
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
        case UIImageOrientationLeft:
            // EXIF 5
            boundHeight = bounds.size.height;  
            bounds.size.height = bounds.size.width;  
            bounds.size.width = boundHeight;  
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);  
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
        case UIImageOrientationRightMirrored:
            // EXIF 6
            boundHeight = bounds.size.height;  
            bounds.size.height = bounds.size.width;  
            bounds.size.width = boundHeight;  
            transform = CGAffineTransformMakeScale(-1.0, 1.0);  
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
        case UIImageOrientationRight:
            // EXIF 7
            boundHeight = bounds.size.height;  
            bounds.size.height = bounds.size.width;  
            bounds.size.width = boundHeight;  
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);  
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
        default:
            transform = CGAffineTransformIdentity;
            break;
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {  
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);  
        CGContextTranslateCTM(context, -height, 0);  
    }  
    else {  
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);  
        CGContextTranslateCTM(context, 0, -height);  
    } 
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imageRef);
    UIImage *updatedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return updatedImage;
}

+ (UIView *) loadActivityIndicator:(NSString *)message
{
    // Activity Indicator
    UIView *overlayView = [[UIView alloc] init];
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] init];
    UILabel *activityStatus = [[UILabel alloc] init];
    
    // overlay view
    CGRect frOverlayView = CGRectMake(0, 0, 320, 420);
    overlayView = [[UIView alloc] initWithFrame:frOverlayView];
    [overlayView setBackgroundColor:[UIColor whiteColor]];
    [overlayView setAlpha:1.0];
    [overlayView setHidden:NO];
    
    // activity indicator
    CGRect frActivityIndicator = CGRectMake(145, 165, 30, 30);
    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:frActivityIndicator];
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [overlayView addSubview:activityIndicator];
    [overlayView bringSubviewToFront:activityIndicator];
    [activityIndicator startAnimating];
    
    // activity status text
    CGRect frActivityStatus = CGRectMake(20, 190, 280, 30);
    activityStatus = [[UILabel alloc] initWithFrame:frActivityStatus];
    [activityStatus setText:message];
    [activityStatus setFont:[UIFont fontWithName:@"OpenSans-Bold" size:12]];
    [activityStatus setTextAlignment:UITextAlignmentCenter];
    [activityStatus setTextColor:[UIColor blackColor]];
    [overlayView addSubview:activityStatus];
    [overlayView bringSubviewToFront:activityStatus];
    
    return overlayView;
}


@end

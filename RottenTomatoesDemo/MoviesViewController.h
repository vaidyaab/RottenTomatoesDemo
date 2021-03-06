//
//  MoviesViewController.h
//  RottenTomatoesDemo
//
//  Created by Abhijeet Vaidya on 6/4/14.
//  Copyright (c) 2014 yahoo inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD.h>

@interface MoviesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, MBProgressHUDDelegate>

@property (nonatomic) BOOL networkAvailable;
//- (void) startNetworkMonitor;
- (void) reachabilityChanged:(NSNotification *)note;

- (id) initWithRTURL:(NSString*) apiEndPointParam title:(NSString*) titleParam;

@end

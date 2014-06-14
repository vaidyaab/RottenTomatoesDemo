//
//  AppDelegate.m
//  RottenTomatoesDemo
//
//  Created by Abhijeet Vaidya on 6/4/14.
//  Copyright (c) 2014 yahoo inc. All rights reserved.
//

#import "AppDelegate.h"
#import "MoviesViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    MoviesViewController *boxOfficeViewController = [[MoviesViewController alloc]
                                                     initWithRTURL:@"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=g9au4hv6khv6wzvzgt55gpqs"
                                                     title: @"Box Office"];
    UINavigationController *boxOfficeNavController = [[UINavigationController alloc] initWithRootViewController:boxOfficeViewController];
    boxOfficeNavController.tabBarItem.image = [UIImage imageNamed:@"ticket.png"];
    boxOfficeNavController.title = @"Box Office Movies";
    
    MoviesViewController *topDVDsViewController = [[MoviesViewController alloc] initWithRTURL:@"http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=g9au4hv6khv6wzvzgt55gpqs"
                                                    title: @"Top DVDs"];
    UINavigationController *topDVDsNavController = [[UINavigationController alloc] initWithRootViewController:topDVDsViewController];
    topDVDsNavController.tabBarItem.image = [UIImage imageNamed:@"disc.png"];
    topDVDsNavController.title = @"Top DVD Rentals";
    
    UITabBarController *tbc = [[UITabBarController alloc] init];
    [tbc setViewControllers:[NSArray arrayWithObjects:boxOfficeNavController, topDVDsNavController, nil]];
    [tbc.view setBackgroundColor:[UIColor lightGrayColor]];
    self.window.rootViewController = tbc;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
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

@end

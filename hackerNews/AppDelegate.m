//
//  AppDelegate.m
//  hackerNews
//
//  Created by Stephen Derico on 11/4/11.
//  Copyright (c) 2011 Bixby Apps. All rights reserved.
//
#import "Flurry.h"

#import "AppDelegate.h"

#import "MasterViewController.h"

#import "DetailViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize navigationController = _navigationController;
@synthesize splitViewController = _splitViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
    

    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    MasterViewController *masterViewController = [[MasterViewController alloc] initWithStyle:UITableViewStylePlain];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:masterViewController];
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}

@end

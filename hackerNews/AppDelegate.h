//
//  AppDelegate.h
//  hackerNews
//
//  Created by Stephen Derico on 11/4/11.
//  Copyright (c) 2011 Bixby Apps. All rights reserved.
//
// TODO: Add Safari Reader 
// TODO: Change TableView background
// TODO: Add WebView Caching
// TODO: Resize TableViewCells
// TODO: Hiding NavBar
// TODO: Modal Safari?


#import <UIKit/UIKit.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UINavigationController *navigationController;

@property (strong, nonatomic) UISplitViewController *splitViewController;

@end

//
//  MasterViewController.h
//  hackerNews
//
//  Created by Stephen Derico on 11/4/11.
//  Copyright (c) 2011 Bixby Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController {
    NSArray *_stories;
    
}

@property (strong, nonatomic) DetailViewController *detailViewController;
@property (nonatomic, retain) NSArray *stories;
- (void)downloadStories;
@end

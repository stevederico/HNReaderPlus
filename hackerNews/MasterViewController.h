//
//  MasterViewController.h
//  hackerNews
//
//  Created by Stephen Derico on 11/4/11.
//  Copyright (c) 2011 Bixby Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoryFetcher.h"
#import "EGORefreshTableHeaderView.h"
@class DetailViewController;

@interface MasterViewController : UITableViewController <StoryFetcherDelegate,EGORefreshTableHeaderDelegate> {
    NSArray *_stories;
    StoryFetcher *_fetcher;
    
	EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;

}

@property (strong, nonatomic) DetailViewController *detailViewController;
@property (nonatomic, retain) NSArray *stories;
@property (nonatomic, retain) StoryFetcher *fetcher;
- (void)downloadStories;
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;
- (void)setupNavBar;
- (void)setupRefreshHeader;
@end

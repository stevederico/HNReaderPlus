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
#import "SDFooterButton.h"
#import <MessageUI/MessageUI.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController <StoryFetcherDelegate,EGORefreshTableHeaderDelegate,SDFooterButtonDelegate,MFMailComposeViewControllerDelegate >

@property (nonatomic, strong) DetailViewController *detailViewController;
@property (nonatomic, strong) NSArray *stories;
@property (nonatomic, strong) StoryFetcher *fetcher;
- (void)downloadStories;
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;
- (void)setupNavBar;
- (void)setupRefreshHeader;
- (void)footerButtonTapped;
@end

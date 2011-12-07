//
//  DetailViewController.h
//  hackerNews
//
//  Created by Stephen Derico on 11/4/11.
//  Copyright (c) 2011 Bixby Apps. All rights reserved.
//
#import "CommentViewController.h"
#import "CommentFetcher.h"
#import <UIKit/UIKit.h>
#import "Story.h"


@interface DetailViewController : UIViewController <UISplitViewControllerDelegate,UIWebViewDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate> {
    BOOL isLoading;
}

@property (nonatomic, retain) Story *story;
@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) UIActivityIndicatorView *activityView;
@property (nonatomic, retain) UILabel *l;
@property (nonatomic, retain) NSArray *comments;

- (void)handleTapFrom:(id)sender;
- (void)handleSwipe:(id)sender;
- (void)setupNavBar;

@end

//
//  CommentViewController.h
//  hackerNews
//
//  Created by Stephen Derico on 11/20/11.
//  Copyright (c) 2011 Bixby Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Comment.h"
#import "CommentFetcher.h"
#import "Story.h"

@interface CommentViewController : UITableViewController <CommentFetcherDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, retain) NSArray *comments;
@property (nonatomic, retain) Story *story;
@property (nonatomic, retain) UIActivityIndicatorView *activityView;
@property (nonatomic, retain) UILabel *l;
- (void)handleTapFrom:(id)sender;
- (void)addTap;
- (void)fetchComments;
- (void)commentsFailed;
@end

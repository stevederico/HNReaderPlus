//
//  DetailViewController.h
//  hackerNews
//
//  Created by Stephen Derico on 11/4/11.
//  Copyright (c) 2011 Bixby Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Story.h"

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate,UIWebViewDelegate> {

    Story *_story;
    UIWebView *_webView;
    BOOL isLoading;

}


@property (nonatomic, retain) Story *story;
@property (nonatomic, retain) UIWebView *webView;

@end

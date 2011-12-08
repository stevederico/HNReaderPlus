//
//  DetailViewController.m
//  hackerNews
//
//  Created by Stephen Derico on 11/4/11.
//  Copyright (c) 2011 Bixby Apps. All rights reserved.
//
#import "DetailViewController.h"
#import <Twitter/TWTweetComposeViewController.h>
#import <Accounts/Accounts.h>

@implementation DetailViewController

@synthesize story = _story;
@synthesize webView = _webView;
@synthesize l = _l,activityView = _activityView;
@synthesize comments;

#pragma mark - Managing the detail item

- (id)init {
    self = [super init];
    if (self) {
        [self.view setFrame:self.view.bounds];
         
        self.webView.scalesPageToFit = YES;
        self.webView.multipleTouchEnabled = YES;
        self.webView.opaque = NO;
        self.webView.delegate = self;
        self.webView.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
        [self.navigationController.navigationBar setAlpha:0.0];
        
       
        self.l = [[UILabel alloc] initWithFrame:CGRectMake(115, 230, 100, 20)];
        self.l.text = @"Loading...";
        self.l.backgroundColor = [UIColor clearColor];
        self.l.textColor = [UIColor whiteColor];
        self.l.shadowOffset = CGSizeMake(0, 1);
        [self.l setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17.0]];
        self.l.textAlignment = UITextAlignmentCenter;
        
        self.activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(135, 180, 50, 50)];
        self.activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        [self.activityView setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin)];
        
    
        
        return self;
    }

    return nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.webView.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
    tapRecognizer.numberOfTapsRequired = 1;
    tapRecognizer.delegate = self;
    
    
    UIWebView *web = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.webView.delegate = self;
    self.webView = web;
    [self.webView addGestureRecognizer:tapRecognizer];
    
    [self.view addSubview:self.webView];
    
  
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL: [NSURL URLWithString:self.story.url]];
    
    [self.webView loadRequest:req];
      [self setupNavBar];
}


- (void)viewDidUnload {
    [self setWebView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
}

#pragma mark - UIWebView Delegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
   
    if (isLoading == TRUE) {
        return;
    }
    
    NSLog(@"loading...");
    isLoading = TRUE;
    [self.view addSubview:self.l];
    [self.activityView startAnimating];
    [self.view addSubview:self.activityView];


}

- (void)webViewDidFinishLoad:(UIWebView *)webView {

    self.webView.backgroundColor = [UIColor whiteColor];
    [self.activityView setHidden:YES];
    [self.l setHidden:YES];
   
}



#pragma GestureRecognizer Delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
   
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
      
    return YES;
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
     
    return YES;
}

#pragma DetailViewController

- (void)handleTapFrom:(id)sender{

    if (self.navigationController.navigationBar.alpha == 0.0) {

        self.navigationController.navigationBar.hidden = NO;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
        [self.navigationController.navigationBar setAlpha:1.0];
        [UIView commitAnimations];
    } else {
     
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
        [self.navigationController.navigationBar setAlpha:0.0];
        [UIView commitAnimations];
    
    }
    
}

- (void) showComments{    
   CommentViewController *cvc = [[CommentViewController alloc] initWithStyle:UITableViewStyleGrouped];
   cvc.story = self.story;
   [self.navigationController pushViewController:cvc animated:YES];
}
- (void) sendTweet{
    
    if([TWTweetComposeViewController canSendTweet]) {
        
        TWTweetComposeViewController *controller = [[TWTweetComposeViewController alloc] init];
         [controller setInitialText:self.story.title];
        [controller addURL:[NSURL URLWithString:self.story.url]];
        [self.navigationController presentModalViewController:controller animated:YES];
        controller.completionHandler = ^(TWTweetComposeViewControllerResult result)  {
            
            [self dismissModalViewControllerAnimated:YES];
            
            switch (result) {
                case TWTweetComposeViewControllerResultCancelled:
                    break;
                    
                case TWTweetComposeViewControllerResultDone:
                    break;
                    
                default:
                    break;
            }
        };
    }else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=TWITTER"]];
    }
    
}


- (void)setupNavBar {
     if (self.story.commentCount.intValue == 0) {
         UIBarButtonItem *tButton = [[UIBarButtonItem alloc] initWithTitle:@"Tweet" style:UIBarButtonItemStylePlain target:self action:@selector(sendTweet)];
         tButton.style = UIBarButtonItemStyleBordered;
         self.navigationItem.rightBarButtonItem = tButton;
         return;
     }
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, -1, 150, 44)];
    [toolbar setBarStyle:-1];
    [toolbar setTintColor:[UIColor blackColor]];
    
    
    NSMutableArray *array = [[NSMutableArray alloc] init];

    UIBarButtonItem *cButton = [[UIBarButtonItem alloc] initWithTitle:@"Comments" style:UIBarButtonItemStylePlain target:self action:@selector(showComments)];
    cButton.style = UIBarButtonItemStyleBordered;
    [array addObject:cButton];
    [cButton setTintColor:[UIColor blackColor]];

  
    
    UIBarButtonItem *tButton = [[UIBarButtonItem alloc] initWithTitle:@"Tweet" style:UIBarButtonItemStylePlain target:self action:@selector(sendTweet)];
    tButton.style = UIBarButtonItemStyleBordered;
        [array addObject:tButton];
    
    [toolbar setItems:array];
    
    UIBarButtonItem *twoButtons = [[UIBarButtonItem alloc] initWithCustomView:toolbar];

    self.navigationItem.rightBarButtonItem = twoButtons;

   
}



@end

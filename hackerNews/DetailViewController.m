//
//  DetailViewController.m
//  hackerNews
//
//  Created by Stephen Derico on 11/4/11.
//  Copyright (c) 2011 Bixby Apps. All rights reserved.
//

#import "DetailViewController.h"

@implementation DetailViewController

@synthesize story = _story;
@synthesize webView = _webView;


#pragma mark - Managing the detail item

- (id)init {
    self = [super init];
    if (self) {
        [self.view setFrame:self.view.bounds];
   
        return self;
    }

    return nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)webViewDidStartLoad:(UIWebView *)webView {
   
    
    if (isLoading == TRUE) {
        return;
    }
    NSLog(@"loading...");
    isLoading = TRUE;
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [activityView sizeToFit];
    [activityView setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin)];
    UIBarButtonItem *loadingView = [[UIBarButtonItem alloc] initWithCustomView:activityView];
    [activityView startAnimating];
    [self.navigationItem setRightBarButtonItem:loadingView];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {

    [self.navigationItem setRightBarButtonItem:nil];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIWebView *web = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.webView.delegate = self;
    self.webView = web;
    [self.view addSubview:self.webView];
    self.webView.delegate = self;
    
   
        
 
 
	// Do any additional setup after loading the view, typically from a nib.
   
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL: [NSURL URLWithString:self.story.url]];
    self.title = self.story.title;
    NSLog(@"loading title %@",self.story.title);
//    [self.webView loadRequest:req];
//    [self.webView loadHTMLString:@"<H1>this is a HEADER</h1>" baseURL:[NSURL URLWithString:self.story.url]];
    
    
    
    NSString *cssPath = [[NSBundle mainBundle] pathForResource:@"styles" ofType:@"css"];
    
	//do base url for css
	NSString *path = [[NSBundle mainBundle] bundlePath];
	NSURL *baseURL = [NSURL fileURLWithPath:path];
    
	NSString *html =[NSString stringWithFormat:@"<html><head><link rel=\"stylesheet\"  href=\"%@\" type=\"text/css\" /></head><body><p>I am awesome html in sans-serif...here is a variable: %@ ...</p></body></html>",
                     cssPath ];
	NSLog(@"%@ : csspath",html);
	[self.webView loadHTMLString:html baseURL:baseURL];

    

}

- (void)viewDidUnload
{
    [self setWebView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
    
    
    // e.g. self.myOutlet = nil;
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}



							
//#pragma mark - Split view
//
//- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
//{
//    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
//    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
//    self.masterPopoverController = popoverController;
//}
//
//- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
//{
//    // Called when the view is shown again in the split view, invalidating the button and popover controller.
//    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
//    self.masterPopoverController = nil;
//}

@end

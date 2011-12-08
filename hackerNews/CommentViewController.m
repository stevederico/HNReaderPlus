//
//  CommentViewController.m
//  hackerNews
//
//  Created by Stephen Derico on 11/20/11.
//  Copyright (c) 2011 Bixby Apps. All rights reserved.
//

#import "CommentViewController.h"

@implementation CommentViewController
@synthesize comments, story,l,activityView;

- (id)initWithStyle:(UITableViewStyle)style{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.title = @"Comments";
        self.tableView.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
        
        self.activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(135, 180, 50, 50)];
        self.activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        [self.activityView setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin)];
        
        self.l = [[UILabel alloc] initWithFrame:CGRectMake(115, 230, 100, 20)];
        self.l.text = @"Loading...";
        self.l.backgroundColor = [UIColor clearColor];
        self.l.textColor = [UIColor whiteColor];
        self.l.shadowOffset = CGSizeMake(0, 1);
        [self.l setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17.0]];
        self.l.textAlignment = UITextAlignmentCenter;
        
        return self;
    }
    return nil;


}


- (void)viewDidAppear:(BOOL)animated{
        
    [self fetchComments];
    [self.activityView startAnimating];
    
    [self.view addSubview:self.l];
    [self.view addSubview:self.activityView];
    
    [self addTap];

}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.comments count];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
            cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
            cell.textLabel.numberOfLines = 0;
            cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0];
            cell.textLabel.backgroundColor = [UIColor clearColor];
            cell.textLabel.shadowOffset = CGSizeMake(0, 1);
            cell.backgroundColor = [UIColor lightTextColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    // Configure the cell.
    cell.textLabel.text = nil;
    cell.textLabel.text = [[self.comments objectAtIndex:indexPath.row] body];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellText = [[self.comments objectAtIndex:indexPath.row] body];
    UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:12.0];
    CGSize constraintSize = CGSizeMake(280.0f, 2000.0f);
    CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    
    return labelSize.height + 30;
    
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


- (void)fetchComments{
    CommentFetcher *cf = [[CommentFetcher alloc] init];
    cf.delegate = self;
    [cf fetchCommentsWithID:self.story.idNumber];
    NSLog(@"Fetching Comments for Story %@",[self.story.idNumber stringValue]);
    
}


- (void)addTap{
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
    tapRecognizer.numberOfTapsRequired = 1;
    tapRecognizer.delegate = self;
    [self.view addGestureRecognizer:tapRecognizer];
    
}


- (void)commentsComplete:(NSArray *)newComments{
    
    [self.activityView setHidden:YES];
    [self.l setHidden:YES];
    
    self.comments = newComments;
    [self.tableView reloadData];
    
}

- (void)commentsFailed{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Comments Not Currently Available" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [self.navigationController popViewControllerAnimated:YES];

    
}



@end

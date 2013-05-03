//
//  MasterViewController.m
//  hackerNews
//
//  Created by Stephen Derico on 11/4/11.
//  Copyright (c) 2011 Bixby Apps. All rights reserved.
//

#import "MasterViewController.h"
#import "StoryFetcher.h"
#import "DetailViewController.h"


@interface MasterViewController (){

	EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
    
}


@end

@implementation MasterViewController

@synthesize detailViewController = _detailViewController,stories = _stories, fetcher = _fetcher;

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.title = @"HackerNews";
      
    }
    return self;
}
							
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    self.stories = nil;
    self.fetcher = nil;
    
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self setupRefreshHeader];
    [self downloadStories];
    [self setupNavBar];
    
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (!self.stories) {
        [self downloadStories];
    }
   
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [self.navigationController.navigationBar setAlpha:0.0];
    [UIView commitAnimations];
}


#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)setupRefreshHeader{
	if (_refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
		view.delegate = self;
		[self.tableView addSubview:view];
		_refreshHeaderView = view;
        
	}
	
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
    
}


- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
    [self downloadStories];
	_reloading = YES;
	
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
	
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}

#pragma mark -
#pragma mark UITableView Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellText = [[self.stories objectAtIndex:indexPath.row] title];
    UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:17.0];
    CGSize constraintSize = CGSizeMake(280.0f, 180.0f);
    CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    
    return labelSize.height + 40;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.stories count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
            cell.textLabel.numberOfLines = 0;
            cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17.0];
            cell.textLabel.backgroundColor = [UIColor clearColor];
            cell.textLabel.shadowColor = [UIColor whiteColor];
            cell.textLabel.shadowOffset = CGSizeMake(0, 1);
            cell.textLabel.highlightedTextColor = [UIColor blackColor];
            cell.backgroundColor = [UIColor lightTextColor];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    cell.textLabel.text = [[self.stories objectAtIndex:indexPath.row] title];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Story *newStory = [self.stories objectAtIndex:indexPath.row];
    NSLog(@"%@",newStory.url);
    
    if ([newStory.url rangeOfString:@"/comments/"].location != NSNotFound){
        CommentViewController *cvc = [[CommentViewController alloc] initWithStyle:UITableViewStyleGrouped];
        cvc.story = newStory;
        [self.navigationController pushViewController:cvc animated:YES];
        
        return;
    }
    
    self.detailViewController = [[DetailViewController alloc] init];
    self.detailViewController.story = newStory;  
    
    [self.navigationController pushViewController:self.detailViewController animated:YES];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    SDFooterButton *footerButton = [[SDFooterButton alloc] init];
    [footerButton.button.titleLabel setShadowColor:[UIColor whiteColor]];
    [footerButton.button setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
     footerButton.button.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17.0];
    footerButton.button.titleLabel.backgroundColor = [UIColor clearColor];

    footerButton.button.titleLabel.shadowOffset = CGSizeMake(0, 1);
    footerButton.button.titleLabel.highlightedTextColor = [UIColor blackColor];
    footerButton.delegate = self;
    
    return footerButton;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 75;
}


#pragma mark -
#pragma mark MasterViewController Methods


- (void)setupNavBar{

    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationController.navigationBar.hidden = YES;
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
    [self.navigationController.navigationBar setAlpha:0.0];
    
    self.tableView.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];

}


- (void)downloadStories {
    StoryFetcher *f = [[StoryFetcher alloc] init];
    self.fetcher = f;
    self.fetcher.delegate = self;
    [self.fetcher fetchStories];
}


- (void)storiesComplete:(NSArray*)newStories {
    self.stories = newStories;
    [self.tableView reloadData];
    [self doneLoadingTableViewData];
    
}

- (void)storiesFailed{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Stories Not Currently Available" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [alert show];
    
}

-(void)footerButtonTapped{
    
    MFMailComposeViewController *mcv = [[MFMailComposeViewController alloc] init];
    mcv.mailComposeDelegate = self;
    mcv.navigationBar.tintColor = [UIColor blackColor];
    [mcv setSubject:@"HackerNews+ Feedback"];
    [mcv setToRecipients:[NSArray arrayWithObject:@"support@bixbyapps.com"]];
    [self.navigationController presentModalViewController:mcv animated:YES];

}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
        [self dismissModalViewControllerAnimated:YES];
}



@end

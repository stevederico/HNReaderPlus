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


@implementation MasterViewController

@synthesize detailViewController = _detailViewController,stories = _stories, fetcher = _fetcher;

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.title = @"HNReader";
        [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
   
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            self.clearsSelectionOnViewWillAppear = NO;
            self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
 
        }
    }
    return self;
}
							
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
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


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.stories count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
            cell.textLabel.numberOfLines = 0;
            cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17.0];
            cell.textLabel.backgroundColor = [UIColor clearColor];
            cell.textLabel.shadowColor = [UIColor whiteColor];
            cell.textLabel.shadowOffset = CGSizeMake(0, 1);
            cell.backgroundColor = [UIColor lightTextColor];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
        }
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
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(60, self.tableView.contentSize.height +180, 200 , 20)];
    label.textAlignment = UITextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.shadowColor = [UIColor lightGrayColor];
    label.shadowOffset = CGSizeMake(0, 1);
    label.font = [UIFont fontWithName:@"Helvetica-BoldOblique" size:10.0];
    label.text = @"Stay Hungry, Stay Foolish";
    [self.tableView addSubview:label];
}




@end

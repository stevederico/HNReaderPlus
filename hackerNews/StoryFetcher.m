//
//  StoryFetcher.m
//  hackerNews
//
//  Created by Stephen Derico on 11/4/11.
//  Copyright (c) 2011 Bixby Apps. All rights reserved.
//
#import "Story.h"
#import "StoryFetcher.h"
#import "AFJSONRequestOperation.h"
//#import "AFJSONRequestOperation.h"

@implementation StoryFetcher
@synthesize delegate = _delegate;

- (void)fetchStories {
   __block NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://api.ihackernews.com/ask"]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request 
    success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSArray *iArray = [JSON valueForKeyPath:@"items"];
       
        for (NSDictionary *item in iArray) {
            NSLog(@"title %@",[item objectForKey:@"title"]);
            NSLog(@"id %@",[item objectForKey:@"id"]);
           [returnArray addObject:[Story createStoryWithDictionary:item]];
           
        }
       
 
        [self.delegate storiesComplete:returnArray];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"Failure %@",error);
       
        UIAlertView *alert;
        alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"%@",[error description]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        
    
    }
];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
   
    
 
}

@end

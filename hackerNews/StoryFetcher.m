//
//  StoryFetcher.m
//  hackerNews
//
//  Created by Stephen Derico on 11/4/11.
//  Copyright (c) 2011 Bixby Apps. All rights reserved.
//
#import "Story.h"
#import "StoryFetcher.h"
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"

@implementation StoryFetcher
@synthesize delegate = _delegate;

- (void)fetchStories {
   __block NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://api.ihackernews.com/page"]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSArray *iArray = [JSON valueForKeyPath:@"items"];
        
        NSLog(@"Title: %@  ", [[JSON objectForKey:@"items"] class]);
        
        for (NSDictionary *item in iArray) {
           [returnArray addObject:[Story createStoryWithDictionary:item]];
            NSLog(@"title %@",[item objectForKey:@"title"]);
        }
       
        [self.delegate storiesComplete:returnArray];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"Failure %@",error);
    }
];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
    
 
}

@end

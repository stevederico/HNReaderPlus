//
//  CommentFetcher.m
//  hackerNews
//
//  Created by Stephen Derico on 11/20/11.
//  Copyright (c) 2011 Bixby Apps. All rights reserved.
//

#import "Comment.h"
#import "CommentFetcher.h"
#import "AFJSONRequestOperation.h"


@implementation CommentFetcher
@synthesize delegate = _delegate;

- (void)fetchCommentsWithID:(NSNumber*)idString {
    __block NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api.ihackernews.com/post/%@",idString]]];
    NSLog(@"STRING %@",idString);
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request 
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            
            NSArray *iArray = [JSON valueForKeyPath:@"comments"];
            NSString *textString = [JSON valueForKeyPath:@"text"];
            if (textString.length >0) {
                NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
                [tempDict setValue:textString forKey:@"comment"];
                [returnArray addObject:[Comment createCommentWithDictionary:tempDict]];
            }
                                                                      
                                                                                            
            for (NSDictionary *item in iArray) {
                [returnArray addObject:[Comment createCommentWithDictionary:item]];
                NSLog(@"Comment %@",[item objectForKey:@"comment"]);
            }
            
            [self.delegate commentsComplete:returnArray];
            
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            NSLog(@"Failure %@",error);
            
            [self.delegate commentsFailed];
            
            
            
        }
                                         ];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
    
    
    
}

@end
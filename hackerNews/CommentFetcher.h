//
//  CommentFetcher.h
//  hackerNews
//
//  Created by Stephen Derico on 11/20/11.
//  Copyright (c) 2011 Bixby Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CommentFetcherDelegate <NSObject>

@required
- (void)commentsComplete:(NSArray*)newComments;

@end

@interface CommentFetcher : NSObject {
    
    id <CommentFetcherDelegate> _delegate;
    
}
@property (nonatomic, retain) id <CommentFetcherDelegate> delegate;
- (void)fetchCommentsWithID:(NSNumber*)idString;

@end
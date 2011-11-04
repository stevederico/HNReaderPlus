//
//  StoryFetcher.h
//  hackerNews
//
//  Created by Stephen Derico on 11/4/11.
//  Copyright (c) 2011 Bixby Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol StoryFetcherDelegate <NSObject>

@required
- (void)storiesComplete:(NSArray*)newStories;

@end

@interface StoryFetcher : NSObject {

    id <StoryFetcherDelegate> _delegate;

}
@property (nonatomic, retain) id <StoryFetcherDelegate> delegate;
- (void)fetchStories;

@end

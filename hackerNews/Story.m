//
//  Story.m
//  hackerNews
//
//  Created by Stephen Derico on 11/4/11.
//  Copyright (c) 2011 Bixby Apps. All rights reserved.
//

#import "Story.h"

@implementation Story 
@synthesize title = _title, url = url;

+ (Story*)createStoryWithDictionary:(NSDictionary*)dictionary {

    Story *story = [[Story alloc] init];
    story.title = [dictionary objectForKey:@"title"];
    story.url = [dictionary objectForKey:@"url"];

    return  story;
}

//- (void)dealloc {
//    self.title = nil;
//    self.url = nil;
//}


@end

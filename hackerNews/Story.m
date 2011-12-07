//
//  Story.m
//  hackerNews
//
//  Created by Stephen Derico on 11/4/11.
//  Copyright (c) 2011 Bixby Apps. All rights reserved.
//

#import "Story.h"

@implementation Story 
@synthesize title = _title, url = url, idNumber = _idNumber,commentCount = _commentCount;

+ (Story*)createStoryWithDictionary:(NSDictionary*)dictionary {

    Story *story = [[Story alloc] init];
    story.title = [dictionary objectForKey:@"title"];
    story.url = [dictionary objectForKey:@"url"];
    story.idNumber = [dictionary objectForKey:@"id"];  
    story.commentCount = (NSNumber*)[dictionary objectForKey:@"commentCount"];
    NSLog(@"Created Story with %@",story.idNumber);

    return  story;
}

@end

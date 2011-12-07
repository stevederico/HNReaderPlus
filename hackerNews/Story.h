//
//  Story.h
//  hackerNews
//
//  Created by Stephen Derico on 11/4/11.
//  Copyright (c) 2011 Bixby Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Story : NSObject 

@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSNumber *idNumber;
@property (nonatomic, retain) NSNumber *commentCount;
+ (Story*)createStoryWithDictionary:(NSDictionary*)dictionary;


@end

//
//  Comment.h
//  hackerNews
//
//  Created by Stephen Derico on 11/20/11.
//  Copyright (c) 2011 Bixby Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Comment : NSObject

@property (nonatomic, retain) NSString *author;
@property (nonatomic, retain) NSString *timeAgo;
@property (nonatomic, retain) NSString *body;

+ (Comment*)createCommentWithDictionary:(NSDictionary*)dictionary;
+ (NSString *)flattenHTML:(NSString *)html;
@end

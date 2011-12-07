//
//  Comment.m
//  hackerNews
//
//  Created by Stephen Derico on 11/20/11.
//  Copyright (c) 2011 Bixby Apps. All rights reserved.
//

#import "Comment.h"

@implementation Comment
@synthesize author = _author, timeAgo = _timeAgo, body = _body;

+ (Comment*)createCommentWithDictionary:(NSDictionary*)dictionary {
    
    Comment *comment = [[Comment alloc] init];
    comment.author = [dictionary objectForKey:@"postedBy"];
    comment.timeAgo = [dictionary objectForKey:@"postedAgo"];
    NSString *rawComment = [dictionary objectForKey:@"comment"];
    
    comment.body = [Comment flattenHTML:rawComment];

    return comment;
}

+ (NSString *)flattenHTML:(NSString *)html {
    
    NSScanner *theScanner;
    NSString *text = nil;
    theScanner = [NSScanner scannerWithString:html];
    
    while ([theScanner isAtEnd] == NO) {
        
        [theScanner scanUpToString:@"<" intoString:NULL] ; 
        
        [theScanner scanUpToString:@">" intoString:&text] ;
        
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", text] withString:@""];
    }

    html = [html stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    return html;
}

@end

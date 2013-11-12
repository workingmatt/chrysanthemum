//
//  Message.h
//  Moderator2
//
//  Created by Matt Mapleston on 27/09/2012.
//  Copyright (c) 2012 Matt Mapleston. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Message : NSObject
{
    NSString *content;
    NSString *contentURL;
    NSImage *authorImage;
    NSString *authorName;
    NSString *atName;
    NSString *pubDate;
}

@property NSString * content;
@property NSString * contentURL;
@property NSImage * authorImage;
@property NSString * authorName;
@property NSString * atName;
@property NSString * pubDate;
@end

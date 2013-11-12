//
//  Message.m
//  Moderator2
//
//  Created by Matt Mapleston on 27/09/2012.
//  Copyright (c) 2012 Matt Mapleston. All rights reserved.
//

#import "Message.h"

@implementation Message

@synthesize content;
@synthesize contentURL;
@synthesize authorImage;
@synthesize authorName;
@synthesize atName;
@synthesize pubDate;

-(id) init
{
    if(self=[super init]){
        //NSLog(@"Made a message: %@", self);
    }
    return self;
}
@end

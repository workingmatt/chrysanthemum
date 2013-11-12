//
//  Singleton.m
//  Moderator2
//
//  Created by Matt Mapleston on 11/10/2012.
//  Copyright (c) 2012 Matt Mapleston. All rights reserved.
//

#import "Singleton.h"

@implementation Singleton
@synthesize passedMutableArray;

static Singleton *sharedSingleton = nil;

+ (Singleton *) sharedSingleton {
    @synchronized(self) {
        if (sharedSingleton == nil){
            sharedSingleton = [[self alloc] init];
        }
    }
    return sharedSingleton;
}

@end

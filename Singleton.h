//
//  Singleton.h
//  Moderator2
//
//  Created by Matt Mapleston on 11/10/2012.
//  Copyright (c) 2012 Matt Mapleston. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Singleton : NSObject {
    NSMutableArray *passedMutableArray;
}

@property NSMutableArray* passedMutableArray;

+ (Singleton *) sharedSingleton;

@end

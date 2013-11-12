//
//  MessageSource.h
//  Moderator2
//
//  Created by Matt Mapleston on 26/09/2012.
//  Copyright (c) 2012 Matt Mapleston. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OAToken.h"
#import "OAConsumer.h"
#import "OADataFetcher.h"
#import "OAMutableURLRequest.h"
#import "OAServiceTicket.h"

@interface MessageSource : NSObject
{
    NSString *sourceURL;
    NSString *searchField;

    NSData *urlData;
    NSXMLDocument *doc;
    NSArray *itemNodes;
    
}

- (id)fetchRawMessages:(id)sender;
@property NSString * sourceURL;
@property NSString * searchField;


//@property NSData * urlData;
@property NSXMLDocument * doc;
//@property NSArray * itemNodes;

@property NSDictionary * JSONresponse;

@end

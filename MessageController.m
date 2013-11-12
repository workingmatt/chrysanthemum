//
//  MessageController.m
//  Moderator2
//
//  Created by Matt Mapleston on 26/09/2012.
//  Copyright (c) 2012 Matt Mapleston. All rights reserved.
//  
//
//

#import "MessageController.h"
#import "MessageSource.h"
#import "Message.h"
#pragma mark TableView data source methods

@implementation MessageController

//@synthesize acceptedMessageCount;
@synthesize messageSourceTextBox;
@synthesize searchTermTextBox;

//@synthesize author;
//@synthesize authorImage;
//@synthesize contentImage;

//@synthesize moderatorWindow;


- (id)init
{
    if(self = [super init]){

        return self;
    }
    return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{

 
}

- (IBAction)startModeration:(id)sender
{
    NSError *error;
    if(!acceptedMessageArray) acceptedMessageArray = [[NSMutableArray alloc] init];
    
    //Create an instance of MessageSource class to retrieve messages from source
    MessageSource *rawFeed = [[MessageSource alloc] init];
    
    rawFeed.sourceURL = [messageSourceTextBox stringValue];
    rawFeed.searchField = [searchTermTextBox stringValue];
    [rawFeed fetchRawMessages:self];

    //TODO
    //include &since_id=xxxxxxxxxxxx to OAurl
    //get max_id and use in subsequent calls to fetch

    NSDictionary *statusObjects = [[NSDictionary alloc] init];
    statusObjects = [rawFeed.JSONresponse objectForKey:@"statuses"];
    //NSLog(@"***Number of JSON statuses: %lu", (unsigned long)[[rawFeed.JSONresponse objectForKey:@"statuses"] count]);
    NSLog(@"***Number of JSON statuses: %lu", (unsigned long)[statusObjects count]);
//    for (NSDictionary *status in JSONObjects){
//            NSLog(@"*Content: %@", [status objectForKey:@"text"]);
//            NSLog(@"*authorImageLink: %@", [[status objectForKey:@"user"] objectForKey:@"profile_image_url"]);
//            NSLog(@"*atName: %@", [[status objectForKey:@"user"] objectForKey:@"screen_name"]);
//            NSLog(@"*authorName: %@", [[status objectForKey:@"user"] objectForKey:@"name"]);
//            NSLog(@"*pubDate: %@", [status objectForKey:@"created_at"]);
//            NSLog(@"*******************");
//    };

    
    //Create messageArray that is displayed in the moderator window
    messageArray = [[NSMutableArray alloc]init];
    for (NSDictionary *status in statusObjects){
        Message *tempMessage = [[Message alloc] init];
       
        NSImage *tempAuthorImage = [[NSImage alloc]initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[status objectForKey:@"user"] objectForKey:@"profile_image_url"]]]];
        tempMessage.content = [status objectForKey:@"text"];
        tempMessage.authorImage = tempAuthorImage;
        tempMessage.atName = [[status objectForKey:@"user"] objectForKey:@"screen_name"];
        tempMessage.authorName = [[status objectForKey:@"user"] objectForKey:@"name"];
        tempMessage.pubDate = [status objectForKey:@"created_at"];
        tempMessage.pubDate = [[tempMessage.pubDate componentsSeparatedByString:@" +"] objectAtIndex:0];

        NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:&error];

        
        //Replace the following by using the URL returned in statuses->entities->urls
        NSArray *contentURLMatches = [detector matchesInString:tempMessage.content
                                                       options:0
                                                         range:NSMakeRange(0, [tempMessage.content length])];
        if ([contentURLMatches count] == 0) {
            tempMessage.contentURL = @"No link";
        } else {
            tempMessage.contentURL = [[[contentURLMatches objectAtIndex:0] URL] absoluteString];
        }
        [messageArray addObject:tempMessage];
        
    }
    //end create messageArray from xml

    //Debug messages to console
//    for (Message *message in messageArray)
//        NSLog(@"++++++message %lu content:%@", [messageArray indexOfObject:message], message.content);

    
    //Update the interface
    [self setTopMessage:self];
    [moderatorWindow makeKeyAndOrderFront:self];
    [tableView reloadData];

}//End of start moderation


//TODO Could set this to any selected row in tableview. setFocusMessage
- (id)setTopMessage:(id)sender
{

    topMessage = [messageArray objectAtIndex:0]; //TODO objectAtIndex:<the row clicked in the table> otherwise use 0
    authorImageView.image = topMessage.authorImage;
    [messageContentPane setStringValue:topMessage.content];
    [authorNamePane setStringValue:topMessage.authorName];
//    [messageContentURLPane setMainFrameURL:topMessage.contentURL];
    return self;
}

- (IBAction)rejectMessage:(id)sender
{
    if([messageArray count] == 0){
        NSLog(@"No messages to reject");
    }else{
        [messageArray removeObjectAtIndex:0];//TODO objectAtIndex:<the row clicked in the table>
    }
    
    if([messageArray count] > 0) [self setTopMessage:self];
    [tableView reloadData];
    moderatorWindow.viewsNeedDisplay = TRUE;
}

- (void) passToSingleton {
    Singleton* mySingleton = [Singleton sharedSingleton];
    NSLog(@"passToSingleton sending count: %lu", [acceptedMessageArray count]);
    mySingleton.passedMutableArray = acceptedMessageArray;
}


- (IBAction)acceptMessage:(id)sender
{
    [acceptedMessageArray addObject:[messageArray objectAtIndex:0]];//TODO objectAtIndex:<the row clicked in the table>
    [self rejectMessage:self];
    [self passToSingleton];

}


-(NSInteger)numberOfRowsInTableView:(NSTableView*)tv
{
    return [messageArray count];
}


//Fill the table with tweets
-(id)tableView:(NSTableView *)tv  objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    //NSLog(@"items objectAtIndex:row is %@", [items objectAtIndex:row]);

    Message *tempMessage = [messageArray objectAtIndex:row];
    
    if ([[tableColumn identifier] isEqualToString:@"authorImage"]){
        //NSLog(@"Sent image ret:%@", tempMessage.authorImage);
        return tempMessage.authorImage;
    } else {
    NSString *ret = [tempMessage valueForKey:[tableColumn identifier]];
        //NSLog(@"Sent ret:%@", ret);
    return ret;
    }

    NSLog(@"ident is:%@", [tableColumn identifier]);
}

@end

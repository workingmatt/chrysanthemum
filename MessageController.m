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
        
        //If there is an attached image, add its URL to tempMessage.contentURL and download image to tempMessage.contentImage
        //NSObject *mediaObject =[[status objectForKey:@"entities"] objectForKey:@"media"][0];
        if ([[status objectForKey:@"entities"] objectForKey:@"media"]) {
            tempMessage.contentURL =[[[status objectForKey:@"entities"] objectForKey:@"media"][0] objectForKey:@"media_url"];
            tempMessage.contentImage = [[NSImage alloc]initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:tempMessage.contentURL]]];
            
            //TODO - remove url from message text
            //It is possible to find where the image link is in the content text using entities->media[0]->indices
            //Example field is "indices":[15,35]
            //Check https://dev.twitter.com/overview/api/entities#obj-media for info
        } else {
            NSString *pathDefaultImage = [[NSBundle mainBundle] pathForResource:@"wmolLogo" ofType:@"jpg"];
            NSImage *defaultImage = [[NSImage alloc] initWithContentsOfFile:pathDefaultImage];
            tempMessage.contentURL = @"Default Logo";
            tempMessage.contentImage = defaultImage;
            
            NSLog(@"Adding wmolLondon logo: %@", pathDefaultImage);
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
    contentImageView.image = topMessage.contentImage;
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

//
//  DisplayController.m
//  Moderator2
//
//  Created by Matt Mapleston on 26/09/2012.
//  Copyright (c) 2012 Matt Mapleston. All rights reserved.
//

#import "DisplayController.h"

@implementation DisplayController

@synthesize textField;
@synthesize qcView;
@synthesize acceptedMessageCount;


-(id) init
{
    if(self = [super init]){
        NSLog(@"Initd DisplayController");
    }
    return self;
}

/*-(IBAction)startDisplay:(id)sender
{
    NSLog(@"In DisplayController startDisplay method");
}*/


- (IBAction)setText:(id)sender {
    
    NSLog(@"setText to:%@", textField.stringValue);
    [qcView setValue:[NSString stringWithFormat:@"%@", textField.stringValue] forInputKey:@"inputText"];
    [qcView setValue:acceptedMessageArray forInputKey:@"acceptedMessageArrayQCInput"];
}


- (IBAction)updateDisplay:(id)sender {
    Singleton* mySingleton = [Singleton sharedSingleton];
    acceptedMessageArray = mySingleton.passedMutableArray;

    //Create local arrays to Demux messages from acceptedMessageArray
    NSMutableArray *acceptedContentArray = [[NSMutableArray alloc] init];
    NSMutableArray *acceptedContentURLArray = [[NSMutableArray alloc] init];
    NSMutableArray *acceptedAuthorImageArray = [[NSMutableArray alloc] init];
    NSMutableArray *acceptedAuthorNameArray = [[NSMutableArray alloc] init];
    NSMutableArray *acceptedAtNameArray = [[NSMutableArray alloc] init];
    NSMutableArray *acceptedPubDateArray = [[NSMutableArray alloc] init];
    
    //Populate local arrays by stepping through acceptedMessageArray
    for(Message *msg in acceptedMessageArray){
        NSInteger index = [acceptedMessageArray indexOfObject:msg];

        [acceptedContentArray insertObject:msg.content atIndex:index];
        [acceptedContentURLArray insertObject:msg.contentURL atIndex:index];
        [acceptedAuthorImageArray insertObject:msg.authorImage atIndex:index];
        [acceptedAuthorNameArray insertObject:msg.authorName atIndex:index];
        [acceptedAtNameArray insertObject:msg.atName atIndex:index];
        [acceptedPubDateArray insertObject:msg.pubDate atIndex:index];
        //NSLog(@"Msg array atName: %@", msg.atName);
    }
    
    [qcView setValue:acceptedContentArray forInputKey:@"contentArray"];
    [qcView setValue:acceptedContentURLArray forInputKey:@"contentURLArray"];
    [qcView setValue:acceptedAuthorImageArray forInputKey:@"authorImageArray"];
    [qcView setValue:acceptedAuthorNameArray forInputKey:@"authorNameArray"];
    [qcView setValue:acceptedAtNameArray forInputKey:@"atNameArray"];
    [qcView setValue:acceptedPubDateArray forInputKey:@"pubDateArray"];
    //[qcView setValue:[NSString stringWithFormat:@"%lu", [acceptedContentArray count]] forInputKey:@"arraySize"];
    
    acceptedMessageCount.stringValue = [NSString stringWithFormat:@"%ld", acceptedMessageArray.count];
    //[qcView enterFullScreenMode:[NSScreen mainScreen] withOptions:nil];

}

//TODO Implement a button to empty the accepted message array

- (IBAction)clearAcceptedMessages:(id)sender {
    Singleton* mySingleton = [Singleton sharedSingleton];
    acceptedMessageArray = mySingleton.passedMutableArray;
//    [acceptedMessageArray removeAllObjects];
    [mySingleton.passedMutableArray removeAllObjects];
    acceptedMessageCount.stringValue = [NSString stringWithFormat:@"%ld", acceptedMessageArray.count];
    NSLog(@"accepted message count: %@", acceptedMessageCount.stringValue);
}


@end

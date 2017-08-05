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
@synthesize acceptedMessageCount;
@synthesize qcView;
@synthesize qcParamsView;

-(id) init
{
    if(self = [super init]){
        NSLog(@"Initd DisplayController");
        
    }
    return self;
}

- (void) awakeFromNib
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Luna2017" ofType:@"qtz"];
    NSView *superView = [self.displayWindow contentView];
    qcView = [[QCView alloc] initWithFrame:superView.frame];
    [superView addSubview:qcView];
    [superView setTranslatesAutoresizingMaskIntoConstraints:YES];
    [superView setAutoresizesSubviews:YES];
    [qcView setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];
    
    [superView addConstraint:
     [NSLayoutConstraint constraintWithItem: qcView
                                   attribute: NSLayoutAttributeWidth
                                   relatedBy: NSLayoutRelationEqual
                                      toItem: superView
                                   attribute: NSLayoutAttributeWidth
                                  multiplier:1
                                    constant:0]];
    
    [superView addConstraint:
     [NSLayoutConstraint constraintWithItem: qcView
                                  attribute: NSLayoutAttributeHeight
                                  relatedBy: NSLayoutRelationEqual
                                     toItem: superView
                                  attribute: NSLayoutAttributeHeight
                                 multiplier:1
                                   constant:0]];
    [superView addConstraint:
     [NSLayoutConstraint constraintWithItem: qcView
                                  attribute: NSLayoutAttributeCenterX
                                  relatedBy: NSLayoutRelationEqual
                                     toItem: superView
                                  attribute: NSLayoutAttributeCenterX
                                 multiplier:1
                                   constant:0]];
    [superView addConstraint:
     [NSLayoutConstraint constraintWithItem: qcView
                                  attribute: NSLayoutAttributeCenterY
                                  relatedBy: NSLayoutRelationEqual
                                     toItem: superView
                                  attribute: NSLayoutAttributeCenterY
                                 multiplier:1
                                   constant:0]];

    [qcView unloadComposition];
    [qcView loadCompositionFromFile:path];
    [qcView setMaxRenderingFrameRate: 30.0];
    [qcView startRendering];
    
    if(![qcView loadCompositionFromFile:path])
    {
        NSLog(@"******QC.qtz failed to load");
        [NSApp terminate:nil];
    }
    NSLog(@"******qc.qtz has been loaded!!!!");
    NSLog(@"inputKeys: %@", qcView.inputKeys);
    
    //Create a parameters view
    //Note that a new referencing outlet was added from Display Settings window to DisplayController
    //by dragging the round circle on the far left over to the blue cube in the xib.
    //Check out displaycontroller.h and .m
    
    NSView *paramsSuperView = [self.displaySettings contentView];
    qcParamsView = [[QCCompositionParameterView alloc] initWithFrame:paramsSuperView.frame];
    [paramsSuperView addSubview:qcParamsView];
    [paramsSuperView setTranslatesAutoresizingMaskIntoConstraints:YES];
    [paramsSuperView setAutoresizesSubviews:YES];
    [qcParamsView setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];
    [qcParamsView setCompositionRenderer:qcView];
    
    NSLog(@"Debug got here");
    //    qcView.eventForwardingMask = NSAnyEventMask;
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
    NSMutableArray *acceptedContentImageArray = [[NSMutableArray alloc] init];
    NSMutableArray *acceptedAuthorImageArray = [[NSMutableArray alloc] init];
    NSMutableArray *acceptedAuthorNameArray = [[NSMutableArray alloc] init];
    NSMutableArray *acceptedAtNameArray = [[NSMutableArray alloc] init];
    NSMutableArray *acceptedPubDateArray = [[NSMutableArray alloc] init];
    
    //Populate local arrays by stepping through acceptedMessageArray
    for(Message *msg in acceptedMessageArray){
        NSInteger index = [acceptedMessageArray indexOfObject:msg];

        [acceptedContentArray insertObject:msg.content atIndex:index];
        [acceptedContentURLArray insertObject:msg.contentURL atIndex:index];
        [acceptedContentImageArray insertObject:msg.contentImage atIndex:index];
        [acceptedAuthorImageArray insertObject:msg.authorImage atIndex:index];
        [acceptedAuthorNameArray insertObject:msg.authorName atIndex:index];
        [acceptedAtNameArray insertObject:msg.atName atIndex:index];
        [acceptedPubDateArray insertObject:msg.pubDate atIndex:index];
        NSLog(@"Msg array atName: %@", msg.atName);
    }

    [qcView setValue:acceptedContentArray forInputKey:@"contentArray"];
    [qcView setValue:acceptedContentURLArray forInputKey:@"contentURLArray"];
    [qcView setValue:acceptedContentImageArray forInputKey:@"contentImageArray"];
    [qcView setValue:acceptedAuthorImageArray forInputKey:@"authorImageArray"];
    [qcView setValue:acceptedAuthorNameArray forInputKey:@"authorNameArray"];
    [qcView setValue:acceptedAtNameArray forInputKey:@"atNameArray"];
    [qcView setValue:acceptedPubDateArray forInputKey:@"pubDateArray"];
    //[qcView setValue:[NSString stringWithFormat:@"%lu", [acceptedContentArray count]] forInputKey:@"arraySize"];
    
    //[qcView startRendering];
    
    acceptedMessageCount.stringValue = [NSString stringWithFormat:@"%ld", acceptedMessageArray.count];
    //[qcView enterFullScreenMode:[NSScreen mainScreen] withOptions:nil];

}


- (IBAction)clearAcceptedMessages:(id)sender {
    Singleton* mySingleton = [Singleton sharedSingleton];
    acceptedMessageArray = mySingleton.passedMutableArray;
//    [acceptedMessageArray removeAllObjects];
    [mySingleton.passedMutableArray removeAllObjects];
    acceptedMessageCount.stringValue = [NSString stringWithFormat:@"%ld", acceptedMessageArray.count];
    NSLog(@"accepted message count: %@", acceptedMessageCount.stringValue);
    
    //clearAcceptedMessages half works.
    //It removes all but the last msg added
    //it doesn't remove the display slots from the animation
    //so that one slot appears x times where x is the last number of accepted tweets.
}


@end

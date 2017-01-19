//
//  MessageController.h
//  Moderator2
//
//  Created by Matt Mapleston on 26/09/2012.
//  Copyright (c) 2012 Matt Mapleston. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import "MessageSource.h"
#import "Message.h"
#import "Singleton.h"
#import "sys/types.h"

@interface MessageController : NSObject
{
    IBOutlet NSTextField *messageSourceTextBox;
    IBOutlet NSTextField *searchTermTextBox;
    
    IBOutlet NSTableView *tableView;
    IBOutlet NSImageView *authorImageView;
    IBOutlet NSTextField *messageContentPane;
    IBOutlet NSTextField *authorNamePane;
    IBOutlet NSImageView *contentImageView;

    IBOutlet NSWindow *moderatorWindow;
    NSMutableArray * messageArray;
    NSMutableArray * acceptedMessageArray;
    Message *topMessage;
    NSArray *itemNodes;
}

@property NSTextField * messageSourceTextBox;
@property NSTextField * searchTermTextBox;
//@property (weak) IBOutlet NSTextField *acceptedMessageCount;
//@property (retain) IBOutlet NSMutableArray *acceptedMessageArray;

//@property (assign) IBOutlet WebView * messageContentURLPane;

- (IBAction)startModeration:(id)sender;
- (id)setTopMessage:(id)sender;
- (IBAction)rejectMessage:(id)sender;
- (IBAction)acceptMessage:(id)sender;
//- (void) passToSingleton;

@end

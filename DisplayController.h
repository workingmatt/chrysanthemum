//
//  DisplayController.h
//  Moderator2
//
//  Created by Matt Mapleston on 26/09/2012.
//  Copyright (c) 2012 Matt Mapleston. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Quartz/Quartz.h>
#import "MessageController.h"
#import "Singleton.h"

@interface DisplayController : NSObject
{    
    __weak NSTextField *textField;
    __weak NSTextField *acceptedMessageCount;
    NSMutableArray *acceptedMessageArray;
}

- (IBAction)setText:(id)sender;
@property (weak) IBOutlet NSTextField *textField;
@property (weak) IBOutlet QCView *qcView;
- (IBAction)updateDisplay:(id)sender;
- (IBAction)clearAcceptedMessages:(id)sender;

@property (weak) IBOutlet NSTextField *acceptedMessageCount;

/*-(IBAction)startDisplay:(id)sender;*/

@end

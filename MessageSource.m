//
//  MessageSource.m
//  Moderator2
//
//  Created by Matt Mapleston on 26/09/2012.
//  Copyright (c) 2012 Matt Mapleston. All rights reserved.
//

#import "MessageSource.h"
#import "MessageController.h"

#pragma mark TableView data source methods

@implementation MessageSource

@synthesize sourceURL;
@synthesize searchField;
@synthesize doc;
@synthesize JSONresponse;

- (id)init
{
    if(self = [super init]){
        //sourceURL = @"https://search.twitter.com/search.rss?q=";
        //%3F = ?, %3D = equal sign,
        sourceURL = @"https://api.twitter.com/1.1/search/tweets.json%3Fq=";
    
    }
    return self;
}

- (void) apiTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data
{
    if (ticket.didSucceed)
    {
        NSError *error;
        JSONresponse = [NSJSONSerialization JSONObjectWithData:data
                                                       options:0
                                                         error:&error];
    } else {
        NSLog(@"API call did not succeed.");
    }
}

- (void) apiTicket: (OAServiceTicket *)ticket didFailWithError:(NSError *)error
{
    if (!ticket.didSucceed)
    {
        NSLog(@"Getting Twitter search failed: %@", [error localizedDescription]);
    }
}
/*
 *  Inputs: sourceURL, searchField come from the UI
 *  Output: doc is an NSXMLDocument of the return from the URL call
 *
 */
- (id)fetchRawMessages:(id)sender;
{
    //set up accesstoken for WorkingMatt and BigScreenHornch
    OAToken *accessToken = [[OAToken alloc] initWithKey:@"373301436-XJUQHykP3Uy5zzayHTYPFOrLUZ7UqtzoGdKe3dA7" secret:@"dzBgj9CXaRtZb90uW4GjKDPBlLfnQcAqJxwkYNttPiXMj"];
    OAConsumer *consumer = [[OAConsumer alloc] initWithKey:@"wNDfJuxIlRpVJrHbm6R2jLvay" secret:@"hqX8P4R60NCyHPP5C75wB3ovwRhSnftNgTcPal1rEcUrFAurR0"];
    
    OADataFetcher *fetcher = [[OADataFetcher alloc] init];
    
    NSString *input = searchField;
    NSString *tempUrl = [NSString stringWithFormat:@"https://api.twitter.com/1.1/search/tweets.json?q=%@&count=100", searchField];
    NSURL *OAurl = [NSURL URLWithString:tempUrl];
    
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:OAurl
                                                                   consumer:consumer
                                                                      token:accessToken
                                                                      realm:nil
                                                          signatureProvider:nil];
    [request setHTTPMethod:@"GET"];
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(apiTicket:didFinishWithData:)
                  didFailSelector:@selector(apiTicket:didFailWithError:)];
    
    //put together the request
    //NSString *input = searchField;
    NSString *searchString = [input stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    //NSLog(@"Search string = %@", searchString);
    
    //create the URL urlRequest http://search.twitter.com/search.rss?q=%@&rpp=100
    NSString *urlString = [NSString stringWithFormat:@"%@%@&rpp=10", sourceURL, searchString];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30];
    
    //fetch the response using urlRequest and store as urlData
    //NSData *urlData;
    NSURLResponse *response;
    NSError *error;
    
    urlData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];

    if (!urlData){
        NSAlert *alert = [NSAlert alertWithError:error];
        [alert runModal];
        return self;
    }
    
    //Parse the XML response
    doc = [[NSXMLDocument alloc] initWithData:urlData options:0 error:&error];
    NSAlert *alert = [NSAlert alertWithMessageText:@"Fetching tweets, this may take a few seconds" defaultButton:@"OK" alternateButton:@"Cancel" otherButton:@"" informativeTextWithFormat:@""];
    [alert runModal];
    //NSLog(@"doc = %@", doc);
//    if (!doc){
//        NSLog(@"Error2");
//        NSAlert *alert = [NSAlert alertWithError:error];
//        [alert runModal];
//        return self;
//    }
    

    return self;
}

@end

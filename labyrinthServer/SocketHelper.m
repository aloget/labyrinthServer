//
//  SocketHelper.m
//  labyrinthClient
//
//  Created by Anna on 24/05/15.
//  Copyright (c) 2015 Anna. All rights reserved.
//

#import "SocketHelper.h"

@implementation SocketHelper

static SocketHelper *_sharedInstance = nil;

+ (SocketHelper *)sharedInstance
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _sharedInstance = [[self alloc] init];
        
    });
    return _sharedInstance;
}


-(BOOL)bind {
    int sDescriptor = socket(AF_INET, SOCK_STREAM, 0);
    if (sDescriptor == -1) {
        NSLog(@"Error creating socket");
        return NO;
    }
    else {
        _serverSocketDescriptor = sDescriptor;
    }
    
    struct sockaddr_in server_addr ;
    bzero(&server_addr, sizeof(server_addr));
    server_addr.sin_port = htons(7000) ;
    server_addr.sin_addr.s_addr = htonl(INADDR_ANY);
    server_addr.sin_family = AF_INET;
    
 
    int returnValue = bind(sDescriptor, (struct sockaddr *)&server_addr , sizeof(struct sockaddr));
    if (returnValue == 0) {
        NSLog(@"Binding successfull");
        return YES;
    }
    else {
        NSLog(@"Error occured while binding: code %d %s", errno, strerror(errno));
        return NO;
    }
}

-(BOOL)listen {
    int returnValue = listen(_serverSocketDescriptor, 1);
    if (returnValue == 0) {
        NSLog(@"Listening.");
        return YES;
    }
    else {
        NSLog(@"Error occured while marking listening: code %d %s", errno, strerror(errno));
        return NO;
    }
}

-(BOOL)accept {
    struct sockaddr_in client_addr;
    socklen_t socksize = sizeof(struct sockaddr_in);
    int returnValue = accept(_serverSocketDescriptor, (struct sockaddr *)&client_addr, &socksize);
    if (returnValue != -1) {
        NSLog(@"Accepted.");
        _clientSocketDescriptor = returnValue;
        return YES;
    }
    else {
        NSLog(@"Error occured while accepting: code %d %s", errno, strerror(errno));
        return NO;
    }
}

-(BOOL)sendString:(NSString*)string {
    NSData* sendData = [string dataUsingEncoding:NSUTF8StringEncoding];
    const void* buffer = [sendData bytes];
    size_t bufferSize = string.length;
    int sendResponse = send(_clientSocketDescriptor, buffer, bufferSize, 0);
    if (sendResponse == -1) {
        NSLog(@"Error occured while sending: code %d%s", errno, strerror(errno));
        return NO;
    } else {
        NSLog(@"Sent successfully: %d bytes", sendResponse);
        return YES;
    }
}


-(NSString*)receiveString {
    char buffer[1024];
    size_t bufferSize = 1024;
    int receivedBytes = recv(_clientSocketDescriptor, buffer, bufferSize, 0);
    if (receivedBytes == -1) {
        NSLog(@"Error occured while receiving: code %d", errno);
        return @"";
    } else {
        if (receivedBytes == 0) {
            return @"";
        }
        NSLog(@"Received successfully: %d bytes", receivedBytes);
        buffer[receivedBytes] = '\0';
        NSString* returnString = [NSString stringWithCString:buffer encoding:NSUTF8StringEncoding];
        return returnString;
    }
    
}



@end

//
//  SocketHelper.h
//  labyrinthClient
//
//  Created by Anna on 24/05/15.
//  Copyright (c) 2015 Anna. All rights reserved.
//

#import <Foundation/Foundation.h>

#include <sys/types.h>
#include <sys/socket.h>
#include <netdb.h>
#include <arpa/inet.h>

@interface SocketHelper : NSObject

+(SocketHelper*)sharedInstance;

@property int serverSocketDescriptor;
@property int clientSocketDescriptor;

-(BOOL)bind;
-(BOOL)listen;
-(BOOL)accept;

-(BOOL)sendString:(NSString*)string;
-(NSString*)receiveString;

@end

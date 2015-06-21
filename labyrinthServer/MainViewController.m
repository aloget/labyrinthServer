//
//  MainViewController.m
//  labyrinthServer
//
//  Created by Anna on 24/05/15.
//  Copyright (c) 2015 Anna. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController () {
    NSManagedObjectContext* moc;
    Labyrinth* labyrinth;
}

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate* delegate = (AppDelegate*)[[NSApplication sharedApplication] delegate];
    moc = delegate.managedObjectContext;
    [_log setString:@""];
    
//    NSFetchRequest* request = [[NSFetchRequest alloc] initWithEntityName:@"Labyrinth"];
//    NSError* error;
//    NSArray* array = [moc executeFetchRequest:request error:&error];
//    for (int i = 0; i < array.count; i++) {
//        Labyrinth* l = [array objectAtIndex:i];
//        [moc deleteObject:l];
//    }
//    NSError* err;
//    [moc save:&err];
    
}

-(void)getLabyrinth {
    NSFetchRequest* request = [[NSFetchRequest alloc] initWithEntityName:@"Labyrinth"];
    NSError* error;
    NSArray* labArray = [moc executeFetchRequest:request error:&error];
    Labyrinth* lab = (Labyrinth*)labArray.firstObject;
    labyrinth = lab;
}

-(void)setReceiving {
    NSString* receivedString = [[SocketHelper sharedInstance] receiveString];
    [self parseReceivedString:receivedString];
}

-(void)parseReceivedString:(NSString*) string {
    NSLog(@"receivedstring %@", string);
    if ([string isEqualToString:@"lab"]) {
        [self addLogString:@"Got labyrinth request."];
        [self sendLabyrinth];
    } else if (string.length > 0){
        [self addLogString:@"Got step."];
        [self analyzeStepWithString:string];
    } else {
        [self addLogString:@"Disconnected"];
        return;
        //[self waitForConnection];
    }
    [self setReceiving];
}

-(void)sendLabyrinth {
    NSString* labString = labyrinth.asString;
    if ([[SocketHelper sharedInstance] sendString:labString]) {
        [self addLogString:@"Labyrinth sent successfully."];
    }
}

-(void)analyzeStepWithString:(NSString*)string{
    NSString* numOfCellStr = [string substringWithRange:NSMakeRange(0, 2)];
    int numOfCell = numOfCellStr.intValue;
    NSString* directionStr = [string substringWithRange:NSMakeRange(2, 1)];
    int directionCode = directionStr.intValue;
    NSString* sendString;
    if ([labyrinth canGoFromCell:numOfCell toDirection:directionCode]) {
        [self addLogString:@"Step is valid."];
        sendString = [labyrinth getDestinationStringWithCell:numOfCell toDirection:directionCode];
        
    } else {
        [self addLogString:@"Step is not valid."];
        sendString = @"000";
    }
    if ([[SocketHelper sharedInstance] sendString:sendString]) {
        [self addLogString:@"Answer sent successfully."];
    }
}

-(void)addLogString:(NSString*)string {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString* oldText = _log.string;
        NSString* newText = [NSString stringWithFormat:@"%@\n%@", oldText, string];
        [_log setString:newText];
    });
}

-(void)waitForConnection {
    [self addLogString:@"Waiting for connection..."];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([[SocketHelper sharedInstance] accept]) {
            [self addLogString:@"Connection established!"];
            [self setReceiving];
        } else {
            [self addLogString:@"Error occured!"];
        }
    });
    
}

- (IBAction)runServer:(id)sender {
    [self getLabyrinth];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([[SocketHelper sharedInstance] bind]) {
            if ([[SocketHelper sharedInstance] listen]) {
                [self waitForConnection];
            }
        }
    });
}


@end

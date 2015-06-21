//
//  MainViewController.h
//  labyrinthServer
//
//  Created by Anna on 24/05/15.
//  Copyright (c) 2015 Anna. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AppDelegate.h"
#import "Labyrinth.h"
#import "SocketHelper.h"

@interface MainViewController : NSViewController

@property (weak) IBOutlet NSButton *addLabyrinthButton;
@property (weak) IBOutlet NSButton *runButton;
@property (unsafe_unretained) IBOutlet NSTextView *log;

- (IBAction)runServer:(id)sender;

@end

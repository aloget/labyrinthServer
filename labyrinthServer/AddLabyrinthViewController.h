//
//  AddLabyrinthViewController.h
//  labyrinthServer
//
//  Created by Anna on 24/05/15.
//  Copyright (c) 2015 Anna. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "Labyrinth.h"

@interface AddLabyrinthViewController : NSViewController

@property (weak) IBOutlet NSTextField *cellsHorizontally;
@property (weak) IBOutlet NSTextField *cellsVertically;
@property (weak) IBOutlet NSTextField *cellBeginning;
@property (weak) IBOutlet NSTextField *cellEnding;

@property (weak) IBOutlet NSTextField *bordersTextField;

- (IBAction)addLabyrinth:(id)sender;


@end

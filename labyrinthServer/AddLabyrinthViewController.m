//
//  AddLabyrinthViewController.m
//  labyrinthServer
//
//  Created by Anna on 24/05/15.
//  Copyright (c) 2015 Anna. All rights reserved.
//

#import "AddLabyrinthViewController.h"

@interface AddLabyrinthViewController () {
    NSManagedObjectContext* moc;
}

@end

@implementation AddLabyrinthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate* delegate = (AppDelegate*)[[NSApplication sharedApplication] delegate];
    moc = delegate.managedObjectContext;
    
}

- (IBAction)addLabyrinth:(id)sender {
    int numOfCellsHorizontally = _cellsHorizontally.intValue;
    int numOfCellsVertically = _cellsVertically.intValue;
    int beginning = _cellBeginning.intValue;
    int ending = _cellEnding.intValue;
    NSString* bordersString = _bordersTextField.stringValue;
    
    Labyrinth* newLabyrinth = (Labyrinth*)[NSEntityDescription insertNewObjectForEntityForName:@"Labyrinth" inManagedObjectContext:moc];
    [newLabyrinth loadWithCellsHorizontally:numOfCellsHorizontally cellsVertically:numOfCellsVertically beginning:beginning ending:ending borders:bordersString];
    NSError* error;
    [moc save:&error];
    [self dismissController:nil];
}


@end

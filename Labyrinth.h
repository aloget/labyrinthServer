//
//  Labyrinth.h
//  labyrinthServer
//
//  Created by Anna on 24/05/15.
//  Copyright (c) 2015 Anna. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Labyrinth : NSManagedObject

@property (nonatomic, retain) NSNumber * numOfCellsHorizontally;
@property (nonatomic, retain) NSNumber * numOfCellsVertically;
@property (nonatomic, retain) id bordersEncoded;
@property (nonatomic, retain) NSNumber * beginningCell;
@property (nonatomic, retain) NSNumber * endingCell;

-(void)loadWithCellsHorizontally:(int)cellsHorizontally cellsVertically:(int) cellsVertically beginning: (int) beginning ending:(int) ending borders:(NSString*) borders;
-(NSString*)asString;
-(BOOL)canGoFromCell:(int)numOfCell toDirection:(int)directionCode;
-(NSString*)getDestinationStringWithCell:(int)numOfCell toDirection:(int)directionCode;


@end

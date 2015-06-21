//
//  Labyrinth.m
//  labyrinthServer
//
//  Created by Anna on 24/05/15.
//  Copyright (c) 2015 Anna. All rights reserved.
//

#import "Labyrinth.h"


@implementation Labyrinth

@dynamic numOfCellsHorizontally;
@dynamic numOfCellsVertically;
@dynamic bordersEncoded;
@dynamic beginningCell;
@dynamic endingCell;

-(void)loadWithCellsHorizontally:(int)cellsHorizontally cellsVertically:(int) cellsVertically beginning: (int) beginning ending:(int) ending borders:(NSString*) borders {
    self.numOfCellsHorizontally = [NSNumber numberWithInt:cellsHorizontally];
    NSLog(@"horizontally %@", self.numOfCellsHorizontally);
    self.numOfCellsVertically = [NSNumber numberWithInt:cellsVertically];
    NSLog(@"vertically %@", self.numOfCellsVertically);
    self.beginningCell = [NSNumber numberWithInt:beginning];
    NSLog(@"begins at %@", self.beginningCell);
    self.endingCell = [NSNumber numberWithInt:ending];
    NSLog(@"ends at %@", self.endingCell);
    NSArray* bordersArray = [self bordersArrayWithString:borders];
    self.bordersEncoded = bordersArray;
    NSLog(@"borders %@", self.bordersEncoded);

}


-(NSArray*)bordersArrayWithString:(NSString*)borders {
    NSMutableArray* bordersArray = [[NSMutableArray alloc] init];
    int numOfCells = [self.numOfCellsHorizontally intValue] * [self.numOfCellsVertically intValue];
    for (int i = 0; i < numOfCells; i++) {
        int startIndex = i * 4;
        NSString* cellBorders = [borders substringWithRange:NSMakeRange(startIndex, 4)];
        NSMutableArray* bArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < 4; i++) {
            NSString* boolBorderString = [cellBorders substringWithRange:NSMakeRange(i, 1)];
            bool boolBorder = [boolBorderString boolValue];
            NSNumber* numberForArray = [NSNumber numberWithBool:boolBorder];
            [bArray addObject:numberForArray];
        }
        [bordersArray addObject:bArray];
    }
    NSLog(@"Created bordersArray: %@", bordersArray);
    return bordersArray;
}

-(NSString*)stringWithBordersArray:(NSArray*)borders {
    NSString* string = @"";
    for (int i = 0; i < borders.count; i++) {
        NSArray* bArray = borders[i];
        for (int j = 0; j < 4; j++) {
            NSNumber* boolValue = [bArray objectAtIndex:j];
            NSString* charValue = [NSString stringWithFormat:@"%@", boolValue ];
            string = [string stringByAppendingString:charValue];
        }
    }
    return string;
}

-(NSString*)asString {
    NSString* beginning;
    if (self.beginningCell.intValue < 10) {
        beginning = [NSString stringWithFormat:@"0%@", self.beginningCell];
    }
    else {
        beginning = [NSString stringWithFormat:@"%@", self.beginningCell];
    }
    NSString* firstValues = [NSString stringWithFormat:@"%@%@%@", beginning, self.numOfCellsHorizontally, self.numOfCellsVertically];
    NSString* borders = [self stringWithBordersArray:self.bordersEncoded];
    NSString* returnString = [NSString stringWithFormat:@"%@%@", firstValues, borders];
    NSLog(@"As String: %@", returnString);
    return returnString;
}

-(BOOL)canGoFromCell:(int)numOfCell toDirection:(int)directionCode {
    NSArray* cellBorders = [self.bordersEncoded objectAtIndex:numOfCell];
    NSLog(@"numofcell %d borders %@ \ndirection %d", numOfCell, cellBorders,directionCode);
    NSNumber* canGo = [cellBorders objectAtIndex:(directionCode - 1)];
    if (canGo.intValue == 1) {
        return YES;
    }
    else {
        return NO;
    }
}

-(NSString*)getDestinationStringWithCell:(int)numOfCell toDirection:(int)directionCode {
    int destCell;
    int resultCode;
    switch (directionCode) {
        case 1:
            destCell = numOfCell - self.numOfCellsHorizontally.intValue;
            break;
        case 2:
            destCell = numOfCell + self.numOfCellsHorizontally.intValue;
            break;
        case 3:
            destCell = numOfCell + 1;
            break;
        default:
            destCell = numOfCell - 1;
            break;
    }
    if (destCell == self.endingCell.intValue) {
        resultCode = 2;//finish
    } else {
        resultCode = 1;//normal
    }
    NSString* destString;
    if (destCell < 10) {
        destString = [NSString stringWithFormat:@"0%d", destCell];
    }
    else {
        destString = [NSString stringWithFormat:@"%d", destCell];
    }
    NSString* codeString = [NSString stringWithFormat:@"%d", resultCode];
    NSString* returnString = [NSString stringWithFormat:@"%@%@", destString, codeString];
    NSLog(@"Return String: %@", returnString);
    return returnString;
}



@end

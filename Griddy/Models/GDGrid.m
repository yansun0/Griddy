//
//  GDGrid.m
//  Griddy
//
//  Created by Yan Sun on 2014-07-03.
//  Copyright (c) 2014 Sunnay. All rights reserved.
//

#import "GDGrid.h"
#import "GDScreen.h"


// user default keys
extern NSString * const GDMainWindowTypeKey;
extern NSString * const GDMainWindowAbsoluteSizeKey;
extern NSString * const GDMainWindowRelativeSizeKey;
extern NSString * const GDMainWindowGridUniversalDimensionsKey;

@interface GDGrid() {
    CGFloat _cellOutterMargin;
    CGFloat _cellInnerMargin;
}

@property (nonatomic) NSRect gridInfo;
@property (nonatomic) NSSize cellSize;

@end



@implementation GDGrid


@synthesize thisGDScreen = _thisGDScreen;
@synthesize numCell = _numCell;
@synthesize gridInfo = _gridInfo; // stores info of the grid (its dimensions and location in screen)
@synthesize cellSize = _cellSize;


- (id) initWithGDScreen: (GDScreen *)screen {
    self = [super init];
    if (self != nil) {
        _thisGDScreen = screen;
        [self setupGridParams];
    }
    return self;
}


- (void) reinitWithGDScreen: (GDScreen *)newScreen {
    _thisGDScreen = newScreen;
    [self setupGridParams];
}


- (void) setupGridParams {
    [self setupGridInfo];
    [self setupCellSize];
    [_thisGDScreen setNumWidth: _numCell.width NumHeight: _numCell.height];
}



#pragma mark - WINDOW POSITION LOGIC

// TODO: find grid size based on user preferences/defaults
- (void) setupGridInfo {
    NSUInteger isWindowAbsSize = [[[NSUserDefaults standardUserDefaults] objectForKey: GDMainWindowTypeKey] integerValue];
    
    // relative, need to ask for help from GDScreen
    if (isWindowAbsSize == 0) {
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey: GDMainWindowRelativeSizeKey];
        NSValue *unarchived = [NSKeyedUnarchiver unarchiveObjectWithData: data];
        _gridInfo.size = [_thisGDScreen getMainWindowSizeForScreenPercentageSize: [unarchived sizeValue]];
        
    // abs, just do it
    } else {
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey: GDMainWindowAbsoluteSizeKey];
        NSValue *unarchived = [NSKeyedUnarchiver unarchiveObjectWithData: data];
        _gridInfo.size = [unarchived sizeValue];
    }

    // center the grid
    _gridInfo.origin.x = (_thisGDScreen.screenInfo.size.width - _gridInfo.size.width) * 0.5 + _thisGDScreen.screenInfo.origin.x;
    _gridInfo.origin.y = (_thisGDScreen.screenInfo.size.height - _gridInfo.size.height) * 0.5 + _thisGDScreen.screenInfo.origin.y;
}



#pragma mark - CELL SIZE LOGIC

- (void) setupCellSize {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey: GDMainWindowGridUniversalDimensionsKey];
    NSValue *unarchived = [NSKeyedUnarchiver unarchiveObjectWithData: data];
    _numCell = [unarchived sizeValue];
    
    _cellOutterMargin = 10.0;
    _cellInnerMargin = 5.0;
    
    // calculate cell size
    _cellSize.width = (_gridInfo.size.width - 2*_cellOutterMargin - (_numCell.width - 1)*_cellInnerMargin)/_numCell.width;
    _cellSize.height = (_gridInfo.size.height - 2*_cellOutterMargin - (_numCell.height - 1)*_cellInnerMargin)/_numCell.height;
}



#pragma mark - calculations

- (NSRect) getMainWindowFrame {
    return NSMakeRect(_gridInfo.origin.x, _gridInfo.origin.y,
                      _gridInfo.size.width, _gridInfo.size.height);
}


- (NSRect) getContentRectFrame {
    return NSMakeRect(_gridInfo.origin.x + _cellOutterMargin,
                      _gridInfo.origin.y + _cellOutterMargin,
                      _gridInfo.size.width - 2*_cellOutterMargin,
                      _gridInfo.size.height - 2*_cellOutterMargin);
}


- (NSRect) getCellViewFrameForCellX: (NSInteger)x
                                  Y: (NSInteger)y {
    return NSMakeRect(_cellOutterMargin + x*(_cellInnerMargin + _cellSize.width),
                      _cellOutterMargin + y*(_cellInnerMargin + _cellSize.height),
                      _cellSize.width, _cellSize.height);
}


- (NSRect) getRectFromPoint1: (NSPoint)p1
                      Point2: (NSPoint)p2 {
    NSRect newPosRect = NSMakeRect(0, 0, 0, 0);
    newPosRect.origin.x = (p1.x < p2.x ? (p1.x) : (p2.x)); // min
    newPosRect.origin.y = (p1.y < p2.y ? (p1.y) : (p2.y)); // min
    newPosRect.size.width = ABS(p1.x - p2.x) + 1;
    newPosRect.size.height = ABS(p1.y - p2.y) + 1;
    return newPosRect;
}


- (NSString *) getNewWindowBoundsStringFromCell1: (NSPoint)cell1
                                         ToCell2: (NSPoint)cell2 {
    NSRect newPosRect = [self getRectFromPoint1: cell1
                                         Point2: cell2];
    return [_thisGDScreen getScreenBoundsForGridRect: newPosRect];
}

// hovering
- (NSRect) getOverlayWindowFrameFromCell1: (NSPoint)cell1 {
    NSRect newPosRect = [self getRectFromPoint1: cell1
                                         Point2: cell1];
    return [_thisGDScreen getScreenFrameForGridRect: newPosRect];
}

// dragging
- (NSRect) getOverlayWindowFrameFromCell1: (NSPoint)cell1
                                  ToCell2: (NSPoint)cell2 {
    NSRect newPosRect = [self getRectFromPoint1: cell1
                                         Point2: cell2];
    return [_thisGDScreen getScreenFrameForGridRect: newPosRect];
}


@end

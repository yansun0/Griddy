//
//  GDGrid.m
//  Griddy
//
//  Created by Yan Sun on 2014-07-03.
//  Copyright (c) 2014 Sunnay. All rights reserved.
//

#import "GDDemoGrid.h"
#import "GDScreen.h"


// user default keys
extern NSString * const GDMainWindowTypeKey;
extern NSString * const GDMainWindowTypePostChanges; // GDMainWindowTypeKey

extern NSString * const GDMainWindowAbsoluteSizeKey;
extern NSString * const GDMainWindowAbsoluteSizePostChanges; // GDMainWindowAbsoluteSizeKey

extern NSString * const GDMainWindowRelativeSizeKey;
extern NSString * const GDMainWindowRelativeSizePostChanges; // GDMainWindowRelativeSizeKey

extern NSString * const GDMainWindowGridUniversalDimensionsKey;
extern NSString * const GDMainWindowGridUniversalDimensionsPostChanges;

extern NSString * const GDDemoGridValueUpdated;

@interface GDDemoGrid() {
    CGFloat _innerMargin;
    CGFloat _outterMargin;
    CGFloat _appViewSize;
    CGFloat _cellMarginTop;
    
    // setupGridInfo globals
    NSUInteger _windowType;
    NSSize _absSize;
    NSSize _relSize;
    
    // setupCellSize globals
    NSSize _numCell;
}


@end



@implementation GDDemoGrid


@synthesize thisGDScreen = _thisGDScreen;
@synthesize numCell = _numCell;
@synthesize gridInfo = _gridInfo; // stores info of the grid (its dimensions and location in screen)
@synthesize cellSize = _cellSize;



#pragma mark - WINDOW POSITION LOGIC

- (id) initWithGDScreen: (GDScreen *)screen {
    self = [super init];
    if (self != nil) {
        _thisGDScreen = screen;
        _windowType = [[[NSUserDefaults standardUserDefaults] objectForKey: GDMainWindowTypeKey] integerValue];
        
        NSData *absData = [[NSUserDefaults standardUserDefaults] objectForKey: GDMainWindowAbsoluteSizeKey];
        NSValue *unarchivedAbsData = [NSKeyedUnarchiver unarchiveObjectWithData: absData];
        _absSize = [unarchivedAbsData sizeValue];
        
        NSData *relData = [[NSUserDefaults standardUserDefaults] objectForKey: GDMainWindowRelativeSizeKey];
        NSValue *unarchivedRelData = [NSKeyedUnarchiver unarchiveObjectWithData: relData];
        _relSize = [_thisGDScreen getMainWindowSizeForScreenPercentageSize: [unarchivedRelData sizeValue]];

        NSData *numCelldata = [[NSUserDefaults standardUserDefaults] objectForKey: GDMainWindowGridUniversalDimensionsKey];
        NSValue *unarchivedNumCelldata = [NSKeyedUnarchiver unarchiveObjectWithData: numCelldata];
        _numCell = [unarchivedNumCelldata sizeValue];

        [self listenToNotifications];
        [self setupGridParams];
    }
    return self;
}



#pragma mark - notifications

- (void) listenToNotifications {
    // register for window events
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver: self
                      selector: @selector(onNewMainWindowType:)
                          name: GDMainWindowTypePostChanges
                        object: nil];
    
    [defaultCenter addObserver: self
                      selector: @selector(onNewMainWindowSize:)
                          name: GDMainWindowAbsoluteSizePostChanges
                        object: nil];
    
    [defaultCenter addObserver: self
                      selector: @selector(onNewMainWindowSize:)
                          name: GDMainWindowRelativeSizePostChanges
                        object: nil];
    
    [defaultCenter addObserver: self
                      selector: @selector(onNewCellDimensions:)
                          name: GDMainWindowGridUniversalDimensionsPostChanges
                        object: nil];
}


- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}


- (void) onNewMainWindowType: (NSNotification *) note {
    _windowType = [[[note userInfo] objectForKey: @"info"] integerValue];
    [self setupGridInfo];
    [self notifyUpdate];
}


- (void) onNewMainWindowSize: (NSNotification *) note {
    NSData *data = [note.userInfo objectForKey: @"info"];
    NSValue *unarchived = [NSKeyedUnarchiver unarchiveObjectWithData: data];
    NSSize newSize = [unarchived sizeValue];
    if (_windowType == 0) {
        _relSize = [_thisGDScreen getMainWindowSizeForScreenPercentageSize: newSize];
    } else {
        _absSize = newSize;
    }
    [self setupGridInfo];
    [self notifyUpdate];
}


- (void) onNewCellDimensions: (NSNotification *) note {
    NSData *data = [note.userInfo objectForKey: @"info"];
    NSValue *unarchived = [NSKeyedUnarchiver unarchiveObjectWithData: data];
    _cellSize = [unarchived sizeValue];
    [self setupCellSize];
    [self notifyUpdate];
}

- (void) notifyUpdate {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName: GDDemoGridValueUpdated
                      object: self
                    userInfo: nil];
}


#pragma mark - WINDOW POSITION LOGIC

- (void) setupGridParams {
    [self setupGridMeasurements];
    [self setupGridInfo];
    [_thisGDScreen setNumWidth: _numCell.width NumHeight: _numCell.height];
}


// TODO: find grid size based on user preferences/defaults
- (void) setupGridInfo {
    _gridInfo.size = (_windowType == 0) ? _relSize : _absSize;
    
    // center the grid
    _gridInfo.origin.x = (_thisGDScreen.screenInfo.size.width - _gridInfo.size.width) * 0.5 + _thisGDScreen.screenInfo.origin.x;
    _gridInfo.origin.y = (_thisGDScreen.screenInfo.size.height - _gridInfo.size.height) * 0.5 + _thisGDScreen.screenInfo.origin.y;
    
    [self setupCellSize];
}



#pragma mark - CELL SIZE LOGIC

- (void) setupGridMeasurements {
    _innerMargin = 5.0;
    _outterMargin = 15.0;
    _appViewSize = 48.0;
}


- (void) setupCellSize {
    _cellMarginTop = _appViewSize + _outterMargin;
    
    // calculate cell size
    _cellSize.width = (_gridInfo.size.width - 2*_outterMargin - (_numCell.width - 1)*_innerMargin)/_numCell.width;
    _cellSize.height = (_gridInfo.size.height - _cellMarginTop - 2*_outterMargin - (_numCell.height - 1)*_innerMargin)/_numCell.height;
}



#pragma mark - calculations

- (NSRect) getMainWindowFrame {
    return NSMakeRect(_gridInfo.origin.x, _gridInfo.origin.y,
                      _gridInfo.size.width, _gridInfo.size.height);
}


- (NSRect) getAppInfoFrame { // relative to mainWindowFrame
    return NSMakeRect(_outterMargin,
                      _gridInfo.size.height - _outterMargin - _appViewSize,
                      _gridInfo.size.width - 2*_outterMargin,
                      _appViewSize);
}


- (NSRect) getAppIconFrame { // relative to appInfoFrame
    return NSMakeRect(0, 0, _appViewSize, _appViewSize);
}


- (NSRect) getAppNameFrame { // relative to appInfoFrame
    CGFloat iconViewWidth = _appViewSize + _innerMargin;
    return NSMakeRect(iconViewWidth, 0,
                      _gridInfo.size.width - 2*_outterMargin - iconViewWidth,
                      _appViewSize);
}


- (NSRect) getCellCollectionRectFrame { // relative to mainWindowFrame
    return NSMakeRect(_outterMargin,
                      _outterMargin,
                      _gridInfo.size.width - 2*_outterMargin,
                      _gridInfo.size.height - 2*_outterMargin - _cellMarginTop);
}


- (NSRect) getCellViewFrameForCellX: (NSInteger)x // relative to getCellCollectionRectFrame
                                  Y: (NSInteger)y {
    return NSMakeRect(x*(_innerMargin + _cellSize.width),
                      y*(_innerMargin + _cellSize.height),
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
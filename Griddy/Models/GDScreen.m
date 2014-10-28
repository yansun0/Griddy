//
//  GDScreen.m
//  Griddy
//
//  Created by Yan Sun on 2014-07-05.
//  Copyright (c) 2014 Sunnay. All rights reserved.
//

#import "GDScreen.h"



@interface GDScreen()

@property (nonatomic) NSRect screenInfoFlipped;
@property (nonatomic) NSSize gridPixelSize;
@property (nonatomic) NSSize gridCellSize;

@end



@implementation GDScreen


@synthesize screenID = _screenID;
@synthesize screenInfo = _screenInfo;
@synthesize screenInfoFlipped = _screenInfoFlipped;
@synthesize gridPixelSize = _gridPixelSize; // dimension of cell in pixels
@synthesize gridCellSize = _gridCellSize; // number of cells


- (id) initWithScreen: (NSScreen *) screen {
    self = [super init];
    if (self != nil) {
        [self updateScreen: screen];
    }
    return self;
}


- (void) updateScreen: (NSScreen *)newScreen {
    _screenInfo = [newScreen visibleFrame];

    // flip the y
    _screenInfoFlipped = [newScreen visibleFrame];
    NSScreen *primaryScreen = [[NSScreen screens] objectAtIndex: 0];
    _screenInfoFlipped.origin.y = [primaryScreen visibleFrame].size.height - _screenInfoFlipped.origin.y - _screenInfoFlipped.size.height;

    _screenID = [[newScreen deviceDescription] objectForKey: @"NSScreenNumber"];
}


- (BOOL) isSameNSScreen:(NSScreen *)otherScreen {
    NSNumber *otherScreenID = [[otherScreen deviceDescription] objectForKey: @"NSScreenNumber"];
    NSRect otherScreenInfo = [otherScreen visibleFrame];
    if ([_screenID intValue] == [otherScreenID intValue]
        && NSEqualRects(otherScreenInfo, _screenInfo) == YES) {
        return YES;
    }
    return NO;
}


- (BOOL) isSameGDScreen:(GDScreen *)otherScreen {
    if ([_screenID intValue] == [otherScreen.screenID intValue]
        && NSEqualRects(otherScreen.screenInfo, _screenInfo) == YES) {
        return YES;
    }
    return NO;
}


- (void) setNumWidth: (NSInteger) numCellHorizontal
           NumHeight: (NSInteger) numCellVertical {
    _gridPixelSize.width = (1.0 / numCellHorizontal) * _screenInfo.size.width;
    _gridPixelSize.height = (1.0 / numCellVertical) * _screenInfo.size.height;
    _gridCellSize.width = numCellHorizontal;
    _gridCellSize.height = numCellVertical;
}


- (NSString *) getScreenBoundsForGridRect: (NSRect) newPosRect {
    CGFloat leftBound = newPosRect.origin.x * _gridPixelSize.width + _screenInfo.origin.x;
    CGFloat rightBound = (newPosRect.size.width * _gridPixelSize.width) + leftBound;
    CGFloat topBound = (_gridCellSize.height - (newPosRect.origin.y +  newPosRect.size.height)) * _gridPixelSize.height + _screenInfoFlipped.origin.y;
    CGFloat botBound = (newPosRect.size.height * _gridPixelSize.height) + topBound;

    NSString *result = [NSString stringWithFormat: @"{%d, %d, %d, %d}",
                                        (int) leftBound, (int) topBound,
                                        (int) rightBound, (int) botBound];
    return result;
}

// using cocoa coordinate system
- (NSRect) getScreenFrameForGridRect: (NSRect) gridRect {
    NSRect newFrame = NSMakeRect(
        gridRect.origin.x * _gridPixelSize.width + _screenInfo.origin.x,
        gridRect.origin.y * _gridPixelSize.height + _screenInfo.origin.y,
        gridRect.size.width * _gridPixelSize.width,
        gridRect.size.height * _gridPixelSize.height
    );
    return newFrame;
}

// use cg coordinate system
- (NSRect) getCGFrameForGridRect: (NSRect) gridRect {
    NSScreen *primaryScreen = [[NSScreen screens] objectAtIndex: 0];
    NSRect cocoaFrame = [self getScreenFrameForGridRect: gridRect];
    cocoaFrame.origin.y = [primaryScreen visibleFrame].size.height - cocoaFrame.origin.y - cocoaFrame.size.height; // flip the coordinate system, the deducate the height
    return cocoaFrame;
}


- (NSSize) getMainWindowSizeForScreenPercentageSize: (NSSize) sizeP {
    NSSize newSize = NSMakeSize(sizeP.width * _screenInfo.size.width, sizeP.height * _screenInfo.size.height);
    return newSize;
}


@end

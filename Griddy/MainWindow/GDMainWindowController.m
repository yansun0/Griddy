//
//  GDMainWindowViewController.m
//  Griddy
//
//  Created by Yan Sun on 2014-07-03.
//  Copyright (c) 2014 Sunnay. All rights reserved.
//

#import "GDMainWindowController.h"
#import "GDMainWindow.h"
#import "GDAppDelegate.h"
#import "GDGrid.h"
#import "GDScreen.h"



@interface GDMainWindowController ()

@property (nonatomic) NSPoint startCell;
@property (nonatomic) NSPoint curCell;
@property (nonatomic) NSPoint endCell;
@property (nonatomic) BOOL isInCell;
@property (nonatomic) NSString *frontApp;
@property (nonatomic) GDAppDelegate *appDelegate;

@end



@implementation GDMainWindowController

@synthesize thisGrid = _thisGrid;
@synthesize thisScreen = _thisScreen;
@synthesize thisWindow = _thisWindow;
@synthesize startCell = _startCell;
@synthesize curCell = _curCell;
@synthesize endCell = _endCell;
@synthesize frontApp = _frontApp;
@synthesize appDelegate = _appDelegate;

- (id) init {
    // no GD screen given, return nil
    return nil;
}

- (id) initWithGDScreen:(GDScreen *)screen {
    _thisScreen = screen;
    _thisGrid = [[GDGrid alloc] initWithGDScreen: screen];
    _appDelegate = (GDAppDelegate *)[[NSApplication sharedApplication] delegate];
    

    NSRect someFrame = [_thisGrid getMainWindowFrame];
    _thisWindow = [[GDMainWindow alloc] initWithRect: someFrame
                                          andGDGrid: _thisGrid];
    [_thisWindow setWindowController: self];
    
    // register for window events
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(windowUnfocused:)
                                                 name: NSWindowDidResignMainNotification
                                               object: _thisWindow];
    
    self = [super initWithWindow: _thisWindow];
    
    return self;
}

- (void) showWindow: (id) sender {
    [super showWindow: sender];
    [_thisWindow makeKeyAndOrderFront: sender];
    [NSApp activateIgnoringOtherApps: YES];

}

- (NSString *) description {
    return [NSString stringWithFormat: @"window controller for screen %@", _thisGrid.thisGDScreen.screenID];
}


- (void) windowUnfocused: (NSNotification *)note {
    // close other none focus windows, including one
    [_appDelegate closeAllUnfocusedWindowsIncluding: _thisWindow];
}

- (void) windowFocused: (NSNotification *)note {
    // close other windows, except for this one
    [_appDelegate closeAllOtherWindowsExcluding: _thisWindow];
}



#pragma mark - app delegate callbacks
- (void) setFrontApp: (NSString *)app {
    _frontApp = app;
}

- (void) hideWindow {
    [_thisWindow orderOut: nil];
}

- (BOOL) isWindowFocused {
    return [_thisWindow isMainWindow] || [_thisWindow isKeyWindow];
}

- (void) preventHideWindow {
    [_thisWindow setCanHide: NO];
}

- (void) enableHideWindow {
    [_thisWindow setCanHide: YES];
}



#pragma mark - cell callbacks
- (void) setHoverCellPosition: (NSPoint)pos
                WithMouseDown: (BOOL)isDown {
    NSRect newHoverPos;
    if (isDown) {
        newHoverPos = [_thisGrid getOverlayWindowFrameFromCell1: _startCell
                                                        ToCell2: _curCell];
    } else {
        newHoverPos = [_thisGrid getOverlayWindowFrameFromCell1: _curCell];
    }
    [_appDelegate showHoverWindowWithFrame: newHoverPos
                          BehindMainWindow: _thisWindow];
}

- (void) setStartCellPosition: (NSPoint) pos {
    _startCell = NSMakePoint(pos.x, pos.y);
}

- (void) setCurCellPosition: (NSPoint )pos {
    _curCell = NSMakePoint(pos.x, pos.y);
}

- (void) clearCurCellPosition {
    _curCell = CGPointZero; // reset
    [_appDelegate hideHoverWindow];
}

- (void) setEndCellPosition: (NSPoint) pos {
    // down + up from the same cell, sanity check
    if (NSEqualPoints(pos, _startCell) == YES) {
        NSLog(@"[START] -- (%d, %d)", (int)_startCell.x, (int)_startCell.y);
        NSLog(@"[END] -- (%d, %d)", (int)_curCell.x, (int)_curCell.y);
        NSString *result = [_thisGrid getNewWindowBoundsStringFromCell1: _startCell
                                                                ToCell2: _curCell];
        [_appDelegate moveAppWithResultRect: result];
    }
}

@end

//
//  GDMainWindowViewController.h
//  Griddy
//
//  Created by Yan Sun on 2014-07-03.
//  Copyright (c) 2014 Sunnay. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class GDMainWindow;
@class GDAppDelegate;
@class GDGrid;
@class GDScreen;



// ----------------------------------
#pragma mark - GDMainWindow
// ----------------------------------

@interface GDMainWindow : NSWindow

- (id) initWithRect: (NSRect)contentRect
          andGDGrid: (GDGrid *)grid;

@end





// ----------------------------------
#pragma mark - GDMainWindowController
// ----------------------------------

@interface GDMainWindowController : NSWindowController

@property GDGrid *thisGrid;
@property GDScreen *thisScreen;
@property GDMainWindow *thisWindow;

- (id) initWithGDScreen: (GDScreen *)screen;

// app delegate callbacks
- (BOOL) isWindowFocused;
- (void) hideWindow;
- (void) preventHideWindow;
- (void) enableHideWindow;

// window callbacks
- (void) windowFocused: (NSNotification *)note;
- (void) windowUnfocused: (NSNotification *)note;

// cell view callbacks
- (void) setStartCellPosition: (NSPoint)pos;
- (void) setCurCellPosition: (NSPoint)pos;
- (void) clearCurCellPosition;
- (void) setEndCellPosition: (NSPoint)pos;
- (void) setHoverCellPosition: (NSPoint)pos
                WithMouseDown: (BOOL)isDown;
@end

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



// ----------------------------------
#pragma mark - GDMainWindowController
// ----------------------------------

@interface GDMainWindowController : NSWindowController

@property (strong, nonatomic) GDGrid *thisGrid;

- (id) initWithGrid: (GDGrid *)grid;

// app delegate callbacks
- (void) showWindow: (id) sender;
- (void) showWindow: (id) sender
  BehindWindowLevel: (NSInteger) topWindowNumber;
- (void) hideWindow;
- (BOOL) isWindowFocused;
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



// ----------------------------------
#pragma mark - GDMainWindow
// ----------------------------------

@interface GDMainWindow : NSWindow

- (id) initWithGDGrid: (GDGrid *)grid;

@end

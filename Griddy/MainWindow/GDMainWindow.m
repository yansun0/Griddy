//
//  GDMainWindowViewController.m
//  Griddy
//
//  Created by Yan Sun on 2014-07-03.
//  Copyright (c) 2014 Sunnay. All rights reserved.
//

#import "GDMainWindow.h"
#import "GDMainWindowView.h"
#import "GDAppDelegate.h"
#import "GDGrid.h"


// default keys
extern NSString * const GDMoveMethodKey;

// notifications names
extern NSString * const GDMainWindowTypeChanged;
extern NSString * const GDMainWindowAbsoluteSizeChanged;
extern NSString * const GDMainWindowRelativeSizeChanged;
extern NSString * const GDMainWindowGridUniversalDimensionsChanged;
extern NSString * const GDMoveMethodChanged;




// ----------------------------------
#pragma mark - GDMainWindowController
// ----------------------------------

@interface GDMainWindowController ()

@property (nonatomic) NSPoint startCell;
@property (nonatomic) NSPoint curCell;
@property (nonatomic) NSPoint endCell;
@property (nonatomic) BOOL isInCell;
@property (nonatomic) GDAppDelegate *appDelegate;
@property (nonatomic) BOOL moveMethod;

@end



@implementation GDMainWindowController


@synthesize thisGrid = _thisGrid;
@synthesize startCell = _startCell;
@synthesize curCell = _curCell;
@synthesize endCell = _endCell;
@synthesize appDelegate = _appDelegate;
@synthesize moveMethod = _moveMethod;

- (id) initWithGrid: (GDGrid *) grid {
    _thisGrid = grid;
    _appDelegate = (GDAppDelegate *)[[NSApplication sharedApplication] delegate];
    _moveMethod = [[[NSUserDefaults standardUserDefaults] objectForKey: GDMoveMethodKey] integerValue];
    
    GDMainWindow *thisWindow = [[GDMainWindow alloc] initWithGDGrid: grid];
    [thisWindow setWindowController: self];
    self = [super initWithWindow: thisWindow];
    if (self != nil) {
        [self listenToNotifications];
    }
    return self;
}


- (void) reinitWindow: (NSNotification *) note {
    // destroy previous window
    NSInteger prevWindowLevel = self.window.level;
    self.window = nil;
    
    // make new window
    [_thisGrid setupGridParams];
    GDMainWindow *thisWindow = [[GDMainWindow alloc] initWithGDGrid: _thisGrid];
    [thisWindow setWindowController: self];
    self.window = thisWindow;
    self.window.level = prevWindowLevel;
}



#pragma mark - notifications

- (void) listenToNotifications {
    // register for window events
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver: self
                      selector: @selector(windowUnfocused:)
                          name: NSWindowDidResignMainNotification
                        object: self.window];
    [defaultCenter addObserver: self
                      selector: @selector(reinitWindow:)
                          name: GDMainWindowTypeChanged
                        object: nil];
    
    [defaultCenter addObserver: self
                      selector: @selector(reinitWindow:)
                          name: GDMainWindowAbsoluteSizeChanged
                        object: nil];
    
    [defaultCenter addObserver: self
                      selector: @selector(reinitWindow:)
                          name: GDMainWindowRelativeSizeChanged
                        object: nil];
    
    [defaultCenter addObserver: self
                      selector: @selector(reinitWindow:)
                          name: GDMainWindowGridUniversalDimensionsChanged
                        object: nil];
    
    [defaultCenter addObserver: self
                      selector: @selector(onMoveMethodChanged:)
                          name: GDMoveMethodChanged
                        object: nil];
}


- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}



#pragma mark - app delegate callbacks

- (void) showWindow: (id) sender {
    [super showWindow: sender];
    [self.window makeKeyAndOrderFront: sender];
    [NSApp activateIgnoringOtherApps: YES];
}


- (void) showWindow: (id) sender
  BehindWindowLevel: (NSInteger) topWindowLevel {
    [self.window display];
    [self.window orderWindow: NSWindowBelow relativeTo: topWindowLevel];
    [NSApp activateIgnoringOtherApps: YES];
}


- (void) showWindow: (id) sender
      AtWindowLevel: (NSInteger) prevWindowLevel {
    [self.window setLevel: prevWindowLevel];
    [self.window display];
    [self.window orderFront: sender];
    [NSApp activateIgnoringOtherApps: YES];
}


- (void) hideWindow {
    [self.window orderOut: nil];
}


- (BOOL) isWindowFocused {
    return [self.window isMainWindow] || [self.window isKeyWindow];
}


- (void) preventHideWindow {
    [self.window setCanHide: NO];
}


- (void) enableHideWindow {
    [self.window setCanHide: YES];
}



#pragma mark - window callbacks

- (void) windowUnfocused: (NSNotification *)note {
    // close other none focus windows, including one
    [_appDelegate closeAllUnfocusedWindowsIncluding: self.window];
}


- (void) windowFocused: (NSNotification *)note {
    // close other windows, except for this one
    [_appDelegate closeAllOtherWindowsExcluding: self.window];
}



#pragma mark - window callbacks

- (NSRunningApplication *) getCurrentApp {
    return _appDelegate.frontApp;
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
                          BehindMainWindow: self.window];
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


        NSRect rect;
        if (_moveMethod == 0) {
            rect = [_thisGrid getAppWindowFrameFromCell1: _startCell
                                                 ToCell2: _curCell];
            [_appDelegate moveAppWithResultRect: rect];

        } else {
            rect = [_thisGrid getAppWindowBoundsStringFromCell1: _startCell
                                                        ToCell2: _curCell];
            [_appDelegate moveAppWithResultRectForced: rect];
        }
    }
}

- (void) onMoveMethodChanged: (NSNotification *) note {
    _moveMethod = [[[note userInfo] objectForKey:@"info"] integerValue];
}

@end





// ----------------------------------
#pragma mark - GDMainWindow
// ----------------------------------

@implementation GDMainWindow


- (id) initWithGDGrid: (GDGrid *)grid {
    
    NSRect contentFrame = [grid getMainWindowFrame];

    self = [super initWithContentRect: contentFrame
                            styleMask: NSBorderlessWindowMask
                              backing: NSBackingStoreBuffered
                                defer: NO];
    if (self != nil) {
        // window setup
        self.styleMask = NSBorderlessWindowMask;
        self.hasShadow = YES;
        self.opaque = NO;
        self.backgroundColor = [NSColor clearColor];
        self.level = NSFloatingWindowLevel;

        [self setContentView: [[GDMainWindowMainView alloc] initWithGDGrid: grid]];
    }

    return self;
}


- (void) mouseDown: (NSEvent *) theEvent {
    [self.windowController windowFocused: nil];
}


- (BOOL) canBecomeKeyWindow {
    return YES;
}


- (BOOL) canBecomeMainWindow {
    return YES;
}


@end


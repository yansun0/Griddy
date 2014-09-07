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
#import "GDScreen.h"


// ----------------------------------
#pragma mark - GDMainWindow
// ----------------------------------

@implementation GDMainWindow

- (id) initWithRect: (NSRect)contentRect
          andGDGrid: (GDGrid *)grid {
    
    self = [self initWithContentRect: contentRect
                           styleMask: NSBorderlessWindowMask
                             backing: NSBackingStoreBuffered
                               defer: NO];
    
    // set content view
    NSRect viewRect = [grid getContentRectFrame];
    [self setContentView: [[GDMainWindowView alloc] initWithFrame: viewRect
                                                        andGDGrid: grid]];
    
    // set level
    [self setLevel: NSFloatingWindowLevel];
    
    
    // prevent hide
    return self;
}

- (id) initWithContentRect: (NSRect)contentRect
                 styleMask: (NSUInteger)aStyle
                   backing: (NSBackingStoreType)bufferingType
                     defer: (BOOL)flag {
    self = [super initWithContentRect: contentRect
                            styleMask: NSBorderlessWindowMask
                              backing: NSBackingStoreBuffered
                                defer: NO];
    if (self != nil) {
        [self setStyleMask: NSBorderlessWindowMask];
        [self setHasShadow: NO];
        [self setOpaque: NO];
        [self setBackgroundColor: [NSColor clearColor]];
    }
    return self;
}

- (void) setContentView: (NSView *)aView {
    aView.wantsLayer = YES;
    aView.layer.frame = aView.frame;
    aView.layer.cornerRadius = 15.0;
    aView.layer.masksToBounds = YES;
    
    [super setContentView: aView];
}

- (void) mouseDown: (NSEvent *) theEvent {
    [[self windowController] windowFocused: nil];
}

- (BOOL) canBecomeKeyWindow {
    return YES;
}

- (BOOL) canBecomeMainWindow {
    return YES;
}

@end





// ----------------------------------
#pragma mark - GDMainWindowController
// ----------------------------------

@interface GDMainWindowController ()

@property (nonatomic) NSPoint startCell;
@property (nonatomic) NSPoint curCell;
@property (nonatomic) NSPoint endCell;
@property (nonatomic) BOOL isInCell;
@property (nonatomic) GDAppDelegate *appDelegate;

@end



@implementation GDMainWindowController

@synthesize thisGrid = _thisGrid;
@synthesize thisScreen = _thisScreen;
@synthesize thisWindow = _thisWindow;
@synthesize startCell = _startCell;
@synthesize curCell = _curCell;
@synthesize endCell = _endCell;
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

- (void) windowUnfocused: (NSNotification *)note {
    // close other none focus windows, including one
    [_appDelegate closeAllUnfocusedWindowsIncluding: _thisWindow];
}

- (void) windowFocused: (NSNotification *)note {
    // close other windows, except for this one
    [_appDelegate closeAllOtherWindowsExcluding: _thisWindow];
}



#pragma mark - app delegate callbacks

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

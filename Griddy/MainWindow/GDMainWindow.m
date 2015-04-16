//
//  GDMainWindowViewController.m
//  Griddy
//
//  Created by Yan Sun on 2014-07-03.
//  Copyright (c) 2014 Sunnay. All rights reserved.
//

#import "GDApp.h"
#import "GDMainWindow.h"
#import "GDMainWindowView.h"
#import "GDOverlayWindow.h"

#import "GDGrid.h"
#import "GDScreen.h"

#import "GDUtils.h"



// notifications names
extern NSString * const GDMainWindowTypeChanged;
extern NSString * const GDMainWindowAbsoluteSizeChanged;
extern NSString * const GDMainWindowRelativeSizeChanged;
extern NSString * const GDMainWindowGridUniversalDimensionsChanged;



// -----------------------------------
#pragma mark - GDMainWindowController
// -----------------------------------


@implementation GDMainWindowController


- ( id ) initWithGrid: ( GDGrid * ) grid {
    GDMainWindow *win = [ [ GDMainWindow alloc ] initWithGrid: grid ];
    [ win setWindowController: self ];
    self = [ super initWithWindow: win ];
    if ( self != nil ) {
        self.grid = grid;
        [ self listenToNotifications ];
    }
    return self;
}


- ( void ) reinitWindow: ( NSNotification * ) note {
    NSInteger winLevel = [ super destoryWindow ];
    
    // make new window
    GDMainWindow *newWindow = [ [ GDMainWindow alloc ] initWithGrid: self.grid ];
    [ newWindow setWindowController: self ];
    self.window = newWindow;
    [ self showWindow: nil AtWindowLevel: winLevel ];
}



#pragma mark - notifications

- ( void ) listenToNotifications {
    NSNotificationCenter *defaultCenter = [ NSNotificationCenter defaultCenter ];
    [ defaultCenter addObserver: self
                       selector: @selector( windowUnfocused: )
                           name: NSWindowDidResignMainNotification
                         object: self.window ];
    [ defaultCenter addObserver: self
                       selector: @selector( reinitWindow: )
                           name: GDMainWindowTypeChanged
                         object: nil ];
    [ defaultCenter addObserver: self
                       selector: @selector( reinitWindow: )
                           name: GDMainWindowAbsoluteSizeChanged
                         object: nil ];
    [ defaultCenter addObserver: self
                       selector: @selector( reinitWindow: )
                           name: GDMainWindowRelativeSizeChanged
                         object: nil ];
    [ defaultCenter addObserver: self
                       selector: @selector( reinitWindow: )
                           name: GDMainWindowGridUniversalDimensionsChanged
                         object: nil ];
}



#pragma mark - app delegate callbacks

- ( void ) showWindow: ( id ) sender {
    [ super showWindow: sender AndMakeKey: YES ];
}


- ( BOOL ) isWindowFocused {
    return [ self.window isMainWindow ] || [ self.window isKeyWindow ];
}


- ( BOOL ) hasSameGDScreen: ( GDScreen * ) screen {
    return [ self.grid.screen isSameGDScreen: screen ];
}



#pragma mark - window callbacks

// close other none focus windows, including one
- ( void ) windowUnfocused: ( NSNotification * ) note {
    [ [ GDApp get ] hideAllUnfocusedWindowsIncluding: self.window ];
}


// close other windows, except for this one
- ( void ) windowFocused: ( NSNotification * ) note {
    [ [ GDApp get ] hideAllOtherWindowsExcluding: self.window ];
}



#pragma mark - cell callbacks

- ( void ) setHoverCellPosition: ( NSPoint ) pos
                  WithMouseDown: ( BOOL ) isDown {
    NSRect newHoverPos;
    if ( isDown ) {
        newHoverPos = [ self.grid getOverlayWindowFrameFromCell1: self.startCell
                                                         ToCell2: self.curCell ];
    } else {
        newHoverPos = [ self.grid getOverlayWindowFrameFromCell1: self.curCell ];
    }
    [ [ GDOverlayWindowController get ] showWindowWithRect: newHoverPos BehindMainWindow: self.window ];
}


- ( void ) setStartCellPosition: ( NSPoint ) pos {
    self.startCell = NSMakePoint( pos.x, pos.y );
}


- ( void ) setCurCellPosition: ( NSPoint ) pos {
    self.curCell = NSMakePoint( pos.x, pos.y );
}


- ( void ) clearCurCellPosition {
    self.curCell = CGPointZero; // reset
    [ [ GDOverlayWindowController get ] hideWindow ];
}


- ( void ) setEndCellPosition: ( NSPoint ) pos {
    if ( NSEqualPoints( pos, self.startCell ) == YES ) {
        [ GDUtils moveFromCell1: self.startCell
                        toCell2: self.curCell
                       withGrid: self.grid ];
        [ [ GDApp get ] hideWindows ];
    }
}


@end





// ----------------------------------
#pragma mark - GDMainWindow
// ----------------------------------

@implementation GDMainWindow


- ( id ) initWithGrid: ( GDGrid * ) grid {
    self = [ super initWithGrid: grid ];
    if ( self != nil ) {
        self.collectionBehavior = NSWindowCollectionBehaviorCanJoinAllSpaces;
        self.contentView = [ [ GDMainWindowView alloc ] initWithGrid: grid ];
    }
    return self;
}


- ( void ) mouseDown: ( NSEvent * ) theEvent {
    [ self.windowController windowFocused: nil ];
}


@end

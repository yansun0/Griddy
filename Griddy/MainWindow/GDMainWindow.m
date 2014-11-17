//
//  GDMainWindowViewController.m
//  Griddy
//
//  Created by Yan Sun on 2014-07-03.
//  Copyright (c) 2014 Sunnay. All rights reserved.
//

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





// ----------------------------------
#pragma mark - GDMainWindowControllers
// ----------------------------------


@interface GDMainWindowControllers() {
    BOOL windowsVisible;
    NSMutableArray *screens;
    NSMutableArray *controllers;
}
@end



@implementation GDMainWindowControllers : NSObject


+ ( id ) get {
    static GDMainWindowControllers *sharedController = nil;
    static dispatch_once_t onceToken;
    dispatch_once( &onceToken, ^{
        sharedController = [ [ self alloc ] init ];
    } );
    return sharedController;
}


- ( id ) init {
    self = [ super init ];
    if ( self ) {
        windowsVisible = NO;
        screens = [ [ NSMutableArray alloc ] initWithCapacity: 1 ];
        controllers = [ [ NSMutableArray alloc ] initWithCapacity: 1 ];
        [ self updateScreensAndControllers ];
    }
    return self;
}


- ( void ) updateScreensAndControllers {
    NSMutableArray *newScreens;
    NSMutableArray *rmScreens;
    [ GDUtils updateCurScreens: screens
                WithNewScreens: &newScreens
             AndRemovedScreens: &rmScreens ];
    
    // make new controllers for new screens if any
    if ( newScreens != nil ) {
        for ( NSUInteger i = 0; i < newScreens.count; i++ ) {
            GDScreen *newGDScreen = [ newScreens objectAtIndex: i ];
            GDGrid *newGrid = [ [ GDGrid alloc ] initWithGDScreen: newGDScreen ];
            GDMainWindowController *newWC = [ [ GDMainWindowController alloc ] initWithGrid: newGrid ];
            [ controllers addObject: newWC ];
        }
    }
    
    // remove controllers associate w/ removed screens if any
    if ( rmScreens != nil ) {
        for ( NSUInteger i = 0; i < newScreens.count; i++ ) {
            GDScreen *rmGDScreen = [ newScreens objectAtIndex: i ];
             for ( NSUInteger j = 0; j < controllers.count; j++ ) {
                GDMainWindowController *curWC = [ controllers objectAtIndex: j ] ;
                if ( [ curWC hasSameGDScreen: rmGDScreen ] == YES ) {
                    [ controllers removeObjectAtIndex: j ];
                    break;
                }
             }
        }
    }
}


- ( void ) showWindows {
    if ( [ GDUtils setFrontAppAndWindow ] ) {
        for ( NSUInteger i = 0; i < controllers.count; i++ ) {
            [ [ controllers objectAtIndex: i ] showWindow: nil ];
        }
        windowsVisible = YES;        
    }
}


- ( void ) hideWindows {
    [ [ GDOverlayWindowController get ] hideWindow ];
    for ( NSUInteger i = 0; i < controllers.count; i++ ) {
        GDMainWindowController *curWC = [ controllers objectAtIndex: i ];
        [ curWC hideWindow ];
    }
    windowsVisible = NO;
    [ NSApp hide: nil ];
}


- ( void ) toggleWindowState {
    if ( windowsVisible == YES ) {
        [ self hideWindows ];
    } else {
        [ self showWindows ];
    }
}


- ( void ) canHide: ( BOOL ) canWindowHide {
    for ( NSUInteger i = 0; i < controllers.count; i++ ) {
        [ [ controllers objectAtIndex: i ] canHide: canWindowHide ];
    }
}


- (void) hideAllUnfocusedWindowsIncluding: ( NSWindow * ) curWindow {
    NSUInteger numClosed = 0;
    for ( NSUInteger i = 0; i < controllers.count; i++ ) {
        GDMainWindowController *curWC = [ controllers objectAtIndex: i ];
        if ( [ curWC isWindowFocused ] == NO ) {
            [ curWC hideWindow ];
            numClosed = numClosed + 1;
        }
    }
    
    if ( numClosed == controllers.count ) {
        [ self hideWindows ]; // properly shutdown
    }
}


- ( void ) hideAllOtherWindowsExcluding: ( NSWindow * ) curWindow {
    for ( NSUInteger i = 0; i < controllers.count; i++ ) {
        GDMainWindowController *curWC = [ controllers objectAtIndex: i ];
        if ( [ curWC window ] != ( GDMainWindow * ) curWindow ) {
            [ curWC hideWindow ];
        }
    }
}



@end





// ----------------------------------
#pragma mark - GDMainWindowController
// ----------------------------------

@interface GDMainWindowController ()

@property (nonatomic) NSPoint startCell;
@property (nonatomic) NSPoint curCell;
@property (nonatomic) BOOL isInCell;

@end



@implementation GDMainWindowController


@synthesize thisGrid = _thisGrid;
@synthesize startCell = _startCell;
@synthesize curCell = _curCell;


- (id) initWithGrid: (GDGrid *) grid {
    _thisGrid = grid;
    
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


- ( void ) canHide: ( BOOL ) canWindowHide {
    self.window.canHide = canWindowHide;
}


- ( BOOL ) hasSameGDScreen: ( GDScreen * ) screen {
    return [ self.thisGrid.thisGDScreen isSameGDScreen: screen ];
}



#pragma mark - window callbacks

- (void) windowUnfocused: (NSNotification *)note {
    // close other none focus windows, including one
    [ [ GDMainWindowControllers get ] hideAllUnfocusedWindowsIncluding: self.window];
}


- (void) windowFocused: (NSNotification *)note {
    // close other windows, except for this one
    [ [ GDMainWindowControllers get ] hideAllOtherWindowsExcluding: self.window];
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
    [ [ GDOverlayWindowController get ] showWindowWithRect: newHoverPos BehindMainWindow: self.window ];
}


- (void) setStartCellPosition: (NSPoint) pos {
    _startCell = NSMakePoint(pos.x, pos.y);
}


- (void) setCurCellPosition: (NSPoint )pos {
    _curCell = NSMakePoint(pos.x, pos.y);
}


- (void) clearCurCellPosition {
    _curCell = CGPointZero; // reset
    [ [ GDOverlayWindowController get ] hideWindow ];
}


- (void) setEndCellPosition: (NSPoint) pos {
    if (NSEqualPoints(pos, _startCell) == YES) {
        [ GDUtils moveFromCell1: _startCell
                        toCell2: _curCell
                       withGrid: _thisGrid ];
        [ [ GDMainWindowControllers get ] hideWindows];
    }
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


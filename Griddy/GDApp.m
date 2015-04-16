//
//  GDApp.m
//  Griddy
//
//  Created by Yan Sun on 4 May 15.
//  Copyright (c) 2015 Sunnay. All rights reserved.
//

#import "GDApp.h"

#import "GDMainWindow.h"
#import "GDOverlayWindow.h"

#import "GDGrid.h"
#import "GDScreen.h"

#import "GDUtils.h"



@interface GDApp()

@property ( nonatomic ) BOOL windowsVisible;
@property ( strong, nonatomic ) NSMutableArray *screens;
@property ( strong, nonatomic ) NSMutableArray *controllers;

@end



@implementation GDApp : NSObject


+ ( id ) get {
    static GDApp *sharedController = nil;
    static dispatch_once_t onceToken;
    dispatch_once( &onceToken, ^{
        sharedController = [ [ self alloc ] init ];
    } );
    return sharedController;
}


- ( id ) init {
    self = [ super init ];
    if ( self ) {
        self.windowsVisible = NO;
        self.screens = [ [ NSMutableArray alloc ] initWithCapacity: 1 ];
        self.controllers = [ [ NSMutableArray alloc ] initWithCapacity: 1 ];
        [ self updateScreensAndControllers ];
    }
    return self;
}


- ( void ) updateScreensAndControllers {
    NSMutableArray *newScreens;
    NSMutableArray *rmScreens;
    [ GDUtils updateCurScreens: self.screens
                WithNewScreens: &newScreens
             AndRemovedScreens: &rmScreens ];
    
    // make new controllers for new screens if any
    if ( newScreens != nil ) {
        for ( NSUInteger i = 0; i < newScreens.count; i++ ) {
            GDScreen *newGDScreen = [ newScreens objectAtIndex: i ];
            GDGrid *newGrid = [ [ GDGrid alloc ] initWithGDScreen: newGDScreen ];
            GDMainWindowController *newWC = [ [ GDMainWindowController alloc ] initWithGrid: newGrid ];
            [ self.controllers addObject: newWC ];
        }
    }
    
    // remove controllers associate w/ removed screens if any
    if ( rmScreens != nil ) {
        for ( NSUInteger i = 0; i < newScreens.count; i++ ) {
            GDScreen *rmGDScreen = [ newScreens objectAtIndex: i ];
            for ( NSUInteger j = 0; j < self.controllers.count; j++ ) {
                GDMainWindowController *curWC = [ self.controllers objectAtIndex: j ] ;
                if ( [ curWC hasSameGDScreen: rmGDScreen ] == YES ) {
                    [ self.controllers removeObjectAtIndex: j ];
                    break;
                }
            }
        }
    }
}


- ( void ) showWindows {
    if ( [ GDUtils setFrontAppAndWindow ] ) {
        for ( NSUInteger i = 0; i < self.controllers.count; i++ ) {
            [ [ self.controllers objectAtIndex: i ] showWindow: nil ];
        }
        self.windowsVisible = YES;
    }
}


- ( void ) hideWindows {
    [ [ GDOverlayWindowController get ] hideWindow ];
    for ( NSUInteger i = 0; i < self.controllers.count; i++ ) {
        GDMainWindowController *curWC = [ self.controllers objectAtIndex: i ];
        [ curWC hideWindow ];
    }
    self.windowsVisible = NO;
    [ NSApp hide: nil ];
}


- ( void ) toggleWindowState {
    if ( self.windowsVisible == YES ) {
        [ self hideWindows ];
    } else {
        [ self showWindows ];
    }
}


- ( void ) canHide: ( BOOL ) canWindowHide {
    for ( NSUInteger i = 0; i < self.controllers.count; i++ ) {
        [ [ self.controllers objectAtIndex: i ] canHide: canWindowHide ];
    }
}


- (void) hideAllUnfocusedWindowsIncluding: ( NSWindow * ) curWindow {
    NSUInteger numClosed = 0;
    for ( NSUInteger i = 0; i < self.controllers.count; i++ ) {
        GDMainWindowController *curWC = [ self.controllers objectAtIndex: i ];
        if ( [ curWC isWindowFocused ] == NO ) {
            [ curWC hideWindow ];
            numClosed = numClosed + 1;
        }
    }
    
    if ( numClosed == self.controllers.count ) {
        [ self hideWindows ]; // properly shutdown
    }
}


- ( void ) hideAllOtherWindowsExcluding: ( NSWindow * ) curWindow {
    for ( NSUInteger i = 0; i < self.controllers.count; i++ ) {
        GDMainWindowController *curWC = [ self.controllers objectAtIndex: i ];
        if ( [ curWC window ] != ( GDMainWindow * ) curWindow ) {
            [ curWC hideWindow ];
        }
    }
}


@end

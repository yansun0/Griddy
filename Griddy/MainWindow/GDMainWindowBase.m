//
//  GDMainWindowBase.m
//  Griddy
//
//  Created by Yan Sun on 10 May 15.
//  Copyright (c) 2015 Sunnay. All rights reserved.
//

#import "GDMainWindowBase.h"
#import "GDGridBase.h"




// ----------------------------------
#pragma mark - GDMainWindowBaseController
// ----------------------------------

@implementation GDMainWindowBaseController


- ( NSInteger ) destoryWindow {
    // destroy previous window
    NSInteger windowLevel = self.window.level;
    self.window = nil; // release last window
    return windowLevel;
}


- ( void ) dealloc {
    [ [ NSNotificationCenter defaultCenter ] removeObserver: self ];
}


- ( void ) showWindow: ( id ) sender
           AndMakeKey: ( BOOL ) makeKeyFlag {
    [ super showWindow: sender ];
    if ( makeKeyFlag ) {
        [ self.window makeKeyAndOrderFront: sender ];
    } else {
        [self.window orderFront: sender];
    }
    [ NSApp activateIgnoringOtherApps: YES ];
}


- ( void ) showWindow: ( id ) sender
        AtWindowLevel: ( NSInteger ) prevWindowLevel {
    [ self.window setLevel: prevWindowLevel ];
    [ self.window display ];
    [ self.window orderFront: sender ];
    [ NSApp activateIgnoringOtherApps: YES ];
}


- ( void ) showWindow: ( id ) sender
      BehindWindowLevel: ( NSInteger ) topWindowLevel {
    [ self.window display ];
    [ self.window orderWindow: NSWindowBelow relativeTo: topWindowLevel ];
    [ NSApp activateIgnoringOtherApps: YES ];
}


- ( void ) hideWindow {
    [ self.window orderOut: nil ];
}


- ( void ) canHide: ( BOOL ) canWindowHide {
    self.window.canHide = canWindowHide;
}


@end




// ----------------------------------
#pragma mark - GDMainWindowBase
// ----------------------------------

@implementation GDMainWindowBase


- ( id ) initWithGrid: ( GDGridBase * ) grid {
    
    self = [ super initWithContentRect: grid.winFrame
                             styleMask: NSBorderlessWindowMask
                               backing: NSBackingStoreBuffered
                                 defer: NO ];
    if ( self != nil ) {
        // window setup
        self.styleMask = NSBorderlessWindowMask;
        self.hasShadow = YES;
        self.opaque = NO;
        self.backgroundColor = [ NSColor clearColor ];
        self.level = NSFloatingWindowLevel;
        self.collectionBehavior = NSWindowCollectionBehaviorCanJoinAllSpaces;
    }
    
    return self;
}


- ( BOOL ) canBecomeKeyWindow {
    return YES;
}


- ( BOOL ) canBecomeMainWindow {
    return YES;
}


@end

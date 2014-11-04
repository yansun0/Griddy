//
//  GDOverlayWindow.h
//  Griddy
//
//  Created by Yan Sun on 2014-08-02.
//  Copyright (c) 2014 Sunnay. All rights reserved.
//

#import <Cocoa/Cocoa.h>



// ----------------------------------
#pragma mark - GDOverlayWindowController
// ----------------------------------

@interface GDOverlayWindowController : NSWindowController

+ ( id ) get;
- ( void ) showWindowWithRect: (NSRect) newFrame
             BehindMainWindow: (NSWindow *) mainWindow;
- ( void ) hideWindow;
- ( void ) canHide: ( BOOL ) canWindowHide;

@end



// ----------------------------------
#pragma mark - GDOverlayWindow
// ----------------------------------

@interface GDOverlayWindow : NSWindow
@end



// ----------------------------------
#pragma mark - GDOverlayWindowViewWrapper
// ----------------------------------

@interface GDOverlayWindowViewWrapper : NSView
@end



// ----------------------------------
#pragma mark - GDOverlayWindowView
// ----------------------------------

@interface GDOverlayWindowView : NSView
@end
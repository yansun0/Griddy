 //
//  GDOverlayWindow.m
//  Griddy
//
//  Created by Yan Sun on 2014-08-02.
//  Copyright (c) 2014 Sunnay. All rights reserved.
//

#import "GDOverlayWindow.h"
#import "GDAssets.h"

extern NSString * const GDAppearanceModeChanged;
static NSRect defaultOverlayFrame;





// ----------------------------------
#pragma mark - GDOverlayWindowController
// ----------------------------------


@implementation GDOverlayWindowController


+ ( id ) get {
    static GDOverlayWindowController *sharedController = nil;
    static dispatch_once_t onceToken;
    dispatch_once( &onceToken, ^{
        sharedController = [ [ self alloc ] initWithWindow: nil ];
    } );
    return sharedController;
}


- ( id ) initWithWindow: ( NSWindow * ) window {
    if ( self = [ super initWithWindow: window ] ) {
        defaultOverlayFrame = NSMakeRect(0, 0, 10, 10);
        self.window = [ [ GDOverlayWindow alloc ] initWithContentRect: defaultOverlayFrame
                                                            styleMask: NSBorderlessWindowMask
                                                              backing: NSBackingStoreBuffered
                                                                defer: NO ];
    }
    return self;
}


- ( void ) showWindowWithRect: ( NSRect ) newFrame
           BehindMainWindow: ( NSWindow * ) mainWindow {
    [ self.window setFrame: newFrame
                   display: YES
                   animate: NO ];
    [ self.window orderWindow: NSWindowBelow
                   relativeTo: mainWindow.windowNumber ];
    [ NSApp activateIgnoringOtherApps: YES ];
}


- ( void ) hideWindow {
    [ self.window orderOut: nil ];
    [ self.window setFrame: defaultOverlayFrame
                   display: NO ];
}


- ( void ) canHide: ( BOOL ) canWindowHide {
    self.window.canHide = canWindowHide;
}


@end





// ----------------------------------
#pragma mark - GDOverlayWindow
// ----------------------------------


@implementation GDOverlayWindow


- ( id)  initWithContentRect: ( NSRect ) contentRect
                   styleMask: ( NSUInteger ) aStyle
                     backing: ( NSBackingStoreType ) bufferingType
                       defer: ( BOOL ) flag {
    self = [ super initWithContentRect: contentRect
                             styleMask: aStyle
                               backing: bufferingType
                                 defer: flag ];
    if ( self != nil ) {
        self.styleMask = aStyle;
        self.opaque = NO;
        self.hasShadow = NO;
        self.backgroundColor = [ NSColor clearColor ];
        self.collectionBehavior = NSWindowCollectionBehaviorCanJoinAllSpaces;
        self.contentView = [ [ GDOverlayWindowViewWrapper alloc ] initWithFrame: contentRect ];
    }
    return self;
}


// time in seconds to resize by 150 pixels
// need: all resize done in 10 ms
- ( NSTimeInterval ) animationResizeTime: ( NSRect ) newFrame {
    CGFloat totalChange = fabs( newFrame.size.height - self.frame.size.height )
        + fabs( newFrame.size.width - self.frame.size.width )
        + fabs( newFrame.origin.x - self.frame.origin.x )
        + fabs( newFrame.origin.y - self.frame.origin.y );
    return ( 0.025 / totalChange ) * 150;
}


- ( BOOL ) canBecomeKeyWindow {
    return NO;
}


@end





// ----------------------------------
#pragma mark - GDOverlayWindowViewWrapper
// ----------------------------------


@implementation GDOverlayWindowViewWrapper


- ( id ) initWithFrame: ( NSRect ) frame {
    self = [ super initWithFrame: frame ];
    if ( self ) {
        self.wantsLayer = YES;
        self.layer.frame = self.frame;
        
        // setup rounded corners
        self.layer.cornerRadius = 5.0f;
        self.layer.masksToBounds = YES;
        
        // setup border
        self.layer.borderWidth = 1.0f;
        self.layer.borderColor = [ [ GDAssets getWindowBorder ] CGColor ];
        
        // autoresize
        self.autoresizesSubviews = YES;
        
        frame.origin = NSMakePoint( 0, 0 );
        NSView *innerView = [ [ GDOverlayWindowView alloc ] initWithFrame: frame ];
        [ self addSubview: innerView ];
        
        [ [ NSNotificationCenter defaultCenter ] addObserver: self
                                                    selector: @selector( onAppearanceModeChanged: )
                                                        name: GDAppearanceModeChanged
                                                      object: nil ];
    }
    return self;
}


- ( void ) onAppearanceModeChanged: ( NSNotification * ) note {
    self.layer.borderColor = [ [ GDAssets getWindowBorder ] CGColor ];
}


- ( void ) drawRect: ( NSRect ) dirtyRect {
    [ [ NSColor clearColor ] set ];
    NSRectFill( dirtyRect);
}


- ( void ) dealloc {
    [ [ NSNotificationCenter defaultCenter ] removeObserver: self ];
}


@end





// ----------------------------------
#pragma mark - GDOverlayWindowView
// ----------------------------------


@implementation GDOverlayWindowView


- ( id ) initWithFrame: ( NSRect ) frame {
    self = [ super initWithFrame: frame ];
    if ( self ) {
        self.wantsLayer = YES;
        self.layer.frame = self.frame;
        
        // setup rounded corners
        self.layer.cornerRadius = 5.0f;
        self.layer.masksToBounds = YES;
        
        // setup border
        self.layer.borderWidth = 3.0f;
        self.layer.borderColor = [ [ GDAssets getOverlayInnerBorder ] CGColor ];
        
        // authresize
        self.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
        
        
        [ [ NSNotificationCenter defaultCenter ] addObserver: self
                                                    selector: @selector( onAppearanceModeChanged: )
                                                        name: GDAppearanceModeChanged
                                                      object: nil ];
    }
    return self;
}


- ( void ) onAppearanceModeChanged: ( NSNotification * ) note {
    self.layer.borderColor = [ [ GDAssets getWindowBorder ] CGColor];
}


- ( void ) drawRect: ( NSRect ) dirtyRect {
    self.layer.borderColor = [ [ GDAssets getOverlayInnerBorder ] CGColor ];
    [ [ GDAssets getOverlayBackground ] set ];
    NSRectFill( dirtyRect );
}


- ( void ) dealloc {
    [ [ NSNotificationCenter defaultCenter ] removeObserver: self ];
}


@end

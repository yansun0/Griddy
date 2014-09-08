 //
//  GDOverlayWindow.m
//  Griddy
//
//  Created by Yan Sun on 2014-08-02.
//  Copyright (c) 2014 Sunnay. All rights reserved.
//

#import "GDOverlayWindow.h"
#import "GDGrid.h"

@interface GDOverlayWindow()
typedef void *CGSConnection;
extern OSStatus CGSSetWindowBackgroundBlurRadius(CGSConnection connection,
                                                 NSInteger windowNumber,
                                                 int radius);
extern CGSConnection CGSDefaultConnectionForThread();
@end


@implementation GDOverlayWindow


- (id) initWithRect: (NSRect)contentRect {
    self = [self initWithContentRect: contentRect
                           styleMask: NSBorderlessWindowMask
                             backing: NSBackingStoreBuffered
                               defer: NO];
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
        [self setBackgroundColor:[NSColor colorWithCalibratedWhite:1.0 alpha:0.5]];
        [self enableBlurForWindow:self];
    }
    return self;
}


- (void) enableBlurForWindow: (NSWindow *)window {
    [window setOpaque:NO];
    window.backgroundColor = [NSColor colorWithCalibratedWhite:1.0 alpha:0.5];
    
    CGSConnection connection = CGSDefaultConnectionForThread();
    CGSSetWindowBackgroundBlurRadius(connection, [window windowNumber], 20);
}


- (void) setContentView: (NSView *)aView {
    aView.wantsLayer = YES;
    aView.layer.frame = aView.frame;
    aView.layer.cornerRadius = 15.0;
    aView.layer.masksToBounds = YES;
    
    [super setContentView: aView];
}


- (void) showWindow: (id) sender
          withFrame: (NSRect) frame {
    [self setFrame: frame display: YES];
    [self orderWindow: NSWindowBelow relativeTo: [(NSWindow *)sender windowNumber]];
    [NSApp activateIgnoringOtherApps: YES];
}


- (BOOL) canBecomeKeyWindow {
    return NO;
}


- (void) preventHideWindow {
    [self setCanHide: NO];
}


- (void) enableHideWindow {
    [self setCanHide: YES];
}


@end

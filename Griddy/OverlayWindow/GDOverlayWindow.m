 //
//  GDOverlayWindow.m
//  Griddy
//
//  Created by Yan Sun on 2014-08-02.
//  Copyright (c) 2014 Sunnay. All rights reserved.
//

#import "GDOverlayWindow.h"
#import "GDGrid.h"





// ----------------------------------
#pragma mark - GDOverlayWindow
// ----------------------------------

@interface GDOverlayWindow()

typedef void *CGSConnection;
extern OSStatus CGSSetWindowBackgroundBlurRadius(CGSConnection connection, NSInteger windowNumber, int radius);
extern CGSConnection CGSDefaultConnectionForThread();

@end



@implementation GDOverlayWindow


- (id) initWithRect: (NSRect) contentRect {
    self = [super initWithContentRect: contentRect
                           styleMask: NSBorderlessWindowMask
                             backing: NSBackingStoreBuffered
                               defer: NO];
    if (self != nil) {
        self.styleMask = NSBorderlessWindowMask;
        self.hasShadow = NO;
        self.opaque = NO;
        [self setContentView: [[GDOverlayWindowView alloc] initWithFrame: contentRect]];
        [self enableBlurForWindow: self];
    }
    return self;
}


- (void) enableBlurForWindow: (NSWindow *)window {
    window.opaque = NO;
    window.backgroundColor = [NSColor colorWithCalibratedWhite: 0.9 alpha: 0.5];
    
    CGSConnection connection = CGSDefaultConnectionForThread();
    CGSSetWindowBackgroundBlurRadius(connection, [window windowNumber], 20);
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





// ----------------------------------
#pragma mark - GDOverlayWindowView
// ----------------------------------

@implementation GDOverlayWindowView

- (id)initWithFrame: (NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.wantsLayer = YES;
        self.layer.frame = self.frame;
        self.layer.cornerRadius = 5.0;
        self.layer.masksToBounds = YES;
    }
    return self;
}

@end

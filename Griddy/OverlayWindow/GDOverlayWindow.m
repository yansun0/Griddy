 //
//  GDOverlayWindow.m
//  Griddy
//
//  Created by Yan Sun on 2014-08-02.
//  Copyright (c) 2014 Sunnay. All rights reserved.
//

#import "GDOverlayWindow.h"
#import "GDGrid.h"
#import "GDAssets.h"

extern NSString * const GDAppearanceModeChanged;


// ----------------------------------
#pragma mark - GDOverlayWindow
// ----------------------------------

@interface GDOverlayWindow()
// stuff
@end



@implementation GDOverlayWindow


- (id) initWithRect: (NSRect) contentRect {
    self = [super initWithContentRect: contentRect
                           styleMask: NSBorderlessWindowMask
                             backing: NSBackingStoreBuffered
                               defer: NO];
    if (self != nil) {
        // window setup
        self.styleMask = NSBorderlessWindowMask;
        self.opaque = NO;
        self.hasShadow = NO;
        self.backgroundColor = [NSColor clearColor];
        [self setContentView: [[GDOverlayWindowViewWrapper alloc] initWithFrame: contentRect]];
    }
    return self;
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
#pragma mark - GDOverlayWindowViewWrapper
// ----------------------------------

@implementation GDOverlayWindowViewWrapper

- (id) initWithFrame: (NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.wantsLayer = YES;
        self.layer.frame = self.frame;
        
        // setup rounded corners
        self.layer.cornerRadius = 5.0f;
        self.layer.masksToBounds = YES;
        
        // setup border
        self.layer.borderWidth = 1.0f;
        self.layer.borderColor = [[GDAssets getWindowBorder] CGColor];
        
        // autoresize
        self.autoresizesSubviews = YES;
        
        frame.origin = NSMakePoint(0, 0);
        NSView *innerView = [[GDOverlayWindowView alloc] initWithFrame: frame];
        [self addSubview: innerView];
        
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(onAppearanceModeChanged:)
                                                     name: GDAppearanceModeChanged
                                                   object: nil];
    }
    return self;
}

- (void) onAppearanceModeChanged: (NSNotification *) note {
    self.layer.borderColor = [[GDAssets getWindowBorder] CGColor];
}

- (void) drawRect: (NSRect) dirtyRect {
    [[NSColor clearColor] set];
    NSRectFill(dirtyRect);
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

@end



// ----------------------------------
#pragma mark - GDOverlayWindowView
// ----------------------------------

@implementation GDOverlayWindowView

- (id) initWithFrame: (NSRect)frame {
    self = [super initWithFrame: frame];
    if (self) {
        self.wantsLayer = YES;
        self.layer.frame = self.frame;
        
        // setup rounded corners
        self.layer.cornerRadius = 5.0f;
        self.layer.masksToBounds = YES;
        
        // setup border
        self.layer.borderWidth = 3.0f;
        self.layer.borderColor = [[GDAssets getOverlayInnerBorder] CGColor];
        
        // authresize
        self.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
        
        
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(onAppearanceModeChanged:)
                                                     name: GDAppearanceModeChanged
                                                   object: nil];
    }
    return self;
}

- (void) onAppearanceModeChanged: (NSNotification *) note {
    self.layer.borderColor = [[GDAssets getWindowBorder] CGColor];
}

- (void) drawRect: (NSRect) dirtyRect {
    self.layer.borderColor = [[GDAssets getOverlayInnerBorder] CGColor];
    [[GDAssets getOverlayBackground] set];
    NSRectFill(dirtyRect);
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

@end

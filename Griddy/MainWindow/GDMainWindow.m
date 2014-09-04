//
//  GDMainWindow.m
//  Griddy
//
//  Created by Yan Sun on 2014-07-07.
//  Copyright (c) 2014 Sunnay. All rights reserved.
//

#import "GDMainWindowController.h"
#import "GDMainWindow.h"
#import "GDMainWindowView.h"
#import "GDGrid.h"



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

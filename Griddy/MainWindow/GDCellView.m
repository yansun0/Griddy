//
//  GDCellView.m
//  Griddy
//
//  Created by Yan Sun on 2014-07-15.
//  Copyright (c) 2014 Sunnay. All rights reserved.
//

#import "GDCellView.h"
#import "GDMainWindowController.h"



@implementation GDCellView

@synthesize viewPosition = _viewPosition;

- (id)initWithFrame: (NSRect)frame
       andPositionX: (NSInteger)x
       andPositionY: (NSInteger)y {
    _viewPosition = NSMakePoint(x, y);
    return [self initWithFrame: frame];
}

- (id)initWithFrame: (NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        NSTrackingArea* trackingArea = [[NSTrackingArea alloc] initWithRect: [self bounds]
                                                                    options: (NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways | NSTrackingEnabledDuringMouseDrag)
                                                                      owner: self
                                                                   userInfo: nil];
        [self addTrackingArea: trackingArea];
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    [[NSColor colorWithCalibratedRed: 1.0
                               green: 0.5
                                blue: 0.0
                               alpha: 1.0] set];
    NSRectFill(dirtyRect);
}



#pragma mark - EVENTS
- (void) mouseEntered: (NSEvent *) theEvent {
    [[[self window] windowController] setCurCellPosition: _viewPosition];
    
    // show the hover window
    BOOL leftMouseDown = (([NSEvent pressedMouseButtons] & (1 << 0))) != 0;
    [[[self window] windowController] setHoverCellPosition: _viewPosition
                                         WithMouseDown: leftMouseDown];
}

- (void) mouseDown: (NSEvent *) theEvent {
    [[[self window] windowController] setStartCellPosition: _viewPosition];
    [super mouseDown: theEvent];
}

- (void) mouseUp: (NSEvent *) theEvent {
    [[[self window] windowController] setEndCellPosition: _viewPosition];
    [super mouseUp: theEvent];
}

- (void) mouseExited: (NSEvent *)theEvent {
    [super mouseExited: theEvent];
}

- (BOOL) acceptsFirstMouse: (NSEvent *)theEvent {
    return YES;
}

@end

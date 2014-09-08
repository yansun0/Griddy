//
//  GDMainWindowView.m
//  Griddy
//
//  Created by Yan Sun on 2014-07-13.
//  Copyright (c) 2014 Sunnay. All rights reserved.
//
#import "GDMainWindow.h"
#import "GDMainWindowView.h"
#import "GDScreen.h"
#import "GDGrid.h"
#import "GDCellView.h"



@interface GDMainWindowView() {
    GDGrid *_grid;
    BOOL isMouseDown;
    NSTrackingArea *_trackingArea;
}
@end



@implementation GDMainWindowView

- (id) initWithFrame: (NSRect)contentFrame
          andGDGrid: (GDGrid *)grid {
    _grid = grid;
    isMouseDown = NO;
    return [self initWithFrame: contentFrame];
}


- (id) initWithFrame: (NSRect)frame {
    self = [super initWithFrame: frame];
    
    if (self != nil) {
        for (NSInteger i = 0; i < (NSUInteger)_grid.numCell.width; i++) {
            for (NSInteger j = 0; j < (NSUInteger)_grid.numCell.height; j++) {
                NSRect cellFrame = [_grid getCellViewFrameForCellX:i Y:j];
                // NSLog(@"%@", CGRectCreateDictionaryRepresentation(cellFrame));
                NSView *cellFrameView = [[GDCellView alloc] initWithFrame: cellFrame
                                                             andPositionX: i
                                                             andPositionY: j];
                [self addSubview: cellFrameView];
            }
        }
    }
    
    return self;
}


- (void) drawRect: (NSRect)dirtyRect {
    [[NSColor colorWithCalibratedRed: 0.0
                               green: 0.5
                                blue: 1
                               alpha: 0.5] set];
    NSRectFill(dirtyRect);
}


- (void) mouseDown: (NSEvent *) theEvent {
    isMouseDown = YES;
    [self.window mouseDown: theEvent];
}


- (void) mouseUp: (NSEvent *) theEvent {
    isMouseDown = NO;
}


- (void) mouseExited: (NSEvent *) theEvent {
    NSPoint mousePos = [NSEvent mouseLocation];
    
    // TODO: change this to bounds w.r.t to window frame
    if (CGRectContainsPoint([self.window frame], mousePos) == NO) {
        [[self.window windowController] clearCurCellPosition];
    }
}


- (void) mouseDragged: (NSEvent *) theEvent {
    if (isMouseDown == NO) {    // don't care if mouse didn't come down
        return;                 // on one of this view's subviews
    }
    
    NSPoint mousePos = [NSEvent mouseLocation];

    // TODO: change this to bounds w.r.t to window frame
    if (CGRectContainsPoint([self.window frame], mousePos)) {     // don't care if its inside
        return;                                                     // the window
    }
    
    NSArray *cellSubViews = [self subviews];
    GDCellView *curClosestCellView;
    GDCellView *prevClosestCellView;
    CGFloat closestDistance = CGFLOAT_MAX;
    for (NSInteger i = 0; i < [cellSubViews count]; i++) {
        GDCellView *curView = [cellSubViews objectAtIndex: i];
        if ([curView isKindOfClass: [GDCellView class]] == NO) {
            continue;
        }
        
        CGRect frameRelativeToScreen = [[curView window] convertRectToScreen: [curView frame]];
        CGPoint curViewCenter = CGPointMake(CGRectGetMidX(frameRelativeToScreen), CGRectGetMidY(frameRelativeToScreen));
        CGFloat xDist = (curViewCenter.x - mousePos.x);
        CGFloat yDist = (curViewCenter.y - mousePos.y);
        CGFloat distance = sqrt((xDist * xDist) + (yDist * yDist));
        
        if (distance < closestDistance) {
            closestDistance = distance;
            curClosestCellView = curView;
        }
    }
    
    if ( prevClosestCellView == nil || prevClosestCellView != curClosestCellView ) {
        [curClosestCellView mouseEntered: theEvent];
        prevClosestCellView = curClosestCellView;
    }
}


@end

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





// ----------------------------------
#pragma mark - GDMainWindowMainView
// ----------------------------------

@interface GDMainWindowMainView() {
    GDGrid *_grid;
    BOOL isMouseDown;
    NSTrackingArea *_trackingArea;
    GDMainWindowAppInfoView *_appInfoView;
}
@end



@implementation GDMainWindowMainView



#pragma mark - INITIALIZATION

- (id) initWithFrame: (NSRect)contentFrame
           andGDGrid: (GDGrid *)grid {
    _grid = grid;
    isMouseDown = NO;
    
    NSRect cellCollectionViewRect = [grid getContentRectFrame];
    NSRect appInfoViewRect = [grid getAppInfoFrame];
    
    self = [super initWithFrame: contentFrame];
    
    if (self != nil) {
        // init app info view
        _appInfoView = [[GDMainWindowAppInfoView alloc] initWithFrame: appInfoViewRect
                                                            andGDGrid: _grid];
        [self addSubview: _appInfoView];
        
        // init cell views
        for (NSInteger i = 0; i < (NSUInteger)_grid.numCell.width; i++) {
            for (NSInteger j = 0; j < (NSUInteger)_grid.numCell.height; j++) {
                NSRect cellFrame = [_grid getCellViewFrameForCellX:i Y:j];
                NSView *cellFrameView = [[GDCellView alloc] initWithFrame: cellFrame
                                                             andPositionX: i
                                                             andPositionY: j];
                [self addSubview: cellFrameView];
            }
        }
    }
    
    return self;
}


- (void) drawRect: (NSRect) dirtyRect {
    [[NSColor colorWithCalibratedRed: 0.0
                               green: 0.5
                                blue: 1.0
                               alpha: 0.5] set];
    NSRectFill(dirtyRect);
}



#pragma mark - EVENTS

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





// ----------------------------------
#pragma mark - GDMainWindowAppInfoView
// ----------------------------------

@interface GDMainWindowAppInfoView() {
    GDGrid *_grid;
    NSImageView *_appIconView;
    NSView *_appNameView;
    NSRunningApplication *_curApp;
}
@end



@implementation GDMainWindowAppInfoView


- (id) initWithFrame: (NSRect) contentFrame
           andGDGrid: (GDGrid *) grid {
    _grid = grid;
    self = [super initWithFrame: contentFrame];
    
    if (self != nil) {
        [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver: self
                                                               selector: @selector(newApp:)
                                                                   name: NSWorkspaceDidDeactivateApplicationNotification
                                                                 object: nil];
        _appIconView = [[NSImageView alloc] initWithFrame: [_grid getAppIconFrame]];
        [_appIconView setImageScaling: NSImageScaleAxesIndependently];
        [_appIconView setWantsLayer: YES];
        _appIconView.layer.backgroundColor = [NSColor whiteColor].CGColor;
        
        _appNameView = [[NSView alloc] initWithFrame: [_grid getAppNameFrame]];
        [_appNameView setWantsLayer: YES];
        _appNameView.layer.backgroundColor = [NSColor whiteColor].CGColor;
        
        [self addSubview: _appIconView];
        [self addSubview: _appNameView];
    }
    
    return self;
}


- (void) newApp: (NSNotification *) note {
    NSRunningApplication *newApp = [[note userInfo] valueForKey: @"NSWorkspaceApplicationKey"];
    if (![_curApp isEqualTo: newApp]) {
        [_appIconView setImage: newApp.icon];
        _curApp = newApp;
    }
}


@end


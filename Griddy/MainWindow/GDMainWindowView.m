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
    GDMainWindowAppInfoView *_appInfoView;
    GDMainWindowCellCollectionView *_cellCollectionView;
}
@end



@implementation GDMainWindowMainView



#pragma mark - INITIALIZATION

- (id) initWithGDGrid: (GDGrid *) grid {
    self = [super initWithFrame: [grid getMainWindowFrame]];
    
    if (self != nil) {
        // setup self
        self.wantsLayer = YES;
        self.layer.frame = self.frame;
        self.layer.cornerRadius = 15.0;
        self.layer.masksToBounds = YES;
        
        // setup app info view
        _appInfoView = [[GDMainWindowAppInfoView alloc] initWithGDGrid: grid];
        [self addSubview: _appInfoView];
        
        // setup cell views
        _cellCollectionView = [[GDMainWindowCellCollectionView alloc] initWithGDGrid: grid];
        [self addSubview: _cellCollectionView];
    }
    
    return self;
}


- (void) drawRect: (NSRect) dirtyRect {
    [[NSColor colorWithCalibratedRed: 0.0
                               green: 0.0
                                blue: 0.0
                               alpha: 0.6] set];
    NSRectFill(dirtyRect);
}



@end





// ----------------------------------
#pragma mark - GDMainWindowAppInfoView
// ----------------------------------

@interface GDMainWindowAppInfoView() {
    NSImageView *_appIconView;
    NSTextField *_appNameView;
    NSRunningApplication *_curApp;
}
@end



@implementation GDMainWindowAppInfoView


- (id) initWithGDGrid: (GDGrid *) grid {
    self = [super initWithFrame: [grid getAppInfoFrame]];
    
    if (self != nil) {
        [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver: self
                                                               selector: @selector(newApp:)
                                                                   name: NSWorkspaceDidDeactivateApplicationNotification
                                                                 object: nil];
        _appIconView = [[NSImageView alloc] initWithFrame: [grid getAppIconFrame]];
        [_appIconView setImageScaling: NSImageScaleAxesIndependently];
        
        _appNameView = [[NSTextField alloc] initWithFrame: [grid getAppNameFrame]];
        [_appNameView setBezeled: NO];
        [_appNameView setDrawsBackground: NO];
        [_appNameView setEditable: NO];
        [_appNameView setSelectable: NO];
        
        [self addSubview: _appIconView];
        [self addSubview: _appNameView];
    }
    
    return self;
}


- (void) newApp: (NSNotification *) note {
    NSRunningApplication *newApp = [[note userInfo] valueForKey: @"NSWorkspaceApplicationKey"];
    if (![_curApp isEqualTo: newApp]) {
        [_appIconView setImage: newApp.icon];
        [_appNameView setStringValue: newApp.localizedName];
        _curApp = newApp;
    }
}


@end





// ----------------------------------
#pragma mark - GDMainWindowCellCollectionView
// ----------------------------------

@interface GDMainWindowCellCollectionView() {
    BOOL isMouseDown;
    NSTrackingArea *_trackingArea;
}
@end



@implementation GDMainWindowCellCollectionView


- (id) initWithGDGrid: (GDGrid *) grid {
    isMouseDown = NO;

    self = [super initWithFrame: [grid getCellCollectionRectFrame]];
    
    if (self != nil) {
        // setup self
        self.wantsLayer = YES;
        self.layer.frame = self.frame;
        self.layer.cornerRadius = 5.0;
        self.layer.masksToBounds = YES;
        
        // setup cells views
        for (NSInteger i = 0; i < (NSUInteger)grid.numCell.width; i++) {
            for (NSInteger j = 0; j < (NSUInteger)grid.numCell.height; j++) {
                NSRect cellFrame = [grid getCellViewFrameForCellX:i Y:j];
                NSView *cellFrameView = [[GDCellView alloc] initWithFrame: cellFrame
                                                             andPositionX: i
                                                             andPositionY: j];
                [self addSubview: cellFrameView];
            }
        }
    }
    
    return self;
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
    NSRect frameRelativeToWindow = [self convertRect:self.bounds toView:nil];
    NSRect frameRelativeToScreen = [self.window convertRectToScreen: frameRelativeToWindow];
    if (CGRectContainsPoint(frameRelativeToScreen, mousePos) == NO) {
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


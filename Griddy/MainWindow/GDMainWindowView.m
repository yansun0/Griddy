//
//  GDMainWindowView.m
//  Griddy
//
//  Created by Yan Sun on 2014-07-13.
//  Copyright (c) 2014 Sunnay. All rights reserved.
//
#import "GDMainWindow.h"
#import "GDMainWindowView.h"

#import "GDGrid.h"
#import "GDUtils.h"





// ----------------------------------
#pragma mark - GDMainWindowMainView
// ----------------------------------

@interface GDMainWindowView()

@property ( strong, nonatomic ) GDMainWindowAppInfoViewController *appInfo;
@property ( strong, nonatomic ) GDMainWindowCellCollectionView *cellCollection;

@end


@implementation GDMainWindowView

- ( id ) initWithGrid: ( GDGrid * ) grid {
    self = [ super initWithGrid: grid ];
    
    if ( self != nil ) {
        self.appInfo = [ [ GDMainWindowAppInfoViewController alloc ] initWithGrid: grid ];
        [ self addSubview: self.appInfo.view ];
        
        // setup cell views
        self.cellCollection = [ [ GDMainWindowCellCollectionView alloc ] initWithGrid: grid ];
        [ self addSubview: self.cellCollection ];
    }
    
    return self;
}


@end





// ----------------------------------
#pragma mark - GDMainWindowAppInfoView
// ----------------------------------

// controller

@implementation GDMainWindowAppInfoViewController

- ( id ) initWithGrid: ( GDGrid * ) grid {
    self = [ super initWithNibName: nil
                            bundle: nil ];
    
    if ( self != nil ) {
        GDMainWindowAppInfoView *appInfoView = [ [ GDMainWindowAppInfoView alloc ] initWithGrid: grid ];
        self.view = appInfoView;
    }
    return self;
}


- ( void ) viewDidAppear {
    GDMainWindowAppInfoView *appInfoView = ( GDMainWindowAppInfoView * )self.view;
    [ appInfoView newApp: [ GDUtils getFrontApp ] ];
}

@end


// view

@implementation GDMainWindowAppInfoView

- ( void ) newApp: ( NSRunningApplication * ) newApp {
    if ( ![ self.curApp isEqualTo: newApp ] ) {
        self.appIcon.image = newApp.icon;
        
        self.appName.stringValue = newApp.localizedName;
        [ self.appName sizeToFit ];
        
        self.curApp = newApp;
    }
}

@end





// ----------------------------------
#pragma mark - GDMainWindowCellCollectionView
// ----------------------------------

@implementation GDMainWindowCellCollectionView


#pragma mark - INITIALIZATION

- ( id ) initWithGrid: ( GDGrid * ) grid {
    self = [ super initWithFrame: [ grid getCellCollectionRectFrame ] ];
    
    if ( self != nil ) {
        self.isMouseDown = NO;

        // setup cells views
        for ( NSInteger i = 0; i < ( NSUInteger ) grid.numCell.width; i++ ) {
            for ( NSInteger j = 0; j < ( NSUInteger ) grid.numCell.height; j++ ) {
                NSRect cellFrame = [ grid getCellViewFrameForCellX: i Y: j ];
                NSView *cellFrameView = [ [ GDCellView alloc ] initWithFrame: cellFrame
                                                                andPositionX: i
                                                                andPositionY: j ];
                [ self addSubview: cellFrameView ];
            }
        }
    }
    
    return self;
}



#pragma mark - EVENTS

- ( void ) mouseDown: ( NSEvent *) theEvent {
    self.isMouseDown = YES;
    [self.window mouseDown: theEvent];
}


- ( void ) mouseUp: ( NSEvent * ) theEvent {
    self.isMouseDown = NO;
}


- ( void ) mouseExited: ( NSEvent * ) theEvent {
    if ( self.isMouseDown == NO ) {
        [ [ self.window windowController ] clearCurCellPosition ];
    }
}


- ( void ) mouseDragged: ( NSEvent * ) theEvent {
    if ( self.isMouseDown == NO ) {    // don't care if mouse didn't come down
        return;                        // on one of this view's subviews
    }
    
    NSPoint mousePos = [ NSEvent mouseLocation ];
    NSRect frameRelativeToWindow = [ self convertRect: self.bounds toView: nil ];
    NSRect frameRelativeToScreen = [ self.window convertRectToScreen: frameRelativeToWindow ];
    if ( CGRectContainsPoint( frameRelativeToScreen, mousePos ) ) {
        return;
    }
    
    NSArray *cellSubViews = [ self subviews ];
    GDCellView *curClosestCellView;
    CGFloat closestDistance = CGFLOAT_MAX;
    for ( NSInteger i = 0; i < [ cellSubViews count ]; i++ ) {
        GDCellView *curView = [ cellSubViews objectAtIndex: i ];
        if ( [ curView isKindOfClass: [GDCellView class ] ] == NO ) {
            continue;
        }
        
        CGRect frameRelativeToScreen = [ [ curView window ] convertRectToScreen: [ curView frame ] ];
        CGPoint curViewCenter = CGPointMake( CGRectGetMidX( frameRelativeToScreen ), CGRectGetMidY( frameRelativeToScreen ) );
        CGFloat xDist = ( curViewCenter.x - mousePos.x );
        CGFloat yDist = ( curViewCenter.y - mousePos.y );
        CGFloat distance = sqrt( ( xDist * xDist ) + ( yDist * yDist ) );
        
        if ( distance < closestDistance ) {
            closestDistance = distance;
            curClosestCellView = curView;
        }
    }
    
    [ curClosestCellView mouseEntered: theEvent ];
}


@end





// -----------------------
#pragma mark - GDCellView
// -----------------------

@implementation GDCellView


- ( id ) initWithFrame: ( NSRect ) frame
          andPositionX: ( NSInteger ) x
          andPositionY: ( NSInteger ) y {
    self.viewPosition = NSMakePoint( x, y );
    return [ self initWithFrame: frame ];
}


- ( id ) initWithFrame: ( NSRect ) frame {
    self = [ super initWithFrame: frame ];
    
    if ( self ) {
        NSTrackingArea* trackingArea = [ [ NSTrackingArea alloc ] initWithRect: [ self bounds ]
                                                                    options: ( NSTrackingMouseEnteredAndExited |
                                                                               NSTrackingActiveAlways |
                                                                               NSTrackingEnabledDuringMouseDrag )
                                                                      owner: self
                                                                   userInfo: nil ];
        [ self addTrackingArea: trackingArea ];
    }
    
    return self;
}


#pragma mark - EVENTS

- ( void ) mouseEntered: ( NSEvent * ) evt {
    [ [ self.window windowController ] setCurCellPosition: self.viewPosition ];
    
    // show the hover window
    BOOL leftMouseDown = ( ( [ NSEvent pressedMouseButtons ] & ( 1 << 0 ) ) ) != 0;
    [ [ self.window windowController ] setHoverCellPosition: self.viewPosition
                                              WithMouseDown: leftMouseDown ];
}


- ( void ) mouseDown: ( NSEvent * ) evt {
    [ [ self.window windowController ] setStartCellPosition: self.viewPosition ];
    [ super mouseDown: evt ];
}


- ( void ) mouseUp: ( NSEvent * ) evt {
    [ [ self.window windowController ] setEndCellPosition: self.viewPosition ];
    [ super mouseUp: evt ];
}


- ( BOOL ) acceptsFirstMouse: ( NSEvent * ) evt {
    return YES;
}


@end



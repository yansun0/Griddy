//
//  GDMainWindowView.m
//  Griddy
//
//  Created by Yan Sun on 2014-07-13.
//  Copyright (c) 2014 Sunnay. All rights reserved.
//
#import "GDMainWindow.h"
#import "GDMainWindowView.h"

#import "GDUtils.h"

#import "GDScreen.h"
#import "GDGrid.h"
#import "GDAssets.h"


extern NSString * const GDAppearanceModeChanged;





// ----------------------------------
#pragma mark - GDMainWindowMainView
// ----------------------------------

@interface GDMainWindowMainView() {
    GDMainWindowAppInfoViewController *_appInfoViewController;
    GDMainWindowCellCollectionView *_cellCollectionView;
}
@end



@implementation GDMainWindowMainView

- ( id ) initWithGDGrid: ( GDGrid * ) grid {
    self = [ super initWithFrame: [ grid getMainWindowFrame ] ];
    
    if ( self != nil ) {
        // setup self
        self.wantsLayer = YES;
        self.layer.frame = self.frame;
        self.layer.cornerRadius = 15.0;
        self.layer.masksToBounds = YES;
        
        // setup border
        self.layer.borderWidth = 1.0f;
        self.layer.borderColor = [ [ GDAssets getWindowBorder ] CGColor ];
        
        // setup vibrancy
        self.material = [ GDAssets getWindowMaterial ];
        self.blendingMode = NSVisualEffectBlendingModeBehindWindow;
        self.state = NSVisualEffectStateActive;
        
        // setup app info view
        _appInfoViewController = [ [ GDMainWindowAppInfoViewController alloc ] initWithGDGrid: grid ];
        [ self addSubview: _appInfoViewController.view ];
        
        // setup cell views
        _cellCollectionView = [ [ GDMainWindowCellCollectionView alloc ] initWithGDGrid: grid ];
        [ self addSubview: _cellCollectionView ];

        [ [ NSNotificationCenter defaultCenter ] addObserver: self
                                                    selector: @selector( onAppearanceModeChanged: )
                                                        name: GDAppearanceModeChanged
                                                      object: nil ];
    }
    
    return self;
}


- ( void ) onAppearanceModeChanged: ( NSNotification * ) note {
    self.material = [ GDAssets getWindowMaterial ];
    self.layer.borderColor = [ [ GDAssets getWindowBorder ] CGColor ];
}


- ( void ) dealloc {
    [ [ NSNotificationCenter defaultCenter ] removeObserver: self ];
}

@end





// ----------------------------------
#pragma mark - GDMainWindowAppInfoView
// ----------------------------------

// controller

@implementation GDMainWindowAppInfoViewController

- ( id ) initWithGDGrid: ( GDGrid * ) grid {
    self = [ super initWithNibName: nil
                            bundle: nil ];
    
    if ( self != nil ) {
        GDMainWindowAppInfoView *appInfoView = [ [ GDMainWindowAppInfoView alloc ] initWithGDGrid: grid ];
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

@interface GDMainWindowAppInfoView() {
    NSImageView *_appIconView;
    NSTextField *_appNameView;
    NSRunningApplication *_curApp;
}
@end


@implementation GDMainWindowAppInfoView

- ( id ) initWithGDGrid: ( GDGrid * ) grid {
    self = [ super initWithFrame: [ grid getAppInfoFrame ] ];
    
    if ( self != nil ) {
        _appIconView = [ [ NSImageView alloc ] initWithFrame: [ grid getAppIconFrame ] ];
        _appIconView.imageScaling = NSImageScaleAxesIndependently;
        [ self addSubview: _appIconView ];
        
        _appNameView = [ [ NSTextField alloc ] initWithFrame: [ grid getAppNameFrame ] ];
        _appNameView.bezeled = NO;
        _appNameView.drawsBackground = NO;
        _appNameView.editable = NO;
        _appNameView.selectable = NO;
        _appNameView.textColor = [ GDAssets getTextColor ];
        [ self addSubview: _appNameView ];
    
        [ [ NSNotificationCenter defaultCenter ] addObserver: self
                                                    selector: @selector( onAppearanceModeChanged: )
                                                        name: GDAppearanceModeChanged
                                                      object: nil ];
    }
    
    return self;
}


- ( void ) dealloc {
    [ [ NSNotificationCenter defaultCenter ] removeObserver: self ];
}


- ( void ) newApp: ( NSRunningApplication * ) newApp {
    if ( ![ _curApp isEqualTo: newApp ] ) {
        // icon
        _appIconView.image = newApp.icon;
        
        // name
        _appNameView.stringValue = newApp.localizedName;
        [ _appNameView sizeToFit ];
        _curApp = newApp;
    }
}


- ( void ) onAppearanceModeChanged: ( NSNotification * ) note {
    _appNameView.textColor = [ GDAssets getTextColor ];
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


#pragma mark - INITIALIZATION

- (id) initWithGDGrid: (GDGrid *) grid {
    self = [super initWithFrame: [grid getCellCollectionRectFrame]];
    
    if (self != nil) {
        isMouseDown = NO;

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
    
    NSRect frameRelativeToWindow = [self convertRect: self.bounds toView: nil];
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
    NSRect frameRelativeToWindow = [self convertRect:self.bounds toView: nil];
    NSRect frameRelativeToScreen = [self.window convertRectToScreen: frameRelativeToWindow];
    if (CGRectContainsPoint(frameRelativeToScreen, mousePos)) {
        return;
    }
    
    NSArray *cellSubViews = [self subviews];
    GDCellView *curClosestCellView;
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
    [curClosestCellView mouseEntered: theEvent];
}


@end





// ----------------------------------
#pragma mark - GDCellView
// ----------------------------------


@implementation GDCellView


@synthesize viewPosition = _viewPosition;


- (id) initWithFrame: (NSRect) frame
        andPositionX: (NSInteger) x
        andPositionY: (NSInteger) y {
    _viewPosition = NSMakePoint(x, y);
    return [self initWithFrame: frame];
}


- (id) initWithFrame: (NSRect) frame {
    self = [super initWithFrame:frame];
    if (self) {
        NSTrackingArea* trackingArea = [[NSTrackingArea alloc] initWithRect: [self bounds]
                                                                    options: (NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways | NSTrackingEnabledDuringMouseDrag)
                                                                      owner: self
                                                                   userInfo: nil];
        [self addTrackingArea: trackingArea];
        
        self.wantsLayer = YES;
        self.layer.frame = self.frame;
        
        // setup rounded corners
        self.layer.cornerRadius = 3.0f;
        self.layer.masksToBounds = YES;
        
        // setup border
        self.layer.borderWidth = 1.0f;
        self.layer.borderColor = [[GDAssets getCellBorderBackground] CGColor];

        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(onAppearanceModeChanged:)
                                                     name: GDAppearanceModeChanged
                                                   object: nil];
    }
    
    return self;
}


- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}


- (void) onAppearanceModeChanged: (NSNotification *) note {
    self.layer.borderColor = [[GDAssets getCellBorderBackground] CGColor];
}


- (void) drawRect: (NSRect) dirtyRect {
    [[GDAssets getCellBackground] set];
    NSRectFill(dirtyRect);
}



#pragma mark - EVENTS

- (void) mouseEntered: (NSEvent *) theEvent {
    [[self.window windowController] setCurCellPosition: _viewPosition];
    
    // show the hover window
    BOOL leftMouseDown = (([NSEvent pressedMouseButtons] & (1 << 0))) != 0;
    [[self.window windowController] setHoverCellPosition: _viewPosition
                                           WithMouseDown: leftMouseDown];
}


- (void) mouseDown: (NSEvent *) theEvent {
    [[self.window windowController] setStartCellPosition: _viewPosition];
    [super mouseDown: theEvent];
}


- (void) mouseUp: (NSEvent *) theEvent {
    [[self.window windowController] setEndCellPosition: _viewPosition];
    [super mouseUp: theEvent];
}


- (void) mouseExited: (NSEvent *)theEvent {
    [super mouseExited: theEvent];
}


- (BOOL) acceptsFirstMouse: (NSEvent *)theEvent {
    return YES;
}


@end



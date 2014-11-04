//
//  GDDemoMainWindow.m
//  Griddy
//
//  Created by Yan Sun on 2014-09-14.
//  Copyright (c) 2014 Sunnay. All rights reserved.
//

#import "GDDemoMainWindow.h"
#import "GDDemoGrid.h"
#import "GDScreen.h"
#import "GDAssets.h"


NSString * const GDDemoGridValueUpdated = @"GDDemoGridValueUpdated";
extern NSString * const GDAppearanceModeChanged;



// ----------------------------
#pragma mark - GDDemoController
// ----------------------------

@interface GDDemoController () {
    NSMutableArray * _grids;
    NSMutableArray * _windowControllers;
}

@end

@implementation GDDemoController


- (id) init {
    self = [super init];
    if (self) {
        _grids = [self getGrids];
        _windowControllers = [self getWindowControllersFromGrids: _grids];
    }
    return self;
}


- (NSMutableArray *) getGrids {
    NSArray *screenArray = [NSScreen screens];
    NSMutableArray *grids = [[NSMutableArray alloc] init];
    // step 1. add a screen that's not already in the avaliable screen array
    for (NSUInteger i = 0; i < screenArray.count; i++)  {
        NSScreen *curScreen = [screenArray objectAtIndex: i];
        GDScreen *newGDScreen = [[GDScreen alloc] initWithScreen: curScreen];
        GDDemoGrid *newGrid = [[GDDemoGrid alloc] initWithGDScreen: newGDScreen];
        [grids addObject: newGrid];
    }
    return grids;
}


- (NSMutableArray *) getWindowControllersFromGrids: (NSMutableArray *) grids {
    NSMutableArray * windowControllers = [[NSMutableArray alloc] initWithCapacity:1];
    
    for (int i = 0; i < grids.count; i++) {
        GDDemoGrid *curGrid = [grids objectAtIndex: i];
        GDDemoMainWindowController *curWC = [[GDDemoMainWindowController alloc] initWithGrid: curGrid];
        [windowControllers addObject: curWC];
    }
    return windowControllers;
}




#pragma mark - WINDOW FUNCTIONS

- (void) launchWindows {
    for (NSUInteger i = 0; i < _windowControllers.count; i++) {
        [[_windowControllers objectAtIndex: i] showWindow: nil];
    }
}


- (void) hideWindows {
    for (NSUInteger i = 0; i < _windowControllers.count; i++) {
        GDDemoMainWindowController *curWC = [_windowControllers objectAtIndex: i];
        [curWC hideWindow];
    }
}

- (void) preventAllWindowHiding {
    for (NSUInteger i = 0; i < _windowControllers.count; i++) {
        [[_windowControllers objectAtIndex: i] preventHideWindow];
    }
}


- (void) enableAllWindowHiding {
    for (NSUInteger i = 0; i < _windowControllers.count; i++) {
        [[_windowControllers objectAtIndex: i] enableHideWindow];
    }
}


@end





// --------------------------------------
#pragma mark - GDDemoMainWindowController
// --------------------------------------

@interface GDDemoMainWindowController ()

@property (strong, nonatomic) GDDemoGrid *grid;

@end



@implementation GDDemoMainWindowController


@synthesize grid = _grid;


#pragma mark - init

- (id) initWithGrid: (GDDemoGrid *) grid {
    GDDemoMainWindow *thisWindow = [[GDDemoMainWindow alloc] initWithGrid: grid];
    [thisWindow setWindowController: self];
    self = [super initWithWindow: thisWindow];
    if (self != nil) {
        _grid = grid;
        [self listenToNotifications];
    }
    return self;
}


- (void) reinitWindow: (NSNotification *) note {
    // destroy previous window
    NSInteger windowLevel = self.window.level;
    self.window = nil; // release last window
    
    // make new window
    GDDemoMainWindow *thisWindow = [[GDDemoMainWindow alloc] initWithGrid: _grid];
    [thisWindow setWindowController: self];
    self.window = thisWindow;
    
    [self showWindow: nil AtWindowLevel: windowLevel];
}



#pragma mark - notifications

- (void) listenToNotifications {
    // register for window events
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver: self
                      selector: @selector(reinitWindow:)
                          name: GDDemoGridValueUpdated
                        object: nil];
}


- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}


#pragma mark - displaying/hiding windows

- (void) showWindow: (id) sender {
    [super showWindow: sender];
    [self.window orderFront: sender];
    [NSApp activateIgnoringOtherApps: YES];
}


- (void) showWindow: (id) sender
      AtWindowLevel: (NSInteger) prevWindowLevel {
    [self.window setLevel: prevWindowLevel];
    [self.window display];
    [self.window orderFront: sender];
    [NSApp activateIgnoringOtherApps: YES];
}


- (void) showWindow: (id) sender
  BehindWindowLevel: (NSInteger) topWindowLevel {
    [self.window display];
    [self.window orderWindow: NSWindowBelow relativeTo: topWindowLevel];
    [NSApp activateIgnoringOtherApps: YES];
}


- (void) hideWindow {
    [self.window orderOut: nil];
}


- (void) preventHideWindow {
    [self.window setCanHide: NO];
}


- (void) enableHideWindow {
    [self.window setCanHide: YES];
}


@end





// ----------------------------------
#pragma mark - GDDemoMainWindow
// ----------------------------------

@implementation GDDemoMainWindow


- (id) initWithGrid: (GDDemoGrid *)grid {
    NSRect contentFrame = [grid getMainWindowFrame];
    
    self = [super initWithContentRect: contentFrame
                            styleMask: NSBorderlessWindowMask
                              backing: NSBackingStoreBuffered
                                defer: NO];
    if (self != nil) {
        // window setup
        self.styleMask = NSBorderlessWindowMask;
        self.hasShadow = YES;
        self.opaque = NO;
        self.backgroundColor = [NSColor clearColor];
        self.level = NSFloatingWindowLevel;
        
        [self setContentView: [[GDDemoMainWindowMainView alloc] initWithGrid: grid]];
    }
    
    return self;
}

- (BOOL) canBecomeKeyWindow {
    return NO;
}


- (BOOL) canBecomeMainWindow {
    return NO;
}


@end




// ----------------------------------
#pragma mark - GDMainWindowMainView
// ----------------------------------

@interface GDDemoMainWindowMainView() {
    GDDemoMainWindowAppInfoViewController *_appInfoViewController;
    GDDemoMainWindowCellCollectionView *_cellCollectionView;
}
@end



@implementation GDDemoMainWindowMainView

- (id) initWithGrid: (GDDemoGrid *) grid {
    self = [super initWithFrame: [grid getMainWindowFrame]];
    
    if (self != nil) {
        // setup self
        self.wantsLayer = YES;
        self.layer.frame = self.frame;
        self.layer.cornerRadius = 15.0;
        self.layer.masksToBounds = YES;
        
        // setup border
        self.layer.borderWidth = 1.0f;
        self.layer.borderColor = [[GDAssets getWindowBorder] CGColor];
        
        // setup vibrancy
        self.material = [GDAssets getWindowMaterial];
        self.blendingMode = NSVisualEffectBlendingModeBehindWindow;
        self.state = NSVisualEffectStateActive;
        
        // setup app info view
        _appInfoViewController = [[GDDemoMainWindowAppInfoViewController alloc] initWithGrid: grid];
        [self addSubview: _appInfoViewController.view];
        
        // setup cell views
        _cellCollectionView = [[GDDemoMainWindowCellCollectionView alloc] initWithGrid: grid];
        [self addSubview: _cellCollectionView];

        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(onAppearanceModeChanged:)
                                                     name: GDAppearanceModeChanged
                                                   object: nil];
    }
    
    return self;
}

- (void) onAppearanceModeChanged: (NSNotification *) note {
    self.material = [GDAssets getWindowMaterial];
    self.layer.borderColor = [[GDAssets getWindowBorder] CGColor];
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

@end





// ----------------------------------
#pragma mark - GDMainWindowAppInfoView
// ----------------------------------

@implementation GDDemoMainWindowAppInfoViewController


- (id) initWithGrid: (GDDemoGrid *) grid {
    self = [super initWithNibName: nil bundle: nil];
    
    if (self != nil) {
        GDDemoMainWindowAppInfoView *appInfoView = [[GDDemoMainWindowAppInfoView alloc] initWithGrid: grid];
        self.view = appInfoView;
    }
    return self;
}


@end



@interface GDDemoMainWindowAppInfoView() {
    NSImageView *_appIconView;
    NSTextField *_appNameView;
}
@end



@implementation GDDemoMainWindowAppInfoView


- (id) initWithGrid: (GDDemoGrid *) grid {
    self = [super initWithFrame: [grid getAppInfoFrame]];
    
    if (self != nil) {
        _appIconView = [[NSImageView alloc] initWithFrame: [grid getAppIconFrame]];
        _appIconView.imageScaling = NSImageScaleAxesIndependently;
        _appIconView.image = [NSApp applicationIconImage];
        _appIconView.tag = 0;
        [self addSubview: _appIconView];
        
        _appNameView = [[NSTextField alloc] initWithFrame: [grid getAppNameFrame]];
        _appNameView.bezeled = NO;
        _appNameView.drawsBackground = NO;
        _appNameView.editable = NO;
        _appNameView.selectable = NO;
        _appNameView.textColor = [GDAssets getTextColor];
        _appNameView.stringValue = @"Demo Application";
        _appNameView.tag = 1;
        [_appNameView sizeToFit];
        [self addSubview: _appNameView];

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
    _appNameView.textColor = [GDAssets getTextColor];
}


@end





// ----------------------------------
#pragma mark - GDDemoMainWindowCellCollectionView
// ----------------------------------

@implementation GDDemoMainWindowCellCollectionView


#pragma mark - INITIALIZATION

- (id) initWithGrid: (GDDemoGrid *) grid {
    self = [super initWithFrame: [grid getCellCollectionRectFrame]];
    
    if (self != nil) {
        // setup cells views
        for (NSInteger i = 0; i < (NSUInteger)grid.numCell.width; i++) {
            for (NSInteger j = 0; j < (NSUInteger)grid.numCell.height; j++) {
                NSRect cellFrame = [grid getCellViewFrameForCellX:i Y:j];
                NSView *cellFrameView = [[GDDemoCellView alloc] initWithFrame: cellFrame];
                [self addSubview: cellFrameView];
            }
        }
    }
    
    return self;
}


@end





// ----------------------------------
#pragma mark - GDDemoCellView
// ----------------------------------


@implementation GDDemoCellView

- (id) initWithFrame: (NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
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

@end




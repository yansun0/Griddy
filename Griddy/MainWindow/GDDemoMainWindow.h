//
//  GDDemoMainWindow.h
//  Griddy
//
//  Created by Yan Sun on 2014-09-14.
//  Copyright (c) 2014 Sunnay. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class GDGrid;



// ----------------------------
#pragma mark - GDDemoController
// ----------------------------

@interface GDDemoController : NSObject

- (void) launchWindows;
- (void) launchWindowsBehindWindowLevel: (NSInteger) windowLevel;
- (void) hideWindows;
- (void) enableAllWindowHiding;
- (void) preventAllWindowHiding;

@end



// --------------------------------------
#pragma mark - GDDemoMainWindowController
// --------------------------------------

@interface GDDemoMainWindowController : NSWindowController

- (id) initWithGrid: (GDGrid *) grid;
- (void) showWindow: (id) sender;
- (void) showWindow: (id) sender
      AtWindowLevel: (NSInteger) prevWindowLevel;
- (void) showWindow: (id) sender
  BehindWindowLevel: (NSInteger) topWindowLevel;
- (void) hideWindow;
- (void) preventHideWindow;
- (void) enableHideWindow;

@end



// --------------------------------------
#pragma mark - GDDemoMainWindow
// --------------------------------------

@interface GDDemoMainWindow : NSWindow

- (id) initWithGrid: (GDGrid *)grid;

@end



// ----------------------------------
#pragma mark - GDDemoMainWindowMainView
// ----------------------------------

@interface GDDemoMainWindowMainView : NSView

- (id) initWithGDGrid: (GDGrid *)grid;

@end



// ----------------------------------
#pragma mark - GDDemoMainWindowAppInfoView
// ----------------------------------
@interface GDDemoMainWindowAppInfoViewController : NSViewController

- (id) initWithGrid: (GDGrid *)grid;

@end


@interface GDDemoMainWindowAppInfoView : NSView

- (id) initWithGrid: (GDGrid *)grid;

@end



// ----------------------------------
#pragma mark - GDDemoMainWindowCellCollectionView
// ----------------------------------

@interface GDDemoMainWindowCellCollectionView : NSView

- (id) initWithGrid: (GDGrid *)grid;

@end



// ----------------------------------
#pragma mark - GDDemoCellView
// ----------------------------------

@interface GDDemoCellView : NSView

- (id)initWithFrame: (NSRect)frame;

@end

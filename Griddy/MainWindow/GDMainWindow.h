//
//  GDMainWindowViewController.h
//  Griddy
//
//  Created by Yan Sun on 2014-07-03.
//  Copyright (c) 2014 Sunnay. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GDMainWindowBase.h"

@class GDGrid;
@class GDScreen;



// -----------------------------------
#pragma mark - GDMainWindowController
// -----------------------------------

@interface GDMainWindowController : GDMainWindowBaseController

@property ( strong, nonatomic ) GDGrid *grid;
@property ( nonatomic ) NSPoint startCell;
@property ( nonatomic ) NSPoint curCell;
@property ( nonatomic ) BOOL isInCell;

- ( id ) initWithGrid: ( GDGrid * ) grid;

- ( void ) showWindow: ( id ) sender;
- ( BOOL ) isWindowFocused;
- ( BOOL ) hasSameGDScreen: ( GDScreen * ) screen;

- ( void ) windowFocused: ( NSNotification * ) note;
- ( void ) windowUnfocused: ( NSNotification * ) note;

- ( void ) setStartCellPosition: ( NSPoint ) pos;
- ( void ) setCurCellPosition: ( NSPoint ) pos;
- ( void ) clearCurCellPosition;
- ( void ) setEndCellPosition: ( NSPoint ) pos;
- ( void ) setHoverCellPosition: ( NSPoint ) pos
                  WithMouseDown: ( BOOL ) isDown;

@end



// -------------------------
#pragma mark - GDMainWindow
// -------------------------

@interface GDMainWindow : GDMainWindowBase

- (id) initWithGrid: ( GDGrid * )grid;

@end

//
//  GDMainWindowView.h
//  Griddy
//
//  Created by Yan Sun on 2014-07-13.
//  Copyright (c) 2014 Sunnay. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GDMainWindowBaseView.h"

@class GDGrid;



// ----------------------------------
#pragma mark - GDMainWindowView
// ----------------------------------

@interface GDMainWindowView : GDMainWindowBaseView

- ( id ) initWithGrid: ( GDGrid * ) grid;

@end



// ----------------------------------
#pragma mark - GDMainWindowAppInfoView
// ----------------------------------
@interface GDMainWindowAppInfoViewController : NSViewController

- ( id ) initWithGrid: ( GDGrid * ) grid;

@end


@interface GDMainWindowAppInfoView : GDMainWindowBaseAppInfoView

@property ( strong, nonatomic ) NSRunningApplication *curApp;

- ( void ) newApp: ( NSRunningApplication * ) newApp;

@end



// ----------------------------------
#pragma mark - GDMainWindowCellCollectionView
// ----------------------------------

@interface GDMainWindowCellCollectionView : NSView

@property ( strong, nonatomic ) NSTrackingArea *trackingArea;
@property ( nonatomic ) BOOL isMouseDown;

- ( id ) initWithGrid: ( GDGrid * ) grid;

@end



// ----------------------------------
#pragma mark - GDCellView
// ----------------------------------

@interface GDCellView : GDCellViewBase

@property NSPoint viewPosition;

- ( id ) initWithFrame: ( NSRect ) frame
          andPositionX: ( NSInteger ) x
          andPositionY: ( NSInteger ) y;

@end

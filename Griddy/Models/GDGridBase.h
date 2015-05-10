//
//  GDGridBase.h
//  Griddy
//
//  Created by Yan Sun on 08 03 15.
//  Copyright (c) 2015 Sunnay. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GDScreen;


// constants
static CGFloat const GRID_INNER_MARGIN = 5.0;
static CGFloat const GRID_OUTTER_MARGIN = 15.0;
static CGFloat const GRID_APP_VIEW_HEIGHT = 48.0;
static CGFloat const GRID_CELL_VIEW_MARGIN_TOP = 63.0; // GRID_OUTTER_MARGIN + GRID_APP_VIEW_HEIGHT


@interface GDGridBase : NSObject

@property ( nonatomic ) GDScreen *screen;
@property ( nonatomic ) NSRect winFrame;
@property ( nonatomic ) NSSize numCell;
@property ( nonatomic ) NSSize cellSize;
@property ( nonatomic ) NSUInteger winType;
@property ( nonatomic ) NSSize winAbsSize;
@property ( nonatomic ) NSSize winRelSize;

- ( id ) initWithGDScreen: (GDScreen *)screen;
- ( void ) setupDisplay;

- ( NSRect ) getAppInfoFrame;
- ( NSRect ) getAppIconFrame;
- ( NSRect ) getAppNameFrame;
- ( NSRect ) getCellCollectionRectFrame;
- ( NSRect ) getCellViewFrameForCellX: ( NSInteger ) x
                                    Y: ( NSInteger ) y;

@end

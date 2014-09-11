//
//  GDGrid.h
//  Griddy
//
//  Created by Yan Sun on 2014-07-03.
//  Copyright (c) 2014 Sunnay. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GDScreen;

@interface GDGrid : NSObject

@property (nonatomic) GDScreen *thisGDScreen;
@property (nonatomic) NSSize numCell;

- (id) initWithGDScreen: (GDScreen *)screen;
- (void) reinitWithGDScreen: (GDScreen *)newScreen;
- (void) setupGridParams;

- (NSRect) getMainWindowFrame;
- (NSRect) getAppInfoFrame;
- (NSRect) getAppIconFrame;
- (NSRect) getAppNameFrame;
- (NSRect) getCellCollectionRectFrame;
- (NSRect) getCellViewFrameForCellX: (NSInteger)x
                                  Y: (NSInteger)y;
- (NSString *) getNewWindowBoundsStringFromCell1: (NSPoint)cell1
                                         ToCell2: (NSPoint)cell2;
- (NSRect) getOverlayWindowFrameFromCell1: (NSPoint)cell1;
- (NSRect) getOverlayWindowFrameFromCell1: (NSPoint)cell1
                                  ToCell2: (NSPoint)cell2;
@end

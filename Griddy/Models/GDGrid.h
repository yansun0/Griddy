//
//  GDGrid.h
//  Griddy
//
//  Created by Yan Sun on 2014-07-03.
//  Copyright (c) 2014 Sunnay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDGridBase.h"
@class GDScreen;


@interface GDGrid : GDGridBase

- ( NSRect ) getAppWindowBoundsStringFromCell1: ( NSPoint ) cell1
                                       ToCell2: ( NSPoint ) cell2;
- ( NSRect ) getAppWindowFrameFromCell1: ( NSPoint ) cell1
                                ToCell2: ( NSPoint ) cell2;
- ( NSRect ) getOverlayWindowFrameFromCell1: ( NSPoint ) cell1;
- ( NSRect ) getOverlayWindowFrameFromCell1: ( NSPoint ) cell1
                                    ToCell2: ( NSPoint ) cell2;
@end

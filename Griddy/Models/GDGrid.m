//
//  GDGrid.m
//  Griddy
//
//  Created by Yan Sun on 2014-07-03.
//  Copyright (c) 2014 Sunnay. All rights reserved.
//

#import "GDGridBase.h"
#import "GDScreen.h"
#import "GDGrid.h"



@implementation GDGrid



#pragma mark - init

- ( id ) initWithGDScreen: ( GDScreen * ) screen {
    self = [ super initWithGDScreen: screen ];
    return self;
}



#pragma mark - calculations

- ( NSRect ) getRectFromPoint1: ( NSPoint ) p1
                        Point2: ( NSPoint ) p2 {
    NSRect newPosRect = NSMakeRect( 0, 0, 0, 0 );
    newPosRect.origin.x = ( p1.x < p2.x ? ( p1.x ) : ( p2.x ) ); // min
    newPosRect.origin.y = ( p1.y < p2.y ? ( p1.y ) : ( p2.y ) ); // min
    newPosRect.size.width = ABS( p1.x - p2.x ) + 1;
    newPosRect.size.height = ABS( p1.y - p2.y ) + 1;
    return newPosRect;
}


- ( NSRect ) getAppWindowBoundsStringFromCell1: ( NSPoint ) cell1
                                       ToCell2: ( NSPoint ) cell2 {
    NSRect newPosRect = [self getRectFromPoint1: cell1
                                         Point2: cell2];
    return [ self.screen getScreenBoundsForGridRect: newPosRect ];
}

- ( NSRect ) getAppWindowFrameFromCell1: ( NSPoint ) cell1
                                ToCell2: ( NSPoint ) cell2 {
    NSRect newPosRect = [ self getRectFromPoint1: cell1
                                          Point2: cell2 ];
    return [ self.screen getCGFrameForGridRect: newPosRect ];
}

// hovering
- ( NSRect ) getOverlayWindowFrameFromCell1: ( NSPoint ) cell1 {
    NSRect newPosRect = [ self getRectFromPoint1: cell1
                                          Point2: cell1 ];
    return [ self.screen getScreenFrameForGridRect: newPosRect ];
}

// dragging
- ( NSRect ) getOverlayWindowFrameFromCell1: ( NSPoint ) cell1
                                    ToCell2: ( NSPoint ) cell2 {
    NSRect newPosRect = [ self getRectFromPoint1: cell1
                                          Point2: cell2 ];
    return [ self.screen getScreenFrameForGridRect: newPosRect ];
}


@end

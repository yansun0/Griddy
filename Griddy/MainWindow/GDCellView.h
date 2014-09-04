//
//  GDCellView.h
//  Griddy
//
//  Created by Yan Sun on 2014-07-15.
//  Copyright (c) 2014 Sunnay. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface GDCellView : NSView

@property NSPoint viewPosition;
- (id)initWithFrame: (NSRect)frame
       andPositionX: (NSInteger)x
       andPositionY: (NSInteger)y;
@end

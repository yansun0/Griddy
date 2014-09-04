//
//  GDMainWindow.h
//  Griddy
//
//  Created by Yan Sun on 2014-07-07.
//  Copyright (c) 2014 Sunnay. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class GDGrid;

@interface GDMainWindow : NSWindow

- (id) initWithRect: (NSRect)contentRect
          andGDGrid: (GDGrid *)grid;

@end

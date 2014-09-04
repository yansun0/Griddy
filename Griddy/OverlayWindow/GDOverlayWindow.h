//
//  GDOverlayWindow.h
//  Griddy
//
//  Created by Yan Sun on 2014-08-02.
//  Copyright (c) 2014 Sunnay. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface GDOverlayWindow : NSWindow

- (id) initWithRect: (NSRect) contentRect;
- (void) showWindow: (id) sender
         withFrame: (NSRect) frame;
- (void) preventHideWindow;
- (void) enableHideWindow;

@end

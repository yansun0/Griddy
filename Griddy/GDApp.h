//
//  GDApp.h
//  Griddy
//
//  Created by Yan Sun on 4 May 15.
//  Copyright (c) 2015 Sunnay. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface GDApp : NSObject

+ ( id ) get;

- ( void ) updateScreensAndControllers;
- ( void ) showWindows;
- ( void ) hideWindows;
- ( void ) toggleWindowState;
- ( void ) canHide: ( BOOL ) canWindowHide;
- ( void ) hideAllUnfocusedWindowsIncluding: ( NSWindow * ) curWindow;
- ( void ) hideAllOtherWindowsExcluding: ( NSWindow * ) curWindow;

@end


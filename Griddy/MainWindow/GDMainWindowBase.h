//
//  GDMainWindowBase.h
//  Griddy
//
//  Created by Yan Sun on 10 May 15.
//  Copyright (c) 2015 Sunnay. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class GDGridBase;



@interface GDMainWindowBaseController : NSWindowController

- ( NSInteger ) destoryWindow;
- ( void ) showWindow: ( id ) sender
           AndMakeKey: ( BOOL ) makeKeyFlag;
- ( void ) showWindow: ( id ) sender
        AtWindowLevel: ( NSInteger ) prevWindowLevel;
- ( void ) showWindow: ( id ) sender
    BehindWindowLevel: ( NSInteger ) topWindowLevel;
- ( void ) hideWindow;
- ( void ) canHide: ( BOOL ) canWindowHide;

@end



@interface GDMainWindowBase : NSWindow

- ( id ) initWithGrid: ( GDGridBase * ) grid;

@end

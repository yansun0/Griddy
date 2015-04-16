//
//  GDAppDemo.h
//  Griddy
//
//  Created by Yan Sun on 4 May 15.
//  Copyright (c) 2015 Sunnay. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface GDAppDemo : NSObject

- ( void ) launchWindows;
- ( void ) hideWindows;
- ( void ) canHide: ( BOOL ) canWindowHide;

@end
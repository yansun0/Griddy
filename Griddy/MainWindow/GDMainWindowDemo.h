//
//  GDMainWindowDemo.h
//  Griddy
//
//  Created by Yan Sun on 10 May 15.
//  Copyright (c) 2015 Sunnay. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GDMainWindowBase.h"

@class GDGridDemo;



// --------------------------------------
#pragma mark - GDMainWindowDemoController
// --------------------------------------

@interface GDMainWindowDemoController : GDMainWindowBaseController


@property ( strong, nonatomic ) GDGridDemo *grid;


- ( id ) initWithGrid: ( GDGridDemo * ) grid;
- ( void ) showWindow: ( id ) sender;

@end



// --------------------------------------
#pragma mark - GDMainWindowDemo
// --------------------------------------

@interface GDMainWindowDemo : GDMainWindowBase

- ( id ) initWithGrid: ( GDGridDemo * ) grid;

@end

//
//  GDAppDemo.m
//  Griddy
//
//  Created by Yan Sun on 4 May 15.
//  Copyright (c) 2015 Sunnay. All rights reserved.
//

#import "GDAppDemo.h"

#import "GDMainWindowDemo.h"
#import "GDGridDemo.h"
#import "GDScreen.h"



@interface GDAppDemo()

@property ( strong, nonatomic ) NSMutableArray *grids;
@property ( strong, nonatomic ) NSMutableArray *controllers;

@end



@implementation GDAppDemo


- ( id ) init {
    self = [ super init ];
    if ( self ) {
        self.grids = [ self getGrids ];
        self.controllers = [ self getWinControllersFromGrids: self.grids ];
    }
    return self;
}


- ( NSMutableArray * ) getGrids {
    NSArray *screenArray = [ NSScreen screens ];
    NSMutableArray *grids = [ [ NSMutableArray alloc ] init ];

    for ( NSUInteger i = 0; i < screenArray.count; i++ )  {
        NSScreen *curScreen = [ screenArray objectAtIndex: i ];
        GDScreen *newGDScreen = [ [ GDScreen alloc ] initWithScreen: curScreen ];
        GDGridDemo *newGrid = [ [ GDGridDemo alloc ] initWithGDScreen: newGDScreen ];
        [ grids addObject: newGrid ];
    }
    return grids;
}


- ( NSMutableArray * ) getWinControllersFromGrids: ( NSMutableArray * ) grids {
    NSMutableArray * windowControllers = [ [ NSMutableArray alloc ] initWithCapacity: 1 ];
    
    for ( int i = 0; i < grids.count; i++ ) {
        GDGridDemo *curGrid = [ grids objectAtIndex: i ];
        GDMainWindowDemoController *curWC = [ [ GDMainWindowDemoController alloc ] initWithGrid: curGrid ];
        [ windowControllers addObject: curWC ];
    }
    return windowControllers;
}


#pragma mark - WINDOW FUNCTIONS

- ( void ) launchWindows {
    for (NSUInteger i = 0; i < self.controllers.count; i++) {
        [ [ self.controllers objectAtIndex: i ] showWindow: nil ];
    }
}


- ( void ) hideWindows {
    for ( NSUInteger i = 0; i < self.controllers.count; i++ ) {
        GDMainWindowDemoController *curWC = [ self.controllers objectAtIndex: i ];
        [ curWC hideWindow ];
    }
}


- ( void ) canHide: ( BOOL ) canWindowHide {
    for ( NSUInteger i = 0; i < self.controllers.count; i++ ) {
        [ [ self.controllers objectAtIndex: i ] canHide: canWindowHide ];
    }
}


@end


//
//  GDMainWindowDemo.m
//  Griddy
//
//  Created by Yan Sun on 10 May 15.
//  Copyright (c) 2015 Sunnay. All rights reserved.
//

#import "GDMainWindowDemo.h"
#import "GDMainWindowDemoView.h"
#import "GDGridDemo.h"
#import "GDScreen.h"


NSString * const GDGridDemoValueUpdated = @"GDGridDemoValueUpdated";



// --------------------------------------
#pragma mark - GDMainWindowDemoController
// --------------------------------------


@implementation GDMainWindowDemoController


#pragma mark - init

- ( id ) initWithGrid: (GDGridDemo *) grid {
    GDMainWindowDemo *win = [ [ GDMainWindowDemo alloc ] initWithGrid: grid ];
    [ win setWindowController: self ];
    self = [ super initWithWindow: win ];
    if ( self != nil ) {
        self.grid = grid;
        [ self listenToNotifications];
    }
    return self;
}


- ( void ) reinitWindow: ( NSNotification * ) note {
    NSInteger winLevel = [ super destoryWindow ];

    // make new window
    GDMainWindowDemo *newWindow = [ [ GDMainWindowDemo alloc ] initWithGrid: self.grid ];
    [ newWindow setWindowController: self ];
    self.window = newWindow;
    
    [ self showWindow: nil AtWindowLevel: winLevel ];
}



#pragma mark - notifications

- ( void ) listenToNotifications {
    NSNotificationCenter *defaultCenter = [ NSNotificationCenter defaultCenter ];
    [ defaultCenter addObserver: self
                       selector: @selector( reinitWindow: )
                           name: GDGridDemoValueUpdated
                         object: nil ];
}



#pragma mark - displaying/hiding windows

- ( void ) showWindow: ( id ) sender {
    [ super showWindow: sender AndMakeKey: NO ];
}


@end





// ----------------------------------
#pragma mark - GDMainWindowDemo
// ----------------------------------

@implementation GDMainWindowDemo


- ( id ) initWithGrid: ( GDGridDemo * ) grid {
    self = [ super initWithGrid: grid ];
    if ( self != nil ) {
        [ self setContentView: [ [ GDMainWindowDemoMainView alloc ] initWithGrid: grid ] ];
    }
    return self;
}


@end

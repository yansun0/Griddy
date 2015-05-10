//
//  GDGrid.m
//  Griddy
//
//  Created by Yan Sun on 2014-07-03.
//  Copyright (c) 2014 Sunnay. All rights reserved.
//

#import "GDGridDemo.h"
#import "GDScreen.h"


// user default keys
extern NSString * const GDMainWindowTypePostChanges; // GDMainWindowTypeKey
extern NSString * const GDMainWindowAbsoluteSizePostChanges; // GDMainWindowAbsoluteSizeKey
extern NSString * const GDMainWindowRelativeSizePostChanges; // GDMainWindowRelativeSizeKey
extern NSString * const GDMainWindowGridUniversalDimensionsPostChanges; // GDMainWindowGridUniversalDimensionsKey
extern NSString * const GDGridDemoValueUpdated;



@implementation GDGridDemo


#pragma mark - init

- ( id ) initWithGDScreen: ( GDScreen * ) screen {
    self = [ super initWithGDScreen: screen ];
    if ( self != nil ) {
        [ self listenForChangePosts ];
    }
    return self;
}



#pragma mark - notifications

- ( void ) listenForChangePosts {
    NSNotificationCenter *defaultCenter = [ NSNotificationCenter defaultCenter ];
    [ defaultCenter addObserver: self
                       selector: @selector( onNewMainWindowType: )
                           name: GDMainWindowTypePostChanges
                         object: nil ];

    [ defaultCenter addObserver: self
                       selector: @selector( onNewMainWindowSize: )
                           name: GDMainWindowAbsoluteSizePostChanges
                         object: nil ];
    
    [ defaultCenter addObserver: self
                       selector: @selector( onNewMainWindowSize: )
                           name: GDMainWindowRelativeSizePostChanges
                         object: nil ];
    
    [ defaultCenter addObserver: self
                       selector: @selector( onNewCellDimensions: )
                           name: GDMainWindowGridUniversalDimensionsPostChanges
                         object: nil ];
}


- ( void ) dealloc {
    [ [ NSNotificationCenter defaultCenter ] removeObserver: self ];
}


- ( void ) onNewMainWindowType: ( NSNotification * ) note {
    self.winType = [ [ [ note userInfo ] objectForKey: @"info" ] integerValue ];
    [ super setupDisplay ];
    [ self notifyUpdate ];
}


- ( void ) onNewMainWindowSize: ( NSNotification * ) note {
    NSData *data = [ note.userInfo objectForKey: @"info" ];
    NSValue *unarchived = [ NSKeyedUnarchiver unarchiveObjectWithData: data ];
    NSSize newSize = [ unarchived sizeValue ];
    if ( self.winType == 0 ) {
        self.winRelSize = [ self.screen getMainWindowSizeForScreenPercentageSize: newSize ];
    } else {
        self.winAbsSize = newSize;
    }
    [ super setupDisplay ];
    [ self notifyUpdate ];
}


- ( void ) onNewCellDimensions: ( NSNotification * ) note {
    NSData *data = [ note.userInfo objectForKey: @"info" ];
    NSValue *unarchived = [ NSKeyedUnarchiver unarchiveObjectWithData: data ];
    self.numCell = [ unarchived sizeValue ];
    [ super setupDisplay ];
    [ self notifyUpdate ];
}

- ( void ) notifyUpdate {
    NSNotificationCenter *nc = [ NSNotificationCenter defaultCenter ];
    [ nc postNotificationName: GDGridDemoValueUpdated
                       object: self
                     userInfo: nil ];
}



@end

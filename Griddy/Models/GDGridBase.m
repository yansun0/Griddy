//
//  GDGridBase.m
//  Griddy
//
//  Created by Yan Sun on 08 03 15.
//  Copyright (c) 2015 Sunnay. All rights reserved.
//

#import "GDGridBase.h"
#import "GDScreen.h"



// user default keys
extern NSString * const GDMainWindowTypeKey;
extern NSString * const GDMainWindowAbsoluteSizeKey;
extern NSString * const GDMainWindowRelativeSizeKey;
extern NSString * const GDMainWindowGridUniversalDimensionsKey;



@implementation GDGridBase



#pragma mark - INIT

- ( id ) initWithGDScreen: ( GDScreen * ) screen {
    self = [ super init ];
    if ( self != nil ) {
        // setup instance variables
        _screen = screen;
        _winType = [ [ [ NSUserDefaults standardUserDefaults ] objectForKey: GDMainWindowTypeKey ] integerValue ];
        
        NSData *relData = [ [ NSUserDefaults standardUserDefaults ] objectForKey: GDMainWindowRelativeSizeKey ];
        NSValue *unarchivedRelData = [ NSKeyedUnarchiver unarchiveObjectWithData: relData ];
        _winRelSize = [ self.screen getMainWindowSizeForScreenPercentageSize: [ unarchivedRelData sizeValue ] ];

        NSData *absData = [ [ NSUserDefaults standardUserDefaults ] objectForKey: GDMainWindowAbsoluteSizeKey ];
        _winAbsSize = [ [ NSKeyedUnarchiver unarchiveObjectWithData: absData ] sizeValue ];
        
        NSData *numCelldata = [ [ NSUserDefaults standardUserDefaults ] objectForKey: GDMainWindowGridUniversalDimensionsKey ];
        NSValue *unarchivedNumCelldata = [ NSKeyedUnarchiver unarchiveObjectWithData: numCelldata ];
        _numCell = [ unarchivedNumCelldata sizeValue ];
        
        [ self setupDisplay ];
    }
    return self;
}



#pragma mark - SETUP DISPLAY LOGIC

- ( void) setupDisplay {
    // calculate window frame
    NSSize winSize = ( self.winType == 0 ) ? self.winRelSize : self.winAbsSize;
    self.winFrame = NSMakeRect(
        ( self.screen.screenInfo.size.width - winSize.width ) * 0.5 + self.screen.screenInfo.origin.x,
        ( self.screen.screenInfo.size.height - winSize.height ) * 0.5 + self.screen.screenInfo.origin.y,
        winSize.width, winSize.height
    );

    // update screen with cell count
    [ self.screen setNumWidth: self.numCell.width NumHeight: self.numCell.height ];

    
    // calculate cell size
    self.cellSize = NSMakeSize(
        ( self.winFrame.size.width - 2 * GRID_OUTTER_MARGIN - ( self.numCell.width - 1 ) * GRID_INNER_MARGIN ) / self.numCell.width,
        ( self.winFrame.size.height - GRID_CELL_VIEW_MARGIN_TOP - 2 * GRID_OUTTER_MARGIN - ( self.numCell.height - 1 ) * GRID_INNER_MARGIN ) / self.numCell.height
    );
}



#pragma mark - SUBVIEW POSITION LOGIC

- ( NSRect ) getAppInfoFrame { // relative to winFrame
    return NSMakeRect( GRID_OUTTER_MARGIN,
        self.winFrame.size.height - GRID_OUTTER_MARGIN - GRID_APP_VIEW_HEIGHT,
        self.winFrame.size.width - 2 * GRID_OUTTER_MARGIN,
        GRID_APP_VIEW_HEIGHT );
}


- ( NSRect ) getAppIconFrame { // relative to appInfoFrame
    return NSMakeRect( 0, 0, GRID_APP_VIEW_HEIGHT, GRID_APP_VIEW_HEIGHT );
}


- ( NSRect ) getAppNameFrame { // relative to appInfoFrame
    CGFloat iconViewWidth = GRID_APP_VIEW_HEIGHT + GRID_INNER_MARGIN;
    return NSMakeRect( iconViewWidth, 0,
        self.winFrame.size.width - 2 * GRID_OUTTER_MARGIN - iconViewWidth,
        GRID_APP_VIEW_HEIGHT );
}


- ( NSRect ) getCellCollectionRectFrame { // relative to winFrame
    return NSMakeRect( GRID_OUTTER_MARGIN, GRID_OUTTER_MARGIN,
        self.winFrame.size.width - 2*GRID_OUTTER_MARGIN,
        self.winFrame.size.height - 2*GRID_OUTTER_MARGIN - GRID_CELL_VIEW_MARGIN_TOP );
}


- ( NSRect ) getCellViewFrameForCellX: ( NSInteger ) x // relative to cell collection
                                    Y: ( NSInteger ) y {
    return NSMakeRect(
        x * ( GRID_INNER_MARGIN + self.cellSize.width ),
        y * ( GRID_INNER_MARGIN + self.cellSize.height ),
        self.cellSize.width, self.cellSize.height );
}

@end

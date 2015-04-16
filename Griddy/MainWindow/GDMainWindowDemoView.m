//
//  GDMainWindowDemoView.m
//  Griddy
//
//  Created by Yan Sun on 10 May 15.
//  Copyright (c) 2015 Sunnay. All rights reserved.
//

#import "GDMainWindowDemoView.h"
#import "GDGridDemo.h"



// ----------------------------------
#pragma mark - GDMainWindowDemoMainView
// ----------------------------------

@interface GDMainWindowDemoMainView()

@property ( strong, nonatomic ) GDMainWindowDemoAppInfoViewController *appInfo;
@property ( strong, nonatomic ) GDMainWindowDemoCellCollectionView *cellCollection;

@end



@implementation GDMainWindowDemoMainView

- ( id ) initWithGrid: ( GDGridDemo * ) grid {
    self = [ super initWithGrid: grid ];
    
    if ( self != nil ) {
        self.appInfo = [ [ GDMainWindowDemoAppInfoViewController alloc ] initWithGrid: grid ];
        [ self addSubview: self.appInfo.view ];
        
        self.cellCollection = [[GDMainWindowDemoCellCollectionView alloc] initWithGrid: grid];
        [ self addSubview: self.cellCollection ];
    }
    
    return self;
}

@end





// ----------------------------------
#pragma mark - GDMainWindowDemoAppInfoViewController
// ----------------------------------

// controller

@implementation GDMainWindowDemoAppInfoViewController

- ( id ) initWithGrid: ( GDGridDemo * ) grid {
    self = [ super initWithNibName: nil bundle: nil ];
    
    if ( self != nil ) {
        GDMainWindowDemoAppInfoView *appInfoView = [ [ GDMainWindowDemoAppInfoView alloc ] initWithGrid: grid ];
        self.view = appInfoView;
    }
    return self;
}

@end


// view

@implementation GDMainWindowDemoAppInfoView

- ( id ) initWithGrid: ( GDGridDemo * ) grid {
    
    self = [ super initWithGrid: grid ];
    
    if ( self != nil ) {
        self.appIcon.image = [ NSApp applicationIconImage ];
        [ self addSubview: self.appIcon ];
        
        self.appName.stringValue = @"Demo Application";
        [ self.appName sizeToFit ];
        [ self addSubview: self.appName ];
    }
    
    return self;
}

@end





// ----------------------------------
#pragma mark - GDMainWindowDemoCellCollectionView
// ----------------------------------

@implementation GDMainWindowDemoCellCollectionView


#pragma mark - INITIALIZATION

- ( id ) initWithGrid: ( GDGridDemo * ) grid {
    self = [ super initWithFrame: [ grid getCellCollectionRectFrame ] ];
    
    if ( self != nil ) {
        for ( NSInteger i = 0; i < ( NSUInteger ) grid.numCell.width; i++ ) {
            for ( NSInteger j = 0; j < ( NSUInteger ) grid.numCell.height; j++ ) {
                NSRect cellFrame = [ grid getCellViewFrameForCellX: i Y: j ];
                NSView *cellFrameView = [ [ GDCellViewBase alloc ] initWithFrame: cellFrame ];
                [ self addSubview: cellFrameView ];
            }
        }
    }
    
    return self;
}


@end

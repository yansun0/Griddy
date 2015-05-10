//
//  GDMainWindowDemoView.h
//  Griddy
//
//  Created by Yan Sun on 10 May 15.
//  Copyright (c) 2015 Sunnay. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GDMainWindowBaseView.h"

@class GDGridDemo;


// ----------------------------------
#pragma mark - GDMainWindowDemoMainView
// ----------------------------------

@interface GDMainWindowDemoMainView : GDMainWindowBaseView

- ( id ) initWithGrid: ( GDGridDemo * ) grid;

@end



// ----------------------------------
#pragma mark - GDMainWindowDemoAppInfoViewController
// ----------------------------------
@interface GDMainWindowDemoAppInfoViewController : NSViewController

- ( id ) initWithGrid: ( GDGridDemo * ) grid;

@end


@interface GDMainWindowDemoAppInfoView : GDMainWindowBaseAppInfoView

- ( id ) initWithGrid: ( GDGridDemo * ) grid;

@end



// ----------------------------------
#pragma mark - GDMainWindowDemoCellCollectionView
// ----------------------------------

@interface GDMainWindowDemoCellCollectionView : NSView

- ( id ) initWithGrid: ( GDGridDemo * ) grid;

@end

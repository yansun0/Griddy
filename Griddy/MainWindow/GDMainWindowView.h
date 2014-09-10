//
//  GDMainWindowView.h
//  Griddy
//
//  Created by Yan Sun on 2014-07-13.
//  Copyright (c) 2014 Sunnay. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class GDGrid;



// ----------------------------------
#pragma mark - GDMainWindowMainView
// ----------------------------------

@interface GDMainWindowMainView : NSView

- (id) initWithFrame: (NSRect)contentFrame
          andGDGrid: (GDGrid *)grid;


@end



// ----------------------------------
#pragma mark - GDMainWindowAppInfoView
// ----------------------------------

@interface GDMainWindowAppInfoView : NSView

- (id) initWithFrame: (NSRect)contentFrame
           andGDGrid: (GDGrid *)grid;


@end

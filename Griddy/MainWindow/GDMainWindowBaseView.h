//
//  GDMainWindowBaseView.h
//  Griddy
//
//  Created by Yan Sun on 10 May 15.
//  Copyright (c) 2015 Sunnay. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class GDGridBase;


extern NSString * const GDAppearanceModeChanged;



// ---------------------------------
#pragma mark - GDMainWindowBaseView
// ---------------------------------

@interface GDMainWindowBaseView : NSVisualEffectView

- ( id ) initWithGrid: ( GDGridBase * ) grid;

@end




// ----------------------------------------
#pragma mark - GDMainWindowBaseAppInfoView
// ----------------------------------------

@interface GDMainWindowBaseAppInfoView : NSView

@property ( strong, nonatomic ) NSImageView *appIcon;
@property ( strong, nonatomic ) NSTextField *appName;

- ( id ) initWithGrid: ( GDGridBase * ) grid;

@end



// ---------------------------
#pragma mark - GDCellViewBase
// ---------------------------

@interface GDCellViewBase : NSView

- ( id ) initWithFrame: ( NSRect ) frame;

@end

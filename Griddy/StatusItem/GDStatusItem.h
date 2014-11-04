//
//  GDStatusItem.h
//  Griddy
//
//  Created by Yan Sun on 2014-08-19.
//  Copyright (c) 2014 Sunnay. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class GDStatusPopoverMenuViewController;
@class GDStatusPopoverPreferenceViewController;
@class GDStatusItemView;
@class AXStatusItemPopup;



// ----------------------------------
#pragma mark - GDStatusItemController
// ----------------------------------

@interface GDStatusItemController : NSObject

@property (nonatomic, strong) GDStatusItemView *statusItemView;
@property (nonatomic, strong) GDStatusPopoverMenuViewController *menuViewController;
@property (nonatomic, strong) GDStatusPopoverPreferenceViewController *preferenceViewController;
@property (nonatomic, strong) NSViewController *curViewController;
@property (nonatomic) NSUInteger curViewTag;
@property (nonatomic) BOOL isVisible;

+ ( id ) get;
- ( void ) showStatusItem;
- ( void ) hideStatusItem;
- ( void ) toggleStatusItemState;

@end



// ----------------------------------
#pragma mark - GDStatusItemView
// ----------------------------------

@interface GDStatusItemView : NSView

// properties
@property(nonatomic) BOOL active;

// init
- (id) initWithViewController: (NSViewController *)controller;

// show / hide popover
- (void) showPopover;
- (void) hidePopover;
- (void) transitionToNewView: (NSViewController *) newViewController;

// view size
- (void) setContentSize:(CGSize)size;

// events
- (void) removeStatusItem;

@end



// ----------------------------------
#pragma mark - GDStatusPopoverViewController
// ----------------------------------

@protocol GDStatusPopoverViewController
- (void) cleanUp;
@end
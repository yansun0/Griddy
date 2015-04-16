//
//  GDStatusItem.m
//  Griddy
//
//  Created by Yan Sun on 2014-08-19.
//  Copyright (c) 2014 Sunnay. All rights reserved.
//

#import "GDApp.h"
#import "GDStatusItem.h"
#import "GDStatusPopoverMenuViewController.h"
#import "GDStatusPopoverPreferenceViewController.h"
#import "GDMainWindow.h"



#define kMinViewWidth 22

NSString * const GDStatusItemMenuClosed = @"GDStatusItemMenuClosed";
extern NSString * const GDStatusPopoverSettingsButtonSelected;
extern NSString * const GDStatusPopoverBackButtonSelected;
extern NSString * const GDStatusItemVisibilityKey;
extern NSString * const GDStatusItemVisibilityChanged;

static BOOL isStatusItemVisible;





// ----------------------------------
#pragma mark - GDStatusItemController
// ----------------------------------

@implementation GDStatusItemController


@synthesize statusItemView = _statusItemView;
@synthesize curViewController = _curViewController;
@synthesize menuViewController = _menuViewController; // tag = 0
@synthesize preferenceViewController = _preferenceViewController; // tag = 1
@synthesize curViewTag = _curViewTag;


# pragma mark - INIT

+ ( void ) initialize {
    isStatusItemVisible = [ [ NSUserDefaults standardUserDefaults ] boolForKey: GDStatusItemVisibilityKey ];
}


+ ( id ) get {
    static GDStatusItemController *sharedController = nil;
    static dispatch_once_t onceToken;
    dispatch_once( &onceToken, ^{
        sharedController = [ [ self alloc ] init ];
    } );
    return sharedController;
}


- ( id ) init {
    self = [ super init ];
    if ( self != nil ) {
        [ self notificationSetup ];
        if ( isStatusItemVisible ) {
            [ self showStatusItem ];
        } else {
            [ self hideStatusItem ];
        }
    }
    return self;
}


# pragma mark - NOTIFICATIONS

- ( void ) notificationSetup {
    NSNotificationCenter *nc = [ NSNotificationCenter defaultCenter ];
    [ nc addObserver: self
            selector: @selector( onStatusItemPreferenceView: )
                name: GDStatusPopoverSettingsButtonSelected
              object: nil ];
    [ nc addObserver: self
            selector: @selector( onStatusItemMenuView: )
                name: GDStatusPopoverBackButtonSelected
              object: nil ];
    [ nc addObserver: self
            selector: @selector( onStatusItemMenuClosed: )
                name: GDStatusItemMenuClosed
              object: nil ];
    [ nc addObserver: self
            selector: @selector( onStatusItemVisibilityChanged: )
                name: GDStatusItemVisibilityChanged
              object: nil];
}


- ( void ) onStatusItemVisibilityChanged: ( NSNotification * ) note {
	BOOL shouldShow = [ [ [ note userInfo ] objectForKey: @"info" ] boolValue ];
    if ( shouldShow ) {
        [ self showStatusItem ];
    } else {
        [ self hideStatusItem ];
    }
}


- ( void ) onStatusItemMenuView: ( NSNotification * ) note {
    [ self changeViewController: 1 ];
}


- ( void ) onStatusItemPreferenceView: ( NSNotification * ) note {
    [ self changeViewController: 2 ];
}


- ( void ) onStatusItemMenuClosed: ( NSNotification * ) note {
    _curViewTag = 0;
    _preferenceViewController = nil;
    _menuViewController = nil;
}


- ( void ) dealloc {
    [ [ NSNotificationCenter defaultCenter ] removeObserver: self ];
}



# pragma mark - STATUS ITEM

- ( void ) toggleStatusItemState {
    if ( isStatusItemVisible == YES ) {
        [ self hideStatusItem ];
    } else {
        [ self showStatusItem ];
    }
}

- (void) showStatusItem {
    _curViewTag = 1;
    NSViewController *newViewController = [self getMenuViewController];
    _statusItemView = [[GDStatusItemView alloc] initWithViewController: newViewController];
    isStatusItemVisible = YES;
}

- (void) hideStatusItem {
    [_statusItemView removeStatusItem];
    _statusItemView = nil;
    _preferenceViewController = nil;
    _menuViewController = nil;
    isStatusItemVisible = NO;
}



# pragma mark - VIEWS

- (void) changeViewController: (NSUInteger) newViewTag {
    if (newViewTag == _curViewTag) {
        return;
    }
    
    NSViewController *newViewController;
    switch (newViewTag) {
        case 1:	{
            newViewController = [self getMenuViewController];
            break;
        }
            
        case 2:	{
            newViewController = [self getPreferenceViewController];
            break;
        }
    }
    [_statusItemView transitionToNewView: newViewController];
}


- (GDStatusPopoverMenuViewController *) getMenuViewController {
    if (_menuViewController == nil) {
        _menuViewController = [[GDStatusPopoverMenuViewController alloc] initWithNibName: @"GDStatusPopoverMenuView"
                                                                                  bundle: nil];
    }
    _curViewController = _menuViewController;
    _curViewTag = 1;
    return _menuViewController;
}


// always recreate b/c it might get dirty
- (GDStatusPopoverPreferenceViewController *) getPreferenceViewController {
    _preferenceViewController = nil;
    _preferenceViewController = [[GDStatusPopoverPreferenceViewController alloc] initWithNibName: @"GDStatusPopoverPreferenceView"
                                                                                          bundle: nil];
    _preferenceViewController.statusItemController = self;
    _curViewController = _preferenceViewController;
    _curViewTag = 2;
    return _preferenceViewController;
}


@end





// ----------------------------------
#pragma mark - GDStatusItemView
// ----------------------------------

@interface GDStatusItemView () {
    NSViewController<GDStatusPopoverViewController> *_popoverViewController;
    NSImageView *_imageView;
    NSImage *_image;
    NSImage *_alternateImage;
    NSStatusItem *_statusItem;
    NSPopover *_popover;
    id _popoverTransiencyMonitor;
}
@end



@implementation GDStatusItemView


@synthesize active = _active;


- (id) initWithViewController: (NSViewController<GDStatusPopoverViewController> *) controller {
    
    CGFloat height = [NSStatusBar systemStatusBar].thickness;
    
    self = [super initWithFrame: NSMakeRect(0, 0, kMinViewWidth, height)];
    if (self) {
        _popoverViewController = controller;
        
        _image = [NSImage imageNamed:@"statusitem-a"];
        [_image setTemplate: YES];
        _alternateImage = [NSImage imageNamed:@"statusitem-b"];
        [_alternateImage setTemplate: YES];
        
        _imageView = [[NSImageView alloc] initWithFrame:NSMakeRect(0, 0, kMinViewWidth, height)];
        [self addSubview:_imageView];
        
        _statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
        _statusItem.view = self;
        self.active = NO;
    }
    return self;
}


// TODO: fix this up
- (void) drawRect:(NSRect)dirtyRect {
    // set view background color
    if (_active) {
        [[NSColor selectedMenuItemColor] setFill];
    } else {
        [[NSColor clearColor] setFill];
    }
    NSRectFill(dirtyRect);
    
    // set image
    NSImage *image = (_active ? _alternateImage : _image);
    _imageView.image = image;
}


- (void) setContentSize: (CGSize)size {
    _popover.contentSize = size;
}



#pragma mark - MOUSE EVENTS

- (void) mouseDown: (NSEvent *)theEvent {
    self.active = YES;
}


- (void) mouseUp: (NSEvent *) theEvent {
    self.active = NO;
    if (_popover.isShown) {
        [self hidePopover];
    } else {
        [ [ GDApp get ] toggleWindowState ];
    }
}

- (void) rightMouseDown: (NSEvent *)theEvent {
    if (_popover.isShown) {
        [self hidePopover];
    } else {
        [self showPopover];
    }
}


- (void) setActive: (BOOL)active {
    _active = active;
    [self setNeedsDisplay: YES];
}



#pragma mark - MOUSE EVENTS

- (void) setImage:(NSImage *)image {
    _image = image;
    [self updateViewFrame];
}


- (void) setAlternateImage:(NSImage *)image {
    _alternateImage = image;
    if (!image && _image) {
        _alternateImage = _image;
    }
    [self updateViewFrame];
}


- (void) updateViewFrame {
    CGFloat width = MAX(MAX(kMinViewWidth, _alternateImage.size.width), _image.size.width);
    CGFloat height = [NSStatusBar systemStatusBar].thickness;
    
    NSRect frame = NSMakeRect(0, 0, width, height);
    self.frame = frame;
    _imageView.frame = frame;
    
    [self setNeedsDisplay:YES];
}


- (void) showPopover {
    self.active = YES;
    
    if (!_popover) {
        _popover = [[NSPopover alloc] init];
        _popover.contentViewController = _popoverViewController;
    } else if (!_popover.contentViewController) {
        _popover.contentViewController = _popoverViewController;
    }
    
    if (!_popover.isShown) {
        _popover.animates = YES;
        [_popover showRelativeToRect: self.frame
                              ofView: self
                       preferredEdge: NSMinYEdge];
        _popoverTransiencyMonitor = [NSEvent addGlobalMonitorForEventsMatchingMask: NSLeftMouseDownMask|NSRightMouseDownMask handler:^(NSEvent* event) {
            [self hidePopover];
        }];
        
        [ [ GDApp get ] hideWindows ];
    }
}


- (void) hidePopover {
    self.active = NO;
    
    if (_popover) {
        // cleanup
        NSViewController <GDStatusPopoverViewController> *vc = (NSViewController <GDStatusPopoverViewController> *) _popover.contentViewController;
        [vc cleanUp];
        
        // if popover still being displayed
        if (_popover.isShown) {
            _popover.contentViewController = nil;
            [_popover close];
            if (_popoverTransiencyMonitor) {
                [NSEvent removeMonitor: _popoverTransiencyMonitor];
                _popoverTransiencyMonitor = nil;
            }
            
            // post notification
            NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
            [nc postNotificationName: GDStatusItemMenuClosed
                              object: self];
        }
    }
}


- (void) transitionToNewView: (NSViewController *) newViewController {
    _popover.contentViewController = newViewController;
    _popover.contentViewController.view.needsDisplay = YES;
}


- (void) removeStatusItem {
    NSStatusBar *bar = [NSStatusBar systemStatusBar];
    [bar removeStatusItem: _statusItem];
    _statusItem = nil;
}


@end

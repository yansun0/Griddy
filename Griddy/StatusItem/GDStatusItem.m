//
//  GDStatusItem.m
//  Griddy
//
//  Created by Yan Sun on 2014-08-19.
//  Copyright (c) 2014 Sunnay. All rights reserved.
//

#import "GDStatusItem.h"
#import "GDStatusPopoverView.h"



NSString * const StatusItemMenuOpened = @"GDStatusItemMenuOpened";



#pragma mark - STATUS ITEM VIEW

#define kMinViewWidth 22

@interface GDStatusItemView () {
    NSViewController *_viewController;
    BOOL _active;
    NSImageView *_imageView;
    NSStatusItem *_statusItem;
    NSMenu *_dummyMenu;
    NSPopover *_popover;
    id _popoverTransiencyMonitor;
    SEL _actionL;
    id _targetL;
}
@end



@implementation GDStatusItemView


- (id) initWithViewController: (NSViewController *)controller {
    
    CGFloat height = [NSStatusBar systemStatusBar].thickness;
    
    self = [super initWithFrame:NSMakeRect(0, 0, kMinViewWidth, height)];
    if (self) {
        _viewController = controller;
        
        self.image = [NSImage imageNamed:@"statusitem-a"];
        self.alternateImage = [NSImage imageNamed:@"statusitem-b"];
        
        _imageView = [[NSImageView alloc] initWithFrame:NSMakeRect(0, 0, kMinViewWidth, height)];
        [self addSubview:_imageView];
        
        self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
        self.statusItem.view = self;
        _dummyMenu = [[NSMenu alloc] init];
        
        _active = NO;
        _animated = YES;
    }
    return self;
}


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


- (void) setContentSize:(CGSize)size {
    _popover.contentSize = size;
}


- (void) mouseDown: (NSEvent *)theEvent {
    self.active = YES;
    if (!_popover || !_popover.isShown) {
        [NSApp sendAction: _actionL to: _targetL from: self];
    }
}


- (void) rightMouseDown: (NSEvent *)theEvent {
    self.active = YES;
    if (_popover.isShown) {
        [self hidePopover];
    } else {
        [self showPopover];
    }
}


- (void) mouseUp: (NSEvent *) theEvent {
    if (!_popover || !_popover.isShown) {
        self.active = NO;
    }
}


- (void) setAction: (SEL) action
           toTarget: (id) target {
    _actionL = action;
    _targetL = target;
}


- (void) setActive:(BOOL)active {
    _active = active;
    [self setNeedsDisplay: YES];
}


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
    CGFloat width = MAX(MAX(kMinViewWidth, self.alternateImage.size.width), self.image.size.width);
    CGFloat height = [NSStatusBar systemStatusBar].thickness;
    
    NSRect frame = NSMakeRect(0, 0, width, height);
    self.frame = frame;
    _imageView.frame = frame;
    
    [self setNeedsDisplay:YES];
}


- (void) showPopover {
    [self showPopoverAnimated: _animated];
}


- (void) showPopoverAnimated: (BOOL)animated {
    self.active = YES;
    
    if (!_popover) {
        _popover = [[NSPopover alloc] init];
        _popover.contentViewController = _viewController;
    }
    
    if (!_popover.isShown) {
        _popover.animates = animated;
        [self.statusItem popUpStatusItemMenu:_dummyMenu];
        [_popover showRelativeToRect:self.frame ofView:self preferredEdge:NSMinYEdge];
        _popoverTransiencyMonitor = [NSEvent addGlobalMonitorForEventsMatchingMask:NSLeftMouseDownMask|NSRightMouseDownMask handler:^(NSEvent* event) {
            [self hidePopover];
        }];
        
        // post notification
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc postNotificationName: StatusItemMenuOpened
                          object: self];
    }
}


- (void) hidePopover {
    self.active = NO;
    if (_popover && _popover.isShown) {
        [_popover close];
		if (_popoverTransiencyMonitor) {
            [NSEvent removeMonitor:_popoverTransiencyMonitor];
            _popoverTransiencyMonitor = nil;
        }
    }
}


- (void) removeStatusItem {
    NSStatusBar *bar = [NSStatusBar systemStatusBar];
    [bar removeStatusItem: _statusItem];
    _statusItem = nil;
}


@end



#pragma mark - STATUS ITEM CONTROLLER

@implementation GDStatusItemController


@synthesize statusItemView = _statusItemView;
@synthesize statusPanelController = _statusPanelController;


- (id) initWithAction: (SEL) action
            andTarget: (id) target {
    self = [super init];
    if (self != nil) {
        _statusPanelController = [[GDStatusPopoverViewController alloc] initWithNibName:@"GDStatusPopover" bundle:nil];
        
        _statusItemView = [[GDStatusItemView alloc] initWithViewController: _statusPanelController];
        [_statusItemView setAction: action toTarget: target];
        
        _statusPanelController.statusItemView = _statusItemView;
    }
    return self;
}


- (BOOL) isStatusItemMenuOpen {
    return _statusItemView.active;
}


- (void) hideStatusItem {
    [_statusItemView removeStatusItem];
    _statusItemView = nil;
    _statusPanelController = nil;
}


@end


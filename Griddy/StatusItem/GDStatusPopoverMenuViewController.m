//
//  GDStatusPanel.m
//  Griddy
//
//  Created by Yan Sun on 2014-08-19.
//  Copyright (c) 2014 Sunnay. All rights reserved.
//

#import "GDStatusPopoverMenuViewController.h"
#import "GDStatusItem.h"
#import "GDAssets.h"



// event notification keys
NSString * const GDStatusPopoverSettingsButtonSelected = @"GDStatusPopoverSettingsButtonSelected";




@implementation GDStatusPopoverMenuViewController

- (id)initWithNibName: (NSString *) nibNameOrNil
               bundle: (NSBundle *) nibBundleOrNil {
    self = [super initWithNibName: nibNameOrNil bundle: nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

@end



@implementation GDStatusPopoverActivateButton

- (void) drawRect: (NSRect) dirtyRect {
    NSBezierPath* path = [GDAssets getPathForGridFourIcon];
    
    [[NSColor colorWithWhite: 0.2f alpha: 0.5f] setFill];
    
    NSAffineTransform *transformer = [[NSAffineTransform alloc] init];
    [transformer translateXBy: 14.0f yBy: 14.0f];
    [transformer scaleBy: 0.5625f];
    
    [path transformUsingAffineTransform: transformer];
    [path fill];
    
    [super drawRect: dirtyRect];
}

@end



@implementation GDStatusPopoverAboutButton

- (void) drawRect: (NSRect) dirtyRect {
    NSBezierPath* path = [GDAssets getPathForQuestionIcon];
    
    [[NSColor colorWithWhite: 0.2f alpha: 0.5f] setFill];
    
    NSAffineTransform *transformer = [[NSAffineTransform alloc] init];
    [transformer translateXBy: 14.0f yBy: 14.0f];
    [transformer scaleBy: 0.5625f];
    
    [path transformUsingAffineTransform: transformer];
    [path fill];
    
    [super drawRect: dirtyRect];
}

@end



@implementation GDStatusPopoverSettingsButton

- (void) drawRect: (NSRect) dirtyRect {
    NSBezierPath* path = [GDAssets getPathForGearsIcon];
    
    [[NSColor colorWithWhite: 0.2f alpha: 0.5f] setFill];
    
    NSAffineTransform *transformer = [[NSAffineTransform alloc] init];
    [transformer translateXBy: 14.0f yBy: 14.0f];
    [transformer scaleBy: 0.5625f];
    
    [path transformUsingAffineTransform: transformer];
    [path fill];
    
    [super drawRect: dirtyRect];
}


- (void) mouseUp: (NSEvent *) theEvent {
    NSLog(@"mouse up");
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName: GDStatusPopoverSettingsButtonSelected
                      object: self
                    userInfo: nil];
}

@end



@implementation GDStatusPopoverQuitButton

- (void) drawRect: (NSRect) dirtyRect {
    NSBezierPath* path = [GDAssets getPathForTimesIcon];
    
    [[NSColor colorWithWhite: 0.2f alpha: 0.5f] setFill];
    
    NSAffineTransform *transformer = [[NSAffineTransform alloc] init];
    [transformer translateXBy: 14.0f yBy: 14.0f];
    [transformer scaleBy: 0.5625f];
    
    [path transformUsingAffineTransform: transformer];
    [path fill];
    
    [super drawRect: dirtyRect];
}

- (void) mouseUp: (NSEvent *) theEvent {
    [[NSUserDefaults standardUserDefaults] synchronize];
    [NSApp performSelector: @selector(terminate:)
                withObject: nil
                afterDelay: 0.0];
}

@end



@implementation GDStatusPopoverDivider

- (void) drawRect: (NSRect) dirtyRect {
    [[NSColor blackColor] setFill];
    NSRectFill(dirtyRect);
    [super drawRect:dirtyRect];
}

@end



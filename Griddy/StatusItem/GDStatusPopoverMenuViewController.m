//
//  GDStatusPanel.m
//  Griddy
//
//  Created by Yan Sun on 2014-08-19.
//  Copyright (c) 2014 Sunnay. All rights reserved.
//

#import "GDStatusPopoverMenuViewController.h"
#import "GDAssets.h"



// event notification keys
NSString * const GDStatusPopoverSettingsButtonSelected = @"GDStatusPopoverSettingsButtonSelected";




@implementation GDStatusPopoverMenuViewController

- (id)initWithNibName: (NSString *) nibNameOrNil
               bundle: (NSBundle *) nibBundleOrNil {
    self = [super initWithNibName: nibNameOrNil bundle: nibBundleOrNil];
    if (self) {
        //
    }
    
    return self;
}

- (void) cleanUp {}

@end



@implementation GDStatusPopoverActivateButton


- (void) drawRect: (NSRect) dirtyRect {
    // text
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSFont fontWithName: @"HelveticaNeue-Light"
                                                size: 20],
                                NSFontAttributeName,
                                [GDAssets getTextColor],
                                NSForegroundColorAttributeName,
                                nil];
    NSAttributedString * currentText = [[NSAttributedString alloc] initWithString:@"Activate" attributes: attributes];
    [currentText drawInRect:NSMakeRect(48, 12, 128, 24)];
    
    // icon
    NSBezierPath* path = [GDAssets getPathForGridFourIcon];
    [[GDAssets getTextColor] setFill];
    NSAffineTransform *transformer = [[NSAffineTransform alloc] init];
    [transformer translateXBy: 12.0f yBy: 12.0f];
    [transformer scaleBy: 0.375f];
    [path transformUsingAffineTransform: transformer];
    [path fill];
    
    [super drawRect: dirtyRect];
}

- (BOOL) acceptsFirstResponder {
    return YES;
}

- (BOOL) acceptsFirstMouse: (NSEvent *) theEvent {
    return YES;
}

@end



@implementation GDStatusPopoverAboutButton


- (void) drawRect: (NSRect) dirtyRect {
    // text
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSFont fontWithName: @"HelveticaNeue-Light"
                                                size: 20],
                                NSFontAttributeName,
                                [GDAssets getTextColor],
                                NSForegroundColorAttributeName,
                                nil];
    NSAttributedString * currentText = [[NSAttributedString alloc] initWithString:@"About" attributes: attributes];
    [currentText drawInRect:NSMakeRect(48, 12, 128, 24)];
    
    // icon
    NSBezierPath* path = [GDAssets getPathForQuestionIcon];
    [[GDAssets getTextColor] setFill];
    NSAffineTransform *transformer = [[NSAffineTransform alloc] init];
    [transformer translateXBy: 12.0f yBy: 12.0f];
    [transformer scaleBy: 0.375f];
    [path transformUsingAffineTransform: transformer];
    [path fill];
    
    [super drawRect: dirtyRect];
}

- (BOOL) acceptsFirstResponder {
    return YES;
}

- (BOOL) acceptsFirstMouse: (NSEvent *) theEvent {
    return YES;
}

@end



@implementation GDStatusPopoverSettingsButton

- (void) drawRect: (NSRect) dirtyRect {
    // text
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSFont fontWithName: @"HelveticaNeue-Light"
                                                size: 20],
                                NSFontAttributeName,
                                [GDAssets getTextColor],
                                NSForegroundColorAttributeName,
                                nil];
    NSAttributedString * currentText = [[NSAttributedString alloc] initWithString:@"Settings" attributes: attributes];
    [currentText drawInRect:NSMakeRect(48, 12, 128, 24)];
    
    // icon
    NSBezierPath* path = [GDAssets getPathForGearsIcon];
    [[GDAssets getTextColor] setFill];
    NSAffineTransform *transformer = [[NSAffineTransform alloc] init];
    [transformer translateXBy: 12.0f yBy: 12.0f];
    [transformer scaleBy: 0.375f];
    [path transformUsingAffineTransform: transformer];
    [path fill];
    [super drawRect: dirtyRect];

}


- (void) mouseUp: (NSEvent *) theEvent {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName: GDStatusPopoverSettingsButtonSelected
                      object: self
                    userInfo: nil];
}

- (BOOL) acceptsFirstResponder {
    return YES;
}

- (BOOL) acceptsFirstMouse: (NSEvent *) theEvent {
    return YES;
}

@end



@implementation GDStatusPopoverQuitButton

- (void) drawRect: (NSRect) dirtyRect {
    // text
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSFont fontWithName: @"HelveticaNeue-Light"
                                                size: 20],
                                NSFontAttributeName,
                                [GDAssets getTextColor],
                                NSForegroundColorAttributeName,
                                nil];
    NSAttributedString * currentText = [[NSAttributedString alloc] initWithString:@"Quit" attributes: attributes];
    [currentText drawInRect:NSMakeRect(48, 12, 128, 24)];
    
    // icon
    NSBezierPath* path = [GDAssets getPathForTimesIcon];
    [[GDAssets getTextColor] setFill];
    NSAffineTransform *transformer = [[NSAffineTransform alloc] init];
    [transformer translateXBy: 12.0f yBy: 12.0f];
    [transformer scaleBy: 0.375f];
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

- (BOOL) acceptsFirstResponder {
    return YES;
}

- (BOOL) acceptsFirstMouse: (NSEvent *) theEvent {
    return YES;
}

@end



@implementation GDStatusPopoverDivider

- (void) drawRect: (NSRect) dirtyRect {
    [[GDAssets getDividerColor] setFill];
    NSRectFill(dirtyRect);
}

@end



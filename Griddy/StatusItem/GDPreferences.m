//
//  GDPreferences.m
//  Griddy
//
//  Created by Yan Sun on 2014-08-23.
//  Copyright (c) 2014 Sunnay. All rights reserved.
//

#import "GDPreferences.h"



// preference keys
NSString * const GDMainWindowTypeKey = @"GDMainWindowTypeKey";
NSString * const GDMainWindowAbsoluteSizeKey = @"GDMainWindowAbsoluteSizeKey";
NSString * const GDMainWindowRelativeSizeKey = @"GDMainWindowRelativeSizeKey";
NSString * const GDMainWindowBackgroundColorKey = @"GDMainWindowBackgroundColor";
NSString * const GDMainWindowBackgroundTransparencyKey = @"GDMainWindowBackgroundTransparencyKey";
NSString * const GDMainWindowGridColorKey = @"GDMainWindowGridColorKey";
NSString * const GDMainWindowGridTransparencyKey = @"GDMainWindowGridTransparencyKey";
NSString * const GDMainWindowGridSizeTypeKey = @"GDMainWindowGridSizeTypeKey";
NSString * const GDMainWindowRelativeGridUniversalSizeKey = @"GDMainWindowRelativeGridUniversalSizeKey";
NSString * const GDMainWindowAbsoluteGridUniversalSizeKey = @"GDMainWindowAbsoluteGridUniversalSizeKey";
NSString * const GDMainWindowRelativeGridSpecifiedSizeKey = @"GDMainWindowRelativeGridSpecifiedSizeKey";
NSString * const GDMainWindowAbsoluteGridSpecifiedSizeKey = @"GDMainWindowAbsoluteGridSpecifiedSizeKey";
NSString * const GDShortcutKey = @"GDShortcutKey";
NSString * const GDStatusItemVisibilityKey = @"GDStatusItemVisibilityKey";
NSString * const GDDockIconVisibilityKey = @"GDDockIconVisibilityKey";
NSString * const GDAutoLaunchOnLoginKey = @"GDAutoLaunchOnLoginKey";



// changes keys
NSString * const GDMainWindowTypeChanged = @"GDMainWindowTypeChanged";
NSString * const GDMainWindowAbsoluteSizeChanged = @"GDMainWindowAbsoluteSizeChanged";
NSString * const GDMainWindowRelativeSizeChanged = @"GDMainWindowRelativeSizeChanged";
NSString * const GDStatusItemVisibilityChanged = @"GDStatusItemVisibilityChanged";
NSString * const GDDockIconVisibilityChanged = @"GDDockIconVisibilityChanged";
NSString * const GDAutoLaunchOnLoginChanged = @"GDAutoLaunchOnLoginChanged";



@interface GDPreferenceController()
- (NSView *) viewForTag: (NSUInteger) tag;
- (NSRect) getFrameForNewView: (NSView *) view;
@end



@implementation GDPreferenceController



# pragma mark - BASE UI

- (id) init {
    self = [super initWithWindowNibName:@"Preferences"];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void) awakeFromNib {
    [[self window] setContentSize: [appearancesView frame].size];
    [[[self window] contentView] setAutoresizesSubviews: NO];
    [[[self window] contentView] addSubview: appearancesView];
    [[[self window] contentView] setWantsLayer: YES];
}

- (void) windowDidLoad {
    [super windowDidLoad];
    [self setPreferenceUI];
}

- (BOOL) isWindowFocused {
    return [[self window] isMainWindow] || [[self window] isKeyWindow];
}

- (void) preventHideWindow {
    [[self window] setCanHide: NO];
}

- (void) enableHideWindow {
    [[self window] setCanHide: YES];
}

- (IBAction) switchView: (id)sender {
    NSUInteger tag = [sender tag];
    NSView *view = [self viewForTag: tag];
    NSView *previousView = [self viewForTag: currentViewTag];
    NSRect newFrame = [self getFrameForNewView: view];
    
    // transition
    [NSAnimationContext beginGrouping];
    if ([[NSApp currentEvent] modifierFlags] & NSShiftKeyMask) {
        [[NSAnimationContext currentContext] setDuration: 1.0];
    }
    [[[[self window] contentView] animator] replaceSubview: previousView
                                                      with: view];
    [[[self window] animator] setFrame: newFrame
                               display: YES];
    [NSAnimationContext endGrouping];

    currentViewTag = tag;
}

- (NSRect) getFrameForNewView: (NSView *) view {
    NSWindow *prefWindow = [self window];
    NSRect newFrameRect = [prefWindow frameRectForContentRect: [view frame]];
    NSRect oldFrameRect = [prefWindow frame];
    NSSize newSize = newFrameRect.size;
    NSSize oldSize = oldFrameRect.size;
    
    NSRect frame = [prefWindow frame];
    frame.size = newSize;
    frame.origin.y -= (newSize.height - oldSize.height);
    
    return frame;
}

- (NSView *) viewForTag: (NSUInteger) tag {
    NSView *view = nil;
    switch (tag) {
        case 0:
            view = appearancesView;
            break;
        case 1:
            view = functionalityView;
            break;
        case 2:
            view = miscView;
            break;
        default:
            view = appearancesView;
    }
    return view;
}

- (BOOL) validateToolbarItem: (NSToolbarItem *)theItem {
    if ([theItem tag] == currentViewTag) {
        return NO;
    } else {
        return YES;
    }
}



# pragma mark - INTERFACE

- (void) setPreferenceUI {
    // appearence
    NSUInteger windowChoice = [[[NSUserDefaults standardUserDefaults] objectForKey: GDMainWindowTypeKey] integerValue];
    [mainWindowSizeChoiceMatrix selectCellWithTag: windowChoice];
    
    if (windowChoice == 1) {
        NSData *sizeData = [[NSUserDefaults standardUserDefaults] objectForKey: GDMainWindowAbsoluteSizeKey];
        NSSize windowSize = [[NSKeyedUnarchiver unarchiveObjectWithData: sizeData] sizeValue];
        NSUInteger windowWidth = ceilf(windowSize.width);
        NSUInteger windowHeight = ceilf(windowSize.height);
        // NSLog(@"abs w: %lu", (unsigned long)windowWidth);
        // NSLog(@"abs h: %lu", (unsigned long)windowHeight);
        [widthInputBox setStringValue: [NSString stringWithFormat:@"%lu", windowWidth]];
        [heightInputBox setStringValue: [NSString stringWithFormat:@"%lu", windowHeight]];
        [widthInputBoxSuffix setStringValue: @"px"];
        [heightInputBoxSuffix setStringValue: @"px"];
        
    } else {
        NSData *sizeData = [[NSUserDefaults standardUserDefaults] objectForKey: GDMainWindowRelativeSizeKey];
        NSSize windowSize = [[NSKeyedUnarchiver unarchiveObjectWithData: sizeData] sizeValue];
        // NSLog(@"relative w: %f", windowSize.height);
        // NSLog(@"relative h: %f", windowSize.width);
        [widthInputBox setStringValue: [NSString stringWithFormat:@"%.2f", windowSize.width * 100]];
        [heightInputBox setStringValue: [NSString stringWithFormat:@"%.2f", windowSize.height * 100]];
        [widthInputBoxSuffix setStringValue: @"%"];
        [heightInputBoxSuffix setStringValue: @"%"];
    }
    
    // misc
    // NSLog(@"dock icon visibility: %hhd", [[[NSUserDefaults standardUserDefaults] objectForKey: GDDockIconVisibilityKey] boolValue]);
    dockIconCheckBox.state = [[[NSUserDefaults standardUserDefaults] objectForKey: GDDockIconVisibilityKey] boolValue];
    // NSLog(@"status item visibility: %hhd", [[[NSUserDefaults standardUserDefaults] objectForKey: GDStatusItemVisibilityKey] boolValue]);
    statusItemCheckBox.state = [[[NSUserDefaults standardUserDefaults] objectForKey: GDStatusItemVisibilityKey] boolValue];
}

// appearence
- (IBAction) changeMainWindowSizeChoiceMatrix: (id)sender {
    NSUInteger selectedTag = [[sender selectedCell] tag];
    [GDPreferenceController setMainWindowType: selectedTag];
}

- (IBAction) changeWidthInputBox: (id)sender {
}

- (IBAction) changeHeightInputBox: (id)sender {
}


// misc
- (IBAction) changeStatusItemCheckBox: (id)sender {
    NSInteger state = [statusItemCheckBox state];
    [GDPreferenceController setStatusItemVisibility: state];
}

- (IBAction) changeDockIconCheckBox: (id)sender {
    NSInteger state = [dockIconCheckBox state];
    [GDPreferenceController setDockIconVisibility: state];
}




# pragma mark - USER DEFAULTS

+ (void) setUserDefaults {
    // archive necessary data
    NSSize mainWindowAbsSize = NSMakeSize(500, 400);
    NSData *mainWindowAbsSizeData = [NSKeyedArchiver archivedDataWithRootObject: [NSValue valueWithSize: mainWindowAbsSize]];
    NSSize mainWindowRelativeSize = NSMakeSize(0.20, 0.3);
    NSData *mainWindowRelativeSizeData = [NSKeyedArchiver archivedDataWithRootObject: [NSValue valueWithSize: mainWindowRelativeSize]];
    NSSize mainWindowAbsGridUniSize = NSMakeSize(7, 5);
    NSData *mainWindowAbsGridUniSizeData = [NSKeyedArchiver archivedDataWithRootObject: [NSValue valueWithSize: mainWindowAbsGridUniSize]];
    
	// create default dictionary
	NSMutableDictionary *defaultValues = [NSMutableDictionary dictionary];
	[defaultValues setObject: [NSNumber numberWithInteger: 1] // 0 = relative, 1 = abs
                      forKey: GDMainWindowTypeKey];
	[defaultValues setObject: mainWindowAbsSizeData
                      forKey: GDMainWindowAbsoluteSizeKey];
    [defaultValues setObject: mainWindowRelativeSizeData
                      forKey: GDMainWindowRelativeSizeKey];
    [defaultValues setObject: mainWindowAbsGridUniSizeData
                      forKey: GDMainWindowAbsoluteGridUniversalSizeKey];
	[defaultValues setObject: [NSNumber numberWithBool: NO]
                      forKey: GDDockIconVisibilityKey];
	[defaultValues setObject: [NSNumber numberWithBool: YES]
                      forKey: GDStatusItemVisibilityKey];
    
	// Register the dictionary of defaults
	[[NSUserDefaults standardUserDefaults] registerDefaults: defaultValues];
}

+ (void) setMainWindowType: (NSUInteger) newType {
    // update user defaults
    [[NSUserDefaults standardUserDefaults] setObject: [NSNumber numberWithInteger: newType]
                                              forKey: GDMainWindowTypeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];

    // send notification
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName: GDMainWindowTypeChanged
                      object: self
                    userInfo: @{ @"info": [NSNumber numberWithBool: newType] }];
}

+ (void) setStatusItemVisibility: (BOOL) showItem {
    // update user defaults
    [[NSUserDefaults standardUserDefaults] setBool: showItem
                                            forKey: GDStatusItemVisibilityKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // send notification
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName: GDStatusItemVisibilityChanged
                      object: self
                    userInfo: @{ @"info": [NSNumber numberWithBool: showItem] }];
}

+ (void) setDockIconVisibility: (BOOL) showIcon {
    // update user defaults
    [[NSUserDefaults standardUserDefaults] setBool: showIcon
                                            forKey: GDDockIconVisibilityKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // send notification
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName: GDDockIconVisibilityChanged
                      object: self
                    userInfo: @{ @"info": [NSNumber numberWithBool: showIcon] }];
}



@end

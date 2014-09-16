//
//  GDStatusPopoverPreferenceViewController.m
//  Griddy
//
//  Created by Yan Sun on 2014-09-11.
//  Copyright (c) 2014 Sunnay. All rights reserved.
//



#import "GDStatusPopoverPreferenceViewController.h"
#import "GDStatusItem.h"
#import "GDPreferences.h"
#import "GDDemoMainWindow.h"


// preference keys
extern NSString * const GDMainWindowTypeKey;
extern NSString * const GDMainWindowAbsoluteSizeKey;
extern NSString * const GDMainWindowRelativeSizeKey;
extern NSString * const GDMainWindowBackgroundColorKey;
extern NSString * const GDMainWindowBackgroundTransparencyKey;
extern NSString * const GDMainWindowGridColorKey;
extern NSString * const GDMainWindowGridTransparencyKey;
extern NSString * const GDMainWindowGridUniversalDimensionsKey;
extern NSString * const GDMainWindowRelativeGridSpecificDimensionsKey;
extern NSString * const GDMainWindowAbsoluteGridSpecificDimensionsKey;
extern NSString * const GDShortcutKey;
extern NSString * const GDStatusItemVisibilityKey;
extern NSString * const GDDockIconVisibilityKey;
extern NSString * const GDAutoLaunchOnLoginKey;


// new changes keys
extern NSString * const GDMainWindowTypePostChanges;
extern NSString * const GDMainWindowAbsoluteSizePostChanges;
extern NSString * const GDMainWindowRelativeSizePostChanges;
extern NSString * const GDMainWindowGridUniversalDimensionsPostChanges;
extern NSString * const GDStatusItemVisibilityPostChanges;
extern NSString * const GDDockIconVisibilityPostChanges;
extern NSString * const GDAutoLaunchOnLoginPostChanges;



// ui notifications
NSString * const GDStatusPopoverBackButtonSelected = @"GDStatusPopoverBackButtonSelected";
NSString * const GDStatusPopoverPreferenceViewChange = @"GDStatusPopoverPreferenceViewChange";



@interface GDStatusPopoverPreferenceViewController()

@property (nonatomic) GDDemoController *demoController;
@property (nonatomic) GDPreferencesChangesController *prefState;

- (NSView *) viewForTag: (NSUInteger) tag;

@end



@implementation GDStatusPopoverPreferenceViewController


@synthesize demoController = _demoController;
@synthesize prefState = _prefState;



# pragma mark - INIT

// Don't need
- (id) initWithNibName: (NSString *) nibNameOrNil
                bundle: (NSBundle *) nibBundleOrNil {
    self = [super initWithNibName: nibNameOrNil bundle: nibBundleOrNil];
    if (self) {
        // never directly accessed, need to be manually instantiated
        _prefState = [[GDPreferencesChangesController alloc] init];
    }
    
    return self;
}


- (void) reinit {
    // destory any unsaved changes
    [self.prefState clearChanges];
    self.demoController = nil; // destory b/c grid might be dirty
    
    // restart ui
    [self setPreferenceUI];
    [self disableButtomButtons];
    [self shouldShowDemoWindowsByTag: currentViewTag];
}


// ui setup
- (void) awakeFromNib {
    [self transitionToNewView: 1];
    [self setupNotifications];
    [self setPreferenceUI];
    [self disableButtomButtons];
}


- (GDPreferencesChangesController *) prefState {
    if (_prefState == nil) {
        _prefState = [[GDPreferencesChangesController alloc] init];
    }
    return _prefState;
}


- (GDDemoController *) demoController {
    if (_demoController == nil) {
        _demoController = [[GDDemoController alloc] init];
    }
    return _demoController;
}


# pragma mark - NOTIFICATIONS

- (void) setupNotifications {
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(windowTypeChanged:)
                                                 name: GDMainWindowTypePostChanges
                                               object: nil];
}


- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}



# pragma mark - DEMO windows

- (void) shouldShowDemoWindowsByTag: (NSUInteger) tag {
    BOOL showWindow = (tag == 1 || tag == 2);
    if (showWindow == YES) {
        [self.demoController launchWindows];
    } else {
        [self.demoController hideWindows];
    }
}



# pragma mark - BASE UI

// top buttons
- (IBAction) backToMenu: (id) sender {
    [self.prefState clearChanges];
    [self shouldShowDemoWindowsByTag: 0]; // hide it
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName: GDStatusPopoverBackButtonSelected
                      object: self
                    userInfo: nil];
}


- (IBAction) changedPreferenceTab: (id)sender {
    [self transitionToNewView: [[sender cell] tagForSegment: [sender selectedSegment]]];
}


// bottom buttons
- (IBAction) cancelChanges: (id) sender {
    [self reinit];
}


- (IBAction) acceptChanges: (id) sender {
    [self.prefState acceptChanges];
    [self disableButtomButtons];
}


- (void) transitionToNewView: (NSUInteger) tag {
    NSView *view = [self viewForTag: tag];
    NSView *previousView = [self viewForTag: currentViewTag];
    view.frame = previousView.frame;
    
    // transition
    [NSAnimationContext beginGrouping];
    if ([[NSApp currentEvent] modifierFlags] & NSShiftKeyMask) {
        [[NSAnimationContext currentContext] setDuration: 1.0];
    }
    [self.view.animator replaceSubview: previousView
                                  with: view];
    view.needsDisplay = YES;
    [NSAnimationContext endGrouping];

    [self shouldShowDemoWindowsByTag: tag];
    currentViewTag = tag;
}


- (NSView *) viewForTag: (NSUInteger) tag {
    NSView *view = nil;
    switch (tag) {
        case 1:
            view = windowView;
            break;
        case 2:
            view = gridView;
            break;
        case 3:
            view = miscView;
            break;
        default:
            view = contentView;
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


- (void) enableBottomButtons {
    acceptButton.enabled = YES;
    cancelButton.enabled = YES;
}


- (void) disableButtomButtons {
    acceptButton.enabled = NO;
    cancelButton.enabled = NO;
}



# pragma mark - INTERFACE callbacks

- (void) setPreferenceUI {
    // window tab
    NSUInteger windowType = [[[NSUserDefaults standardUserDefaults] objectForKey: GDMainWindowTypeKey] integerValue];
    [windowSizeTypeChoiceMatrix selectCellWithTag: windowType];
    [self setPreferenceUIWindowSizeWithWindowType: windowType];
    
    // grid tab
    [self setPreferenceUIGridDimensions];
    
    // misc tab
    dockIconCheckBox.state = [[[NSUserDefaults standardUserDefaults] objectForKey: GDDockIconVisibilityKey] boolValue];
    statusItemCheckBox.state = [[[NSUserDefaults standardUserDefaults] objectForKey: GDStatusItemVisibilityKey] boolValue];
}

- (void) windowTypeChanged: (NSNotification *) note {
    NSUInteger newType = [[[note userInfo] objectForKey: @"info"] integerValue];
    [self setPreferenceUIWindowSizeWithWindowType: newType];
}



// window tab callbacks

- (void) setPreferenceUIWindowSizeWithWindowType: (NSUInteger) windowType {
    NSData *sizeData;
    if (windowType == 1) { // abs
        sizeData = [[NSUserDefaults standardUserDefaults] objectForKey: GDMainWindowAbsoluteSizeKey];
    } else { // rel
        sizeData = [[NSUserDefaults standardUserDefaults] objectForKey: GDMainWindowRelativeSizeKey];
    }
    NSSize windowSize = [[NSKeyedUnarchiver unarchiveObjectWithData: sizeData] sizeValue];
    [self setWindowWidthInputBoxValue: windowSize.width
                         asWindowType: windowType];
    [self setWindowHeightInputBoxValue: windowSize.height
                          asWindowType: windowType];
}


- (IBAction) changeWindowSizeTypeChoiceMatrix: (id)sender {
    NSUInteger state = [[sender selectedCell] tag];
    NSLog(@"%lu", (unsigned long)state);
    [self sendNotification: GDMainWindowTypePostChanges
                  withInfo: @{ @"info": [NSNumber numberWithBool: state] }];
}


- (IBAction) changeWidthInputBox: (id)sender {
	NSUserDefaults *defaultValues = [NSUserDefaults standardUserDefaults];
    NSUInteger windowType = [[defaultValues objectForKey: GDMainWindowTypeKey] integerValue];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle: NSNumberFormatterDecimalStyle];
    [formatter setRoundingMode: NSNumberFormatterRoundUp];
    
    CGFloat widthVal;
    NSSize newSize;
    NSString *notificationType;

    if (windowType == 1) { // abs
        notificationType = GDMainWindowAbsoluteSizePostChanges;

        [formatter setMaximumFractionDigits: 0];
        widthVal = [[formatter numberFromString: widthInputBox.stringValue] integerValue];
        widthVal = floor((ABS(widthVal) / 5) + 0.5) * 5; // round up to nearest 5
        widthVal = MAX(300, MIN(900, widthVal));         // 300 <= widthVal <= 900
        
        // save it
        NSData *data = [defaultValues objectForKey: GDMainWindowAbsoluteSizeKey];
        NSSize oldSize = [[NSKeyedUnarchiver unarchiveObjectWithData: data] sizeValue];
        newSize = NSMakeSize(widthVal, oldSize.height);
        
    } else { // relative
        notificationType = GDMainWindowRelativeSizePostChanges;

        [formatter setMaximumFractionDigits: 2];
        widthVal = [[formatter numberFromString: widthInputBox.stringValue] floatValue] / 100;
        widthVal = MAX(0.5, MIN(0.7, widthVal));         // 5% <= widthVal <= 70%
        
        // save it
        NSData *data = [defaultValues objectForKey: GDMainWindowRelativeSizeKey];
        NSSize oldSize = [[NSKeyedUnarchiver unarchiveObjectWithData: data] sizeValue];
        newSize = NSMakeSize(widthVal, oldSize.height);
    }
    
    // send notification
    NSData *newSizeData = [NSKeyedArchiver archivedDataWithRootObject: [NSValue valueWithSize: newSize]];
    NSDictionary *infoDict = @{ @"info": newSizeData };
    [self sendNotification: notificationType withInfo: infoDict];
    
    // update ui
    [self setWindowWidthInputBoxValue: widthVal
                         asWindowType: windowType];
}


- (IBAction) changeHeightInputBox: (id) sender {
	NSUserDefaults *defaultValues = [NSUserDefaults standardUserDefaults];
    NSUInteger windowType = [[defaultValues objectForKey: GDMainWindowTypeKey] integerValue];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle: NSNumberFormatterDecimalStyle];
    [formatter setRoundingMode: NSNumberFormatterRoundUp];
    
    CGFloat heightVal;
    NSSize newSize;
    NSString *notificationType;
   
    if (windowType == 1) { // abs
        notificationType = GDMainWindowAbsoluteSizePostChanges;

        [formatter setMaximumFractionDigits: 0];
        heightVal = [[formatter numberFromString: heightInputBox.stringValue] integerValue];
        heightVal = floor((ABS(heightVal) / 5) + 0.5) * 5; // round up to nearest 5
        heightVal = MAX(180, MIN(540, heightVal));         // 180 <= heightVal <= 540
        
        // save it
        NSData *data = [defaultValues objectForKey: GDMainWindowAbsoluteSizeKey];
        NSSize oldSize = [[NSKeyedUnarchiver unarchiveObjectWithData: data] sizeValue];
        newSize = NSMakeSize(oldSize.width, heightVal);
        if (NSEqualSizes(newSize, oldSize)) {
            return;
        }
        
    } else { // relative
        notificationType = GDMainWindowRelativeSizePostChanges;

        [formatter setMaximumFractionDigits: 2];
        heightVal = [[formatter numberFromString: heightInputBox.stringValue] floatValue] / 100;
        heightVal = MAX(0.5, MIN(0.7, heightVal));         // 5% <= heightVal <= 70%
        
        // save it
        NSData *data = [defaultValues objectForKey: GDMainWindowRelativeSizeKey];
        NSSize oldSize = [[NSKeyedUnarchiver unarchiveObjectWithData: data] sizeValue];
        newSize = NSMakeSize(oldSize.width, heightVal);
        if (NSEqualSizes(newSize, oldSize)) {
            return;
        }
    }

    // send notification
    NSData *newSizeData = [NSKeyedArchiver archivedDataWithRootObject: [NSValue valueWithSize: newSize]];
    NSDictionary *infoDict = @{ @"info": newSizeData };
    [self sendNotification: notificationType withInfo: infoDict];
    
    // update ui
    [self setWindowHeightInputBoxValue: heightVal
                          asWindowType: windowType];
}


- (void) setWindowWidthInputBoxValue: (CGFloat) widthVal
                        asWindowType: (NSUInteger) windowType {
    if (windowType == 1) { // abs
        [widthInputBox setStringValue: [NSString stringWithFormat:@"%lu", (NSInteger)ceilf(widthVal)]];
        [widthInputBoxSuffix setStringValue: @"px"];
    } else {
        [widthInputBox setStringValue: [NSString stringWithFormat:@"%.2f", widthVal * 100]];
        [widthInputBoxSuffix setStringValue: @"%"];
    }
}


- (void) setWindowHeightInputBoxValue: (CGFloat) heightVal
                         asWindowType: (NSUInteger) windowType {
    if (windowType == 1) { // abs
        [heightInputBox setStringValue: [NSString stringWithFormat:@"%lu", (NSInteger)ceilf(heightVal)]];
        [heightInputBoxSuffix setStringValue: @"px"];
    } else {
        [heightInputBox setStringValue: [NSString stringWithFormat:@"%.2f", heightVal * 100]];
        [heightInputBoxSuffix setStringValue: @"%"];
    }
}



// grid tab callbacks

- (void) setPreferenceUIGridDimensions {
    NSData *sizeData = [[NSUserDefaults standardUserDefaults] objectForKey: GDMainWindowGridUniversalDimensionsKey];
    NSSize gridDimensions = [[NSKeyedUnarchiver unarchiveObjectWithData: sizeData] sizeValue];
    [self setGridXInputBoxValue: gridDimensions.width];
    [self setGridYInputBoxValue: gridDimensions.height];
}


- (IBAction) changeGridDimensionsX: (id) sender {
    NSUserDefaults *defaultValues = [NSUserDefaults standardUserDefaults];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle: NSNumberFormatterDecimalStyle];
    [formatter setRoundingMode: NSNumberFormatterRoundUp];
    [formatter setMaximumFractionDigits: 0];
    
    // calculate new dim
    CGFloat newDimX = [[formatter numberFromString: gridDimensionsX.stringValue] integerValue];
    newDimX = MIN(20, MAX(2, newDimX));         // 2 <= widthVal <= 25
    [self setGridXInputBoxValue: newDimX];
    
    // save it in user defaults
    NSData *data = [defaultValues objectForKey: GDMainWindowGridUniversalDimensionsKey];
    NSSize oldDim = [[NSKeyedUnarchiver unarchiveObjectWithData: data] sizeValue];
    NSSize newDim = NSMakeSize(newDimX, oldDim.height);
    if (NSEqualSizes(newDim, oldDim) == NO) {
        NSData *newDimData = [NSKeyedArchiver archivedDataWithRootObject: [NSValue valueWithSize: newDim]];
        NSDictionary *infoDict = @{ @"info": newDimData };
        [self sendNotification: GDMainWindowGridUniversalDimensionsPostChanges withInfo: infoDict];
    }
}


- (void) setGridXInputBoxValue: (CGFloat) dimX {
    [gridDimensionsX setStringValue: [NSString stringWithFormat:@"%lu", (NSInteger)ceilf(dimX)]];
}


- (IBAction) changeGridDimensionsY: (id) sender {
    NSUserDefaults *defaultValues = [NSUserDefaults standardUserDefaults];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle: NSNumberFormatterDecimalStyle];
    [formatter setRoundingMode: NSNumberFormatterRoundUp];
    [formatter setMaximumFractionDigits: 0];
    
    // calculate new dim
    CGFloat newDimY = [[formatter numberFromString: gridDimensionsY.stringValue] integerValue];
    newDimY = MIN(20, MAX(2, newDimY));         // 2 <= widthVal <= 25
    [self setGridYInputBoxValue: newDimY];
    
    // save it in user defaults
    NSData *data = [defaultValues objectForKey: GDMainWindowGridUniversalDimensionsKey];
    NSSize oldDim = [[NSKeyedUnarchiver unarchiveObjectWithData: data] sizeValue];
    NSSize newDim = NSMakeSize(oldDim.width, newDimY);
    if (NSEqualSizes(newDim, oldDim) == NO) {
        NSData *newDimData = [NSKeyedArchiver archivedDataWithRootObject: [NSValue valueWithSize: newDim]];
        NSDictionary *infoDict = @{ @"info": newDimData };
        [self sendNotification: GDMainWindowGridUniversalDimensionsPostChanges withInfo: infoDict];
    }
}


- (void) setGridYInputBoxValue: (CGFloat) dimY {
    [gridDimensionsY setStringValue: [NSString stringWithFormat:@"%lu", (NSInteger)ceilf(dimY)]];
}



// misc tab callbacks

- (IBAction) changeStatusItemCheckBox: (id)sender {
    NSInteger state = [statusItemCheckBox state];
    [self sendNotification: GDStatusItemVisibilityPostChanges
                  withInfo: @{ @"info": [NSNumber numberWithBool: state] }];
}


- (IBAction) changeDockIconCheckBox: (id)sender {
    NSInteger state = [dockIconCheckBox state];
    [self sendNotification: GDDockIconVisibilityPostChanges
                  withInfo: @{ @"info": [NSNumber numberWithBool: state] }];
}



# pragma mark - Notification manager

- (void) sendNotification: (NSString *) notificationName
                 withInfo: (NSDictionary *) info {
    
    // send the notification
    [[NSNotificationCenter defaultCenter] postNotificationName: notificationName
                                                        object: self
                                                      userInfo: info];
    
    // update UI
    [self enableBottomButtons];
}


@end

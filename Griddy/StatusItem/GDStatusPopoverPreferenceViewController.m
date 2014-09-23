//
//  GDStatusPopoverPreferenceViewController.m
//  Griddy
//
//  Created by Yan Sun on 2014-09-11.
//  Copyright (c) 2014 Sunnay. All rights reserved.
//



#import "GDStatusPopoverPreferenceViewController.h"
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



@interface GDStatusPopoverPreferenceViewController() {
    NSUInteger _WINDOW_TYPE;
    NSSize _ABS_SIZE;
    NSSize _REL_SIZE;
    NSSize _GRID_DIM_SIZE;
}

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
        [self setupDataFromUserDefaults];
    }
    
    return self;
}


- (void) reinit {
    // destory any unsaved changes
    [self.prefState clearChanges];
    self.demoController = nil; // destory b/c grid might be dirty

    [self setupDataFromUserDefaults];
    
    // restart ui
    [self setPreferenceUI];
    [self disableButtomButtons];
    [self shouldShowDemoWindowsByTag: currentViewTag];
}

- (void) cleanUp {
    [self.demoController hideWindows];
}


// ui setup
- (void) awakeFromNib {
    [self transitionToNewView: 1];
    [self setupNotifications];
    [self setPreferenceUI];
    [self disableButtomButtons];
}


- (void) setupDataFromUserDefaults {
    NSUserDefaults *defaultValues = [NSUserDefaults standardUserDefaults];

    _WINDOW_TYPE = [[defaultValues objectForKey: GDMainWindowTypeKey] integerValue];
    
    NSData *absSizeData = [defaultValues objectForKey: GDMainWindowAbsoluteSizeKey];
    _ABS_SIZE = [[NSKeyedUnarchiver unarchiveObjectWithData: absSizeData] sizeValue];
    
    NSData *relSizeData = [defaultValues objectForKey: GDMainWindowRelativeSizeKey];
    _REL_SIZE = [[NSKeyedUnarchiver unarchiveObjectWithData: relSizeData] sizeValue];
    
    NSData *gridDimData = [defaultValues objectForKey: GDMainWindowGridUniversalDimensionsKey];
    _GRID_DIM_SIZE = [[NSKeyedUnarchiver unarchiveObjectWithData: gridDimData] sizeValue];
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


- (void) hideDemoWindows {
    [self.demoController hideWindows];
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
    [windowSizeTypeChoiceMatrix selectCellWithTag: _WINDOW_TYPE];
    [self setPreferenceUIWindowSizeWithWindowType: _WINDOW_TYPE];
    
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
    NSSize windowSize = (windowType == 1) ? _ABS_SIZE : _REL_SIZE;
    [self setWindowWidthInputBoxValue: windowSize.width];
    [self setWindowHeightInputBoxValue: windowSize.height];
}


- (IBAction) changeWindowSizeTypeChoiceMatrix: (id)sender {
    NSUInteger newType = [[sender selectedCell] tag];
    if (newType == _WINDOW_TYPE) {
        return;
    }
    _WINDOW_TYPE = newType;
    [self sendNotification: GDMainWindowTypePostChanges
                  withInfo: @{ @"info": [NSNumber numberWithBool: newType] }];
}


- (IBAction) changeWidthInputBox: (id)sender {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle: NSNumberFormatterDecimalStyle];
    [formatter setRoundingMode: NSNumberFormatterRoundUp];
    
    CGFloat widthVal;
    NSSize newSize;
    NSString *notificationType;

    if (_WINDOW_TYPE == 1) { // abs
        notificationType = GDMainWindowAbsoluteSizePostChanges;

        // round
        [formatter setMaximumFractionDigits: 0];
        widthVal = [[formatter numberFromString: widthInputBox.stringValue] integerValue];
        widthVal = floor((ABS(widthVal) / 5) + 0.5) * 5; // round up to nearest 5
        widthVal = MAX(300, MIN(900, widthVal));         // 300 <= widthVal <= 900
        
        // make new size
        newSize = NSMakeSize(widthVal, _ABS_SIZE.height);
        if (NSEqualSizes(newSize, _ABS_SIZE)) {
            return;
        }
        _ABS_SIZE = newSize;
        
    } else { // relative
        notificationType = GDMainWindowRelativeSizePostChanges;

        // round
        [formatter setMaximumFractionDigits: 2];
        widthVal = [[formatter numberFromString: widthInputBox.stringValue] floatValue] / 100;
        widthVal = MAX(0.05, MIN(0.7, widthVal));         // 5% <= widthVal <= 70%
        
        // generate new size
        newSize = NSMakeSize(widthVal, _REL_SIZE.height);
        if (NSEqualSizes(newSize, _REL_SIZE)) {
            return;
        }
        _REL_SIZE = newSize;
    }
    
    // send notification
    NSData *newSizeData = [NSKeyedArchiver archivedDataWithRootObject: [NSValue valueWithSize: newSize]];
    NSDictionary *infoDict = @{ @"info": newSizeData };
    [self sendNotification: notificationType withInfo: infoDict];
    
    // update ui
    [self setWindowWidthInputBoxValue: widthVal];
}


- (IBAction) changeHeightInputBox: (id) sender {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle: NSNumberFormatterDecimalStyle];
    [formatter setRoundingMode: NSNumberFormatterRoundUp];
    
    CGFloat heightVal;
    NSSize newSize;
    NSString *notificationType;
   
    if (_WINDOW_TYPE == 1) { // abs
        notificationType = GDMainWindowAbsoluteSizePostChanges;

        [formatter setMaximumFractionDigits: 0];
        heightVal = [[formatter numberFromString: heightInputBox.stringValue] integerValue];
        heightVal = floor((ABS(heightVal) / 5) + 0.5) * 5; // round up to nearest 5
        heightVal = MAX(180, MIN(540, heightVal));         // 180 <= heightVal <= 540
        
        // make new size
        newSize = NSMakeSize(_ABS_SIZE.width, heightVal);
        if (NSEqualSizes(newSize, _ABS_SIZE)) {
            return;
        }
        _ABS_SIZE = newSize;
        
    } else { // relative
        notificationType = GDMainWindowRelativeSizePostChanges;

        [formatter setMaximumFractionDigits: 2];
        heightVal = [[formatter numberFromString: heightInputBox.stringValue] floatValue] / 100;
        heightVal = MAX(0.05, MIN(0.7, heightVal));         // 5% <= heightVal <= 70%

        // make new size
        newSize = NSMakeSize(_REL_SIZE.width, heightVal);
        if (NSEqualSizes(newSize, _REL_SIZE)) {
            return;
        }
        _REL_SIZE = newSize;
    }

    // send notification
    NSData *newSizeData = [NSKeyedArchiver archivedDataWithRootObject: [NSValue valueWithSize: newSize]];
    NSDictionary *infoDict = @{ @"info": newSizeData };
    [self sendNotification: notificationType withInfo: infoDict];
    
    // update ui
    [self setWindowHeightInputBoxValue: heightVal];
}


- (void) setWindowWidthInputBoxValue: (CGFloat) widthVal {
    if (_WINDOW_TYPE == 1) { // abs
        [widthInputBox setStringValue: [NSString stringWithFormat:@"%lu", (NSInteger)ceilf(widthVal)]];
        [widthInputBoxSuffix setStringValue: @"px"];
    } else {
        [widthInputBox setStringValue: [NSString stringWithFormat:@"%.2f", widthVal * 100]];
        [widthInputBoxSuffix setStringValue: @"%"];
    }
}


- (void) setWindowHeightInputBoxValue: (CGFloat) heightVal {
    if (_WINDOW_TYPE == 1) { // abs
        [heightInputBox setStringValue: [NSString stringWithFormat:@"%lu", (NSInteger)ceilf(heightVal)]];
        [heightInputBoxSuffix setStringValue: @"px"];
    } else {
        [heightInputBox setStringValue: [NSString stringWithFormat:@"%.2f", heightVal * 100]];
        [heightInputBoxSuffix setStringValue: @"%"];
    }
}



// grid tab callbacks

- (void) setPreferenceUIGridDimensions {
    [self setGridXInputBoxValue: _GRID_DIM_SIZE.width];
    [self setGridYInputBoxValue: _GRID_DIM_SIZE.height];
}


- (IBAction) changeGridDimensionsX: (id) sender {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle: NSNumberFormatterDecimalStyle];
    [formatter setRoundingMode: NSNumberFormatterRoundUp];
    [formatter setMaximumFractionDigits: 0];
    
    // calculate new dim
    CGFloat newDimX = [[formatter numberFromString: gridDimensionsX.stringValue] integerValue];
    newDimX = MIN(20, MAX(2, newDimX));         // 2 <= widthVal <= 25
    [self setGridXInputBoxValue: newDimX];
    
    // make new dim
    NSSize newDim = NSMakeSize(newDimX, _GRID_DIM_SIZE.height);
    
    if (NSEqualSizes(newDim, _GRID_DIM_SIZE) == NO) {
        _GRID_DIM_SIZE = newDim;
        
        // send notification
        NSData *newDimData = [NSKeyedArchiver archivedDataWithRootObject: [NSValue valueWithSize: newDim]];
        NSDictionary *infoDict = @{ @"info": newDimData };
        [self sendNotification: GDMainWindowGridUniversalDimensionsPostChanges withInfo: infoDict];
    }
}


- (void) setGridXInputBoxValue: (CGFloat) dimX {
    [gridDimensionsX setStringValue: [NSString stringWithFormat:@"%lu", (NSInteger)ceilf(dimX)]];
}


- (IBAction) changeGridDimensionsY: (id) sender {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle: NSNumberFormatterDecimalStyle];
    [formatter setRoundingMode: NSNumberFormatterRoundUp];
    [formatter setMaximumFractionDigits: 0];
    
    // calculate new dim
    CGFloat newDimY = [[formatter numberFromString: gridDimensionsY.stringValue] integerValue];
    newDimY = MIN(20, MAX(2, newDimY));         // 2 <= widthVal <= 25
    [self setGridYInputBoxValue: newDimY];

    // make new dim
    NSSize newDim = NSMakeSize(_GRID_DIM_SIZE.width, newDimY);

    if (NSEqualSizes(newDim, _GRID_DIM_SIZE) == NO) {
        _GRID_DIM_SIZE = newDim;
        
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

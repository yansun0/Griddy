//
//  GDAppDelegate.m
//  Griddy
//
//  Created by Yan Sun on 2014-06-24.
//  Copyright (c) 2014 Sunnay. All rights reserved.
//

#import "GDAppDelegate.h"
#import "GDOverlayWindow.h"
#import "GDMainWindowController.h"
#import "GDGrid.h"
#import "GDScreen.h"
#import "GDStatusItem.h"
#import "GDPreferences.h"

#import <Carbon/Carbon.h>
#import "MASShortcut.h"
#import "MASShortcut+UserDefaults.h"



NSString * const LaunchKeyShortcut = @"GDLaunchShortcut";
NSString * const DockMenuKeyShortcut = @"GDDockhShortcut";

// user default keys
extern NSString * const GDDockIconVisibilityKey;
extern NSString * const GDStatusItemVisibilityKey;

// notifications names
extern NSString * const StatusItemMenuOpened;
extern NSString * const GDMainWindowTypeChanged;
extern NSString * const GDMainWindowAbsoluteSizeChanged;
extern NSString * const GDMainWindowRelativeSizeChanged;
extern NSString * const GDDockIconVisibilityChanged;
extern NSString * const GDStatusItemVisibilityChanged;
extern NSString * const GDAutoLaunchOnLoginChanged;


@interface GDAppDelegate() {
    NSTimer *checkAppIntervalTimer;
}

@property (strong, nonatomic) NSRunningApplication *frontApp;
@property (strong, nonatomic) NSMutableArray *avaliableScreens;
@property (strong, nonatomic) NSMutableArray *windowControllers;
@property (strong, nonatomic) GDOverlayWindow *overlayWindow;
@property (strong, nonatomic) GDStatusItemController *GDStatusItemController;
@property (strong, nonatomic) GDPreferenceController *preferenceController;
@property (nonatomic) BOOL isVisible;
@property (nonatomic) BOOL dockIconVisible;
@property (nonatomic) BOOL statusVisible;

@end



@implementation GDAppDelegate

@synthesize frontApp = _frontApp;
@synthesize avaliableScreens = _avaliableScreens;
@synthesize windowControllers = _windowControllers;
@synthesize overlayWindow = _overlayWindow;
@synthesize GDStatusItemController = _GDStatusItemController;
@synthesize isVisible = _isVisible;
@synthesize dockIconVisible = _dockIconVisible;
@synthesize statusVisible = _statusVisible;



#pragma mark - INITIALIZATION
+ (void) initialize {
    [GDPreferenceController setUserDefaults];
}

- (void) applicationWillFinishLaunching: (NSNotification *) note {
    [self notificationSetup];
    [self windowControllers];
    [self avaliableScreens];
    [self setupHotkey];

    _dockIconVisible = [[NSUserDefaults standardUserDefaults] boolForKey: GDDockIconVisibilityKey];
    [self transformApp: _dockIconVisible];
    _statusVisible = [[NSUserDefaults standardUserDefaults] boolForKey: GDStatusItemVisibilityKey];
    if (_statusVisible == YES) {
        [self setupStatusItem];
    }
}

- (void) applicationWillTerminate: (NSNotification *) note {
    [self hideWindows];
    _statusVisible = NO;
    [self changeStatusItemState: _statusVisible];
    [[[NSWorkspace sharedWorkspace] notificationCenter] removeObserver: self];
}



#pragma mark - NOTIFICATIONS
- (void) notificationSetup {
    // register global notifications
    [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver: self
                                                           selector: @selector(someAppDeactivated:)
                                                               name: NSWorkspaceDidDeactivateApplicationNotification
                                                             object: nil];
    
    // register local notifications
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver: self
           selector: @selector(onStatusItemMenuOpened:)
               name: StatusItemMenuOpened
             object: nil];

    [nc addObserver: self
           selector: @selector(onGDDockIconVisibilityChanged:)
               name: GDDockIconVisibilityChanged
             object: nil];
}

- (void) onStatusItemMenuOpened: (NSNotification *) note {
    [self hideWindows];
}

- (void) onGDDockIconVisibilityChanged: (NSNotification *) note {
	BOOL newVisibility = [[[note userInfo] objectForKey:@"info"] boolValue];
    [self transformApp: newVisibility];
}



#pragma mark - WINDOW FUNCTIONS
- (void) launchWindows {
    _isVisible = YES;
    for (NSUInteger i = 0; i < _windowControllers.count; i++) {
        [[_windowControllers objectAtIndex: i] showWindow: nil];
        [[_windowControllers objectAtIndex: i] setFrontApp: [_frontApp localizedName]];
    }
}

- (void) hideWindows {
    _isVisible = NO;

    // hide overlay window
    [self hideHoverWindow];
    
    // hide all windows
    for (NSUInteger i = 0; i < _windowControllers.count; i++) {
        GDMainWindowController *curWC = [_windowControllers objectAtIndex: i];
        [curWC hideWindow];
    }
    
    if (![_GDStatusItemController isStatusItemMenuOpen] && ![_preferenceController isWindowFocused]) {
        [_frontApp activateWithOptions: 0]; // default option
    }
}

- (void) toggleWindowState {
    if (_isVisible == YES) {
        [self hideWindows];
    } else {
        [self launchWindows];
    }
}

- (void) showHoverWindowWithFrame: (NSRect) newFrame
                 BehindMainWindow: (NSWindow *) mainWindow {
    if (!_overlayWindow) {
        _overlayWindow = [[GDOverlayWindow alloc] initWithRect: newFrame];
    }
    [_overlayWindow showWindow: mainWindow
                     withFrame: newFrame];
}

- (void) hideHoverWindow {
    [_overlayWindow orderOut: nil];
}

- (void) preventAllWindowHiding {
    for (NSUInteger i = 0; i < _windowControllers.count; i++) {
        [[_windowControllers objectAtIndex: i] preventHideWindow];
    }
    [_preferenceController preventHideWindow];
    [_overlayWindow preventHideWindow];
}

- (void) enableAllWindowHiding {
    for (NSUInteger i = 0; i < _windowControllers.count; i++) {
        [[_windowControllers objectAtIndex: i] enableHideWindow];
    }
    [_preferenceController enableHideWindow];
    [_overlayWindow enableHideWindow];
}



#pragma mark - DOCK
// started from the dock and now i'm here
- (BOOL) applicationShouldHandleReopen: (NSApplication *) sender
                    hasVisibleWindows: (BOOL) flag {
    [self toggleWindowState];
    return NO;
}



#pragma mark - STATUS BAR
- (void) setupStatusItem {
    SEL toggleWindowStateSel = @selector(toggleWindowState);
    _GDStatusItemController = [[GDStatusItemController alloc] initWithAction: toggleWindowStateSel
                                                                   andTarget: self];
}

// started from the status bar and now i'm here
- (void) changeStatusItemState: (BOOL) newStatusState {
    if (newStatusState == NO) {
        [_GDStatusItemController hideStatusItem];
        _GDStatusItemController = nil;
    } else {
        [self setupStatusItem];
    }
    _statusVisible = newStatusState;
}



#pragma mark - CUSTOM KEY
// started from the some keys and now i'm here
- (void) setupHotkey {
    // Cmd + G to activate
    MASShortcut *shortcut1 = [MASShortcut shortcutWithKeyCode: 0x05
                                                      modifierFlags: NSCommandKeyMask];
    [MASShortcut setGlobalShortcut: shortcut1
                forUserDefaultsKey: LaunchKeyShortcut];
    [MASShortcut registerGlobalShortcutWithUserDefaultsKey: LaunchKeyShortcut
                                                   handler: ^{
            if (_isVisible == NO) {
                [self launchWindows];
            } else {
                [self hideWindows];
            }
        }
    ];

    // Cmd + H for dev
    MASShortcut *shortcut2 = [MASShortcut shortcutWithKeyCode: 0x04
                                                modifierFlags: NSCommandKeyMask];
    [MASShortcut setGlobalShortcut: shortcut2
                forUserDefaultsKey: DockMenuKeyShortcut];
    [MASShortcut registerGlobalShortcutWithUserDefaultsKey: DockMenuKeyShortcut
                                                   handler: ^{
                                                       [self transformApp: !_dockIconVisible];
                                                       [self changeStatusItemState: !_statusVisible];
                                                   } ];
    
    // ESC for hiding windows
    [NSEvent addLocalMonitorForEventsMatchingMask: NSKeyDownMask
                                          handler: ^NSEvent *(NSEvent *event) {
                                              if (event.keyCode == 53) {
                                                  [self hideWindows];
                                              }
                                              return event;
                                          }
    ];
}



#pragma mark - TRANSFORM APP TYPE
- (void) transformApp: (BOOL) toShow {
    if (toShow == _dockIconVisible) {
        return;
    }
    _dockIconVisible = toShow;
    for (NSRunningApplication *app in [NSRunningApplication runningApplicationsWithBundleIdentifier:@"com.sunnay.Griddy"]) {
        [app activateWithOptions: NSApplicationActivateIgnoringOtherApps];
        break;
    }
    if (toShow == YES) {
        [self performSelector: @selector(transformAppToShowStep2)
                   withObject: nil
                   afterDelay: 0.1];
    } else {
        [self performSelector: @selector(transformAppToHideStep2)
                   withObject: nil
                   afterDelay: 0.1];
    }
}

- (void) transformAppToHideStep2 {
    [self preventAllWindowHiding];
    ProcessSerialNumber psn = { 0, kCurrentProcess };
    (void) TransformProcessType(&psn, kProcessTransformToUIElementApplication);
    [self performSelector: @selector(transformAppToStep3)
               withObject: nil
               afterDelay: 0.1];
}

- (void) transformAppToShowStep2 {
    ProcessSerialNumber psn = { 0, kCurrentProcess };
    (void) TransformProcessType(&psn, kProcessTransformToForegroundApplication);
    [self performSelector: @selector(transformAppToStep3)
               withObject: nil
               afterDelay: 0.1];
}

- (void) transformAppToStep3 {
    [[NSRunningApplication currentApplication] activateWithOptions: NSApplicationActivateIgnoringOtherApps];
    [self enableAllWindowHiding];
}



#pragma mark - WINDOW CONTROLLER CALLBACKS
- (void) moveAppWithResultRect: (NSString *)resultRect {
    NSDictionary* errorDict;
    NSAppleEventDescriptor* returnDescriptor = NULL;
    
    NSString *scriptStr = [NSString stringWithFormat: @"\
        global theApp, theBounds\n\
        set theApp to \"%@\"\n\
        set theBounds to %@\n\
        \n\
        tell application \"System Events\"\n\
            set isScriptable to has scripting terminology of application process theApp\n\
            if isScriptable then\n\
                my scriptableApp(theApp)\n\
            else\n\
                my nonScriptableApp(theApp)\n\
            end if\n\
        end tell\n\
        \n\
        on scriptableApp(theApp)\n\
            tell application theApp to set the bounds of the front window to theBounds\n\
        end scriptableApp\n\
        \n\
        on nonScriptableApp(theApp)\n\
            tell application \"System Events\"\n\
                set size of front window of application process theApp to item 1 of theBounds\n\
                set position of front window of application process theApp to item 2 of theBounds\n\
            end tell\n\
        end nonScriptableApp", [_frontApp localizedName], resultRect];
    NSAppleScript *AaplScript = [[NSAppleScript alloc] initWithSource: scriptStr];
    
    returnDescriptor = [AaplScript executeAndReturnError: &errorDict];
    if (returnDescriptor != NULL) {
        NSLog(@"success: move %@ to %@", [_frontApp localizedName], resultRect);
        // successful execution

    } else {
        NSLog(@"error: didn't move %@ to %@", [_frontApp localizedName], resultRect);
    }
    
    [self hideWindows];
}

- (void) closeAllUnfocusedWindowsIncluding: (NSWindow *) curWindow {
    NSUInteger numClosed = 0;
    for (NSUInteger i = 0; i < _windowControllers.count; i++) {
        GDMainWindowController *curWC = [_windowControllers objectAtIndex: i];
        if ([curWC isWindowFocused] == NO) {
            [curWC hideWindow];
            numClosed = numClosed + 1;
        }
    }
    
    if (numClosed == _windowControllers.count) {
        [self hideWindows]; // properly shutdown
    }
}

- (void) closeAllOtherWindowsExcluding: (NSWindow *) curWindow {
    for (NSUInteger i = 0; i < _windowControllers.count; i++) {
        GDMainWindowController *curWC = [_windowControllers objectAtIndex: i];
        if ([curWC thisWindow] != (GDMainWindow *)curWindow) {
            [curWC hideWindow];
        }
    }
}



#pragma mark - APP
- (void) someAppDeactivated: (NSNotification *)note {
    NSRunningApplication *relinquishedApp = [[note userInfo] valueForKey: @"NSWorkspaceApplicationKey"];
    _frontApp = relinquishedApp;
}



#pragma mark - SCREENS
- (void) applicationDidChangeScreenParameters:(NSNotification *)aNotification {
    [self updateAvaliableScreens];
}

- (NSMutableArray *) windowControllers {
    if (!_windowControllers) {
        _windowControllers = [[NSMutableArray alloc] initWithCapacity:1];

        for (int i = 0; i < _avaliableScreens.count; i++) {
            GDScreen *curScreen = [_avaliableScreens objectAtIndex: i];
            GDMainWindowController *curWC = [[GDMainWindowController alloc] initWithGDScreen: curScreen];
            [_windowControllers addObject: curWC];
        }
    }
    return _windowControllers;
}

- (NSMutableArray *) avaliableScreens {
    if (!_avaliableScreens) {
        _avaliableScreens = [[NSMutableArray alloc] initWithCapacity:1];
    }
    [self updateAvaliableScreens];
    return _avaliableScreens;
}

- (void) updateAvaliableScreens {
    NSArray *screenArray = [NSScreen screens];

    // step 1. add a screen that's not already in the avaliable screen array
    for (NSUInteger i = 0; i < [screenArray count]; i++)  {
        NSScreen *curScreen = [screenArray objectAtIndex: i];
        
        BOOL screenIsAlreadyRegistered = NO;
        for (NSUInteger j = 0; j < _avaliableScreens.count; j++) {
            GDScreen *curGDScreen = [_avaliableScreens objectAtIndex: j];
            if ([curGDScreen isSameNSScreen:curScreen] == YES) {
                screenIsAlreadyRegistered = YES;
            }
        }
        
        if (screenIsAlreadyRegistered == NO) {
            // add to list of avaliable screens
            GDScreen *newGDScreen = [[GDScreen alloc] initWithScreen: curScreen];
            [_avaliableScreens addObject:newGDScreen];
            
            // make a new window controller
            GDMainWindowController *newWC = [[GDMainWindowController alloc] initWithGDScreen: newGDScreen];
            [_windowControllers addObject:newWC];
        }
    }

    // step 2. remove a screen that is in the avaliable screen array but nolonger avaliable
    for (NSUInteger i = 0; i < [_avaliableScreens count]; i++)  {
        GDScreen *curGDScreen = [_avaliableScreens objectAtIndex: i];
        
        BOOL screenNoLongerAvaliable = YES;
        for (NSUInteger j = 0; j < screenArray.count; j++) {
            NSScreen *curScreen = [screenArray objectAtIndex:j];
            if ([curGDScreen isSameNSScreen:curScreen] == YES) {
                screenNoLongerAvaliable = NO;
            }
        }
        
        if (screenNoLongerAvaliable == YES) {
            // remove from list of avaliable screens
            [_avaliableScreens removeObjectAtIndex:i];
            
            // remove the associated window controller
            for (NSUInteger j = 0; j < _windowControllers.count; j++) {
                GDMainWindowController *curWC = [_windowControllers objectAtIndex: j];
                if ([curWC.thisGrid.thisGDScreen isSameGDScreen: curGDScreen] == YES) {
                    [_windowControllers removeObjectAtIndex: j];
                }
            }
            
        }
    }
}



#pragma mark - PREFERENCES
- (void) openPreferences {
    if (_preferenceController == nil) {
        _preferenceController = [[GDPreferenceController alloc] init];
    }
    [[_GDStatusItemController statusItemView] hidePopover];
    [_preferenceController showWindow: nil];
}
@end

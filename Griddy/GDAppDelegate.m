//
//  GDAppDelegate.m
//  Griddy
//
//  Created by Yan Sun on 2014-06-24.
//  Copyright (c) 2014 Sunnay. All rights reserved.
//

#import "GDAppDelegate.h"
#import "GDApp.h"

#import "GDMainWindow.h"
#import "GDOverlayWindow.h"
#import "GDStatusItem.h"

#import "GDPreferences.h"
#import "GDUtils.h"

#import "GDGrid.h"
#import "GDScreen.h"

#import <Carbon/Carbon.h>
#import "MASShortcut.h"
#import "MASShortcut+UserDefaults.h"



// user default keys
NSString * const LaunchKeyShortcut = @"GDLaunchShortcut";
NSString * const DockMenuKeyShortcut = @"GDDockhShortcut";
extern NSString * const GDDockIconVisibilityKey;

// notifications names
extern NSString * const GDDockIconVisibilityChanged;
extern NSString * const GDAutoLaunchOnLoginChanged;

static BOOL isDockVisible;





@implementation GDAppDelegate


#pragma mark - INITIALIZATION

+ (void) initialize {
    [ GDPreferences setUserDefaults ];
    [ GDUtils checkAccessibilityAccessAndPromptUser: YES ];
    isDockVisible = [ [ NSUserDefaults standardUserDefaults ] boolForKey: GDDockIconVisibilityKey ];
}


- ( void ) applicationWillFinishLaunching: ( NSNotification * ) note {
    [ self setupNotifications ];
    [ self setupHotkey ];
    [ self setDockVisibility: isDockVisible ];
    [ GDStatusItemController get ];
}


- (void) applicationWillTerminate: (NSNotification *) note {
    [ [ GDApp get ] hideWindows ];
    [ [ GDStatusItemController get ] hideStatusItem ];
}



#pragma mark - NOTIFICATIONS

- ( void ) setupNotifications {
    NSNotificationCenter *nc = [ NSNotificationCenter defaultCenter ];
    [ nc addObserver: self
            selector: @selector( onGDDockIconVisibilityChanged: )
                name: GDDockIconVisibilityChanged
              object: nil ];
}


- ( void ) onGDDockIconVisibilityChanged: ( NSNotification * ) note {
	BOOL newVisibility = [ [ [ note userInfo ] objectForKey: @"info" ] boolValue ];
    [ self setDockVisibility: newVisibility ];
}


- ( void ) applicationDidChangeScreenParameters: ( NSNotification * ) note {
    [ [ GDApp get ] updateScreensAndControllers ];
}


- ( void ) dealloc {
    [ [ NSNotificationCenter defaultCenter ] removeObserver: self ];
}



#pragma mark - DOCK

// started from the dock and now i'm here
- ( BOOL ) applicationShouldHandleReopen: ( NSApplication * ) sender
                    hasVisibleWindows: ( BOOL ) flag {
    [ [ GDApp get ] toggleWindowState ];
    return NO;
}

- ( void ) setDockVisibility: ( BOOL ) newVisibility {
    isDockVisible = newVisibility;
    NSString *id = [ [ NSBundle mainBundle ] bundleIdentifier ];
    for ( NSRunningApplication *app in [ NSRunningApplication runningApplicationsWithBundleIdentifier: id ] ) {
        [ app activateWithOptions: NSApplicationActivateIgnoringOtherApps ];
        break;
    }

    [ self performSelector: @selector( tranformAppTo: )
                withObject: [ NSNumber numberWithBool: newVisibility ]
                afterDelay: 0.1 ];
}

- ( void) tranformAppTo: ( NSNumber * ) showDock {
    [ self setAllWindowHiding: NO ];
    ProcessSerialNumber psn = { 0, kCurrentProcess };
    ProcessApplicationTransformState newState = ( [ showDock boolValue ] ?
                                                 kProcessTransformToForegroundApplication :
                                                 kProcessTransformToUIElementApplication );
    ( void ) TransformProcessType( &psn, newState );
    [ self performSelector: @selector( transformAppCleanup )
                withObject: nil
                afterDelay: 0.1];
}


- ( void ) transformAppCleanup {
    [ [ NSRunningApplication currentApplication ] activateWithOptions: NSApplicationActivateIgnoringOtherApps ];
    [ self setAllWindowHiding: YES];
}


- ( void ) setAllWindowHiding: ( BOOL ) canHide {
    [ [ GDApp get ] canHide: canHide ];
    [ [ GDOverlayWindowController get ] canHide: canHide ];
}



#pragma mark - CUSTOM KEY

// started from the some keys and now i'm here
- ( void ) setupHotkey {
    // Cmd + G to activate
    MASShortcut *shortcut1 = [ MASShortcut shortcutWithKeyCode: 0x05
                                                 modifierFlags: NSCommandKeyMask ];
    [ MASShortcut setGlobalShortcut: shortcut1
                 forUserDefaultsKey: LaunchKeyShortcut ];
    [ MASShortcut registerGlobalShortcutWithUserDefaultsKey: LaunchKeyShortcut
                                                    handler: ^{ [ [ GDApp get ] toggleWindowState ]; }
    ];

    // Cmd + H to force show dock and status item
    MASShortcut *shortcut2 = [MASShortcut shortcutWithKeyCode: 0x04
                                                modifierFlags: NSCommandKeyMask ];
    [ MASShortcut setGlobalShortcut: shortcut2
                 forUserDefaultsKey: DockMenuKeyShortcut ];
    [ MASShortcut registerGlobalShortcutWithUserDefaultsKey: DockMenuKeyShortcut
                                                    handler: ^{
                                                        [ self setDockVisibility: true ];
                                                        [ [ GDStatusItemController get ] showStatusItem ];
                                                    } ];
    
    // ESC for hiding windows
    [ NSEvent addLocalMonitorForEventsMatchingMask: NSKeyDownMask
                                           handler: ^NSEvent *( NSEvent *event ) {
                                               if ( event.keyCode == 53 ) {
                                                   [ [ GDApp get ] hideWindows ];
                                               }
                                               return event;
                                           }
    ];
}


@end

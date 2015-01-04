//
//  GDUtils.m
//  Griddy
//
//  Created by Yan Sun on 11/8/14.
//  Copyright (c) 2014 Sunnay. All rights reserved.
//

#import "GDUtils.h"
#import "GDGrid.h"
#import "GDScreen.h"


extern NSString * const GDMoveMethodKey;
extern NSString * const GDMoveMethodChanged;

static BOOL _moveMethod;
static AXUIElementRef _frontApp;
static AXUIElementRef _frontWindow;



@implementation GDUtils


#pragma mark - INITIALIZATION

+ ( void ) initialize {
    _moveMethod = [ [ [ NSUserDefaults standardUserDefaults ] objectForKey: GDMoveMethodKey ] integerValue ];
    [ [ NSNotificationCenter defaultCenter ] addObserver: self
                                                selector: @selector( onMoveMethodChanged: )
                                                    name: GDMoveMethodChanged
                                                  object: nil ];
}


+ ( void ) onMoveMethodChanged: ( NSNotification * ) note {
    _moveMethod = [ [ [ note userInfo ] objectForKey: @"info" ] integerValue ];
}



#pragma mark - MOVE UTILS

+ ( BOOL ) setFrontAppAndWindow {
    if ( [ self checkAccessibilityAccessAndPromptUser: NO ] == NO ) {
        return NO;
    }
    
    if ( _frontApp ) {
        CFRelease( _frontApp );
    }
    if ( _frontWindow ) {
        CFRelease( _frontWindow );
    }
    
    AXUIElementRef sysWideEle = AXUIElementCreateSystemWide();
    CFTypeRef app, window;
    CFArrayRef windows;
    AXError result;
    
    // step1: get front app
    if ( ( result = AXUIElementCopyAttributeValue( sysWideEle, kAXFocusedApplicationAttribute, &app ) ) != kAXErrorSuccess ) {
        NSLog( @"GDUtils | setFrontAppAndWindow -- no front app" );
        return NO;
    }
    _frontApp = app;
    
    // step2: get front window
    if ( ( result = AXUIElementCopyAttributeValue( _frontApp, kAXFocusedWindowAttribute, &window ) ) == kAXErrorSuccess ) {
        if ( CFGetTypeID( window ) == AXUIElementGetTypeID() ) {
            _frontWindow = window;
        }
        
    // ok, no focus window grad it from the list of windows
    } else if ( ( result = AXUIElementCopyAttributeValues( _frontApp, kAXWindowsAttribute, 0, 999, &windows ) ) == kAXErrorSuccess ) {
        if (windows && CFArrayGetCount( windows ) != 0) {
            window = CFArrayGetValueAtIndex( windows, 0 );
            if ( CFGetTypeID( window ) == AXUIElementGetTypeID() ) {
                _frontWindow = window;
            }
            CFRelease( windows );
        }
    }
    
    return CFGetTypeID( _frontWindow ) != CFNullGetTypeID();
}


+ ( NSRunningApplication * ) getFrontApp {
    NSRunningApplication *retApp;
    if ( _frontApp ) {
        pid_t somePid;
        AXUIElementGetPid( _frontApp, &somePid );
        retApp = [ NSRunningApplication runningApplicationWithProcessIdentifier: somePid ];
    }
    return retApp;
}


+ ( void ) moveFromCell1: ( NSPoint ) cell1
                 toCell2: ( NSPoint ) cell2
                withGrid: ( GDGrid * ) grid {
    
    NSLog( @"GDUtils | moveFromCell1:toCell2:withGrid -- start = (%d, %d)", ( int )cell1.x, ( int )cell1.y );
    NSLog( @"GDUtils | moveFromCell1:toCell2:withGrid -- end = (%d, %d)", ( int )cell2.x, ( int )cell2.y );
    NSRect newPos;
    if ( _moveMethod == 0 ) {
        newPos = [ grid getAppWindowFrameFromCell1: cell1
                                           ToCell2: cell2 ];
        [ self gentleNudge: newPos ];
        
    } else {
        newPos = [ grid getAppWindowBoundsStringFromCell1: cell1
                                                  ToCell2: cell2 ];
        [ self forceMove: newPos ];
    }
}


+ ( void ) gentleNudge: ( NSRect ) rect {   // OPTION 1 -- use accessibility api
    NSLog( @"GDUtils | gentleNudge -- called" );
    if ( !_frontWindow ) {
        NSLog( @"GDUtils | gentleNudge -- no front window found" );
        return;
    }
    
    CGSize windowSize;
    CGPoint windowPosition;
    AXValueRef temp;
    
    // 1st find new position
    AXUIElementCopyAttributeValue( _frontWindow, kAXPositionAttribute, ( CFTypeRef * )&temp );
    AXValueGetValue( temp, kAXValueCGPointType, &windowPosition );
    CFRelease( temp );
    
    // 2nd find new size
    AXUIElementCopyAttributeValue( _frontWindow, kAXSizeAttribute, ( CFTypeRef * )&temp );
    AXValueGetValue( temp, kAXValueCGSizeType, &windowSize );
    CFRelease( temp );
    
    // 3rd move
    windowPosition = rect.origin;
    temp = AXValueCreate( kAXValueCGPointType, &windowPosition );
    AXUIElementSetAttributeValue( _frontWindow, kAXPositionAttribute, temp );
    CFRelease( temp );
    
    // 4th resize
    windowSize = rect.size;
    temp = AXValueCreate( kAXValueCGSizeType, &windowSize );
    AXUIElementSetAttributeValue( _frontWindow, kAXSizeAttribute, temp );
    CFRelease( temp );
}


+ ( void ) forceMove: ( NSRect ) rect {    // OPTION 2 -- use applescript
    NSLog( @"GDUtils | forceMove -- called" );
    NSRunningApplication *appToMove = [ self getFrontApp ];
    if ( !appToMove ) {
        NSLog( @"GDUtils | forceMove -- no front app found" );
        return;
    }
    
    // construct script
    NSString *rectStr = [ NSString stringWithFormat: @"{%d, %d, %d, %d}",
                         ( int ) rect.origin.x, ( int ) rect.size.width,
                         ( int ) rect.origin.y, ( int ) rect.size.height];
    NSString *scriptStr = [ NSString stringWithFormat: @"\
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
                           end nonScriptableApp", [ appToMove localizedName ], rectStr ];
    NSAppleScript *AaplScript = [ [ NSAppleScript alloc ] initWithSource: scriptStr ];
    
    // run script
    NSDictionary* errorDict;
    NSAppleEventDescriptor *returnDescriptor = [ AaplScript executeAndReturnError: &errorDict ];
    if ( returnDescriptor == NULL ) {   // failed
        NSLog( @"GDUtils | forceMove -- couldn't move to %@ due to %@", rectStr, returnDescriptor );
    }
}


+ ( BOOL ) checkAccessibilityAccessAndPromptUser: ( BOOL ) doPrompt {
    if ( AXIsProcessTrusted() != 0 ) {
        return YES;
    } else if ( doPrompt ) {
        return AXIsProcessTrustedWithOptions( ( __bridge CFDictionaryRef )@{ ( __bridge NSString * )kAXTrustedCheckOptionPrompt : @YES } );
    }
    return NO;
}



#pragma mark - SCREEN UTILS

+ ( void ) updateCurScreens: ( NSMutableArray * ) curScreens
             WithNewScreens: ( NSMutableArray ** ) newScreens
          AndRemovedScreens: ( NSMutableArray ** ) rmScreens {
    NSArray *screenArray = [ NSScreen screens ];
    
    // step 1. add a screen that's not already in the avaliable screen array
    for ( NSUInteger i = 0; i < [ screenArray count ]; i++ )  {
        NSScreen *curScreen = [ screenArray objectAtIndex: i ];
        
        BOOL screenIsNotYetRegistered = YES;
        for ( NSUInteger j = 0; j < curScreens.count; j++ ) {
            GDScreen *curGDScreen = [ curScreens objectAtIndex: j ];
            if ( [ curGDScreen isSameNSScreen: curScreen ] == YES ) {
                screenIsNotYetRegistered = NO;
                break;
            }
        }
        
        if (screenIsNotYetRegistered == YES) {
            GDScreen *newGDScreen = [ [ GDScreen alloc ] initWithScreen: curScreen ];
            [ curScreens addObject: newGDScreen ];
            [ self addGDScreen: newGDScreen toArray: newScreens ];
        }
    }
    
    // step 2. remove a screen that is in the avaliable screen array but nolonger avaliable
    for ( NSUInteger i = 0; i < curScreens.count; i++ )  {
        GDScreen *curGDScreen = [ curScreens objectAtIndex: i ];
        
        BOOL screenNoLongerAvaliable = YES;
        for ( NSUInteger j = 0; j < screenArray.count; j++ ) {
            NSScreen *curScreen = [ screenArray objectAtIndex: j ];
            if ( [ curGDScreen isSameNSScreen: curScreen ] == YES ) {
                screenNoLongerAvaliable = NO;
                break;
            }
        }
        
        if ( screenNoLongerAvaliable == YES ) {
            [ curScreens removeObjectAtIndex: i ];
            [ self addGDScreen: curGDScreen toArray: rmScreens ];
        }
    }
}


+ ( void ) addGDScreen: ( GDScreen * ) screen
               toArray: ( NSMutableArray ** ) array {
    if ( !*array ) {
        *array = [ [ NSMutableArray alloc ] initWithCapacity: 1 ];
    }
    [ *array addObject: screen ];
}

@end

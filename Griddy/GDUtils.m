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

static BOOL moveMethod;
static NSRunningApplication *appToMove;



@implementation GDUtils


+ (void) initialize {
    moveMethod = [[[NSUserDefaults standardUserDefaults] objectForKey: GDMoveMethodKey] integerValue];

    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(onMoveMethodChanged:)
                                                 name: GDMoveMethodChanged
                                               object: nil];
    [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver: self
                                                           selector: @selector(onSomeAppDeactivated:)
                                                               name: NSWorkspaceDidDeactivateApplicationNotification
                                                             object: nil];
}

+ (void) onMoveMethodChanged: (NSNotification *) note {
    moveMethod = [[[note userInfo] objectForKey:@"info"] integerValue];
}


+ (void) onSomeAppDeactivated: (NSNotification *)note {
    NSRunningApplication *relinquishedApp = [[note userInfo] valueForKey: @"NSWorkspaceApplicationKey"];
    appToMove = relinquishedApp;
}



// return true if has accessibility access, false otherwise
+ (BOOL) checkAccessibilityAccessAndPromptUser: (BOOL) doPrompt {
    if (AXIsProcessTrusted() != 0) {
        return YES;
    } else if ( doPrompt ) {
        return AXIsProcessTrustedWithOptions((__bridge CFDictionaryRef)@{ (__bridge NSString *)kAXTrustedCheckOptionPrompt : @YES });
    }
    return NO;
}



// THE MONEY MAKER
+ (void) moveFromCell1: (NSPoint) cell1
               toCell2: (NSPoint) cell2
              withGrid: (GDGrid *) grid {
    
    NSLog(@"[START] -- (%d, %d)", (int)cell1.x, (int)cell1.y);
    NSLog(@"[END] -- (%d, %d)", (int)cell2.x, (int)cell2.y);
    NSRect newPos;
    if (moveMethod == 0) {
        newPos = [grid getAppWindowFrameFromCell1: cell1
                                          ToCell2: cell2];
        [self gentleNudge: newPos];
        
    } else {
        newPos = [grid getAppWindowBoundsStringFromCell1: cell1
                                                 ToCell2: cell2];
        [self forceMove: newPos];
    }
}



+ (void) gentleNudge: (NSRect) rect {   // OPTION 1 -- use accessibility api
    NSLog(@"NOT FORCED move");

    // TODO: move all this check BEFORE MainWindow appears
    if ([self checkAccessibilityAccessAndPromptUser: NO] == NO) {
        return;
    }
    
    CGSize windowSize;
    CGPoint windowPosition;
    AXError result;
    CFTypeRef window;
    CFArrayRef windows;
    AXUIElementRef frontMostApp = AXUIElementCreateApplication(appToMove.processIdentifier);
    AXUIElementRef frontMostWindow;
    // NSLog(@"%d, \n kAXErrorAttributeUnsupported = %d\n kAXErrorNoValue = %d\n kAXErrorIllegalArgument = %d\n kAXErrorInvalidUIElement = %d\n kAXErrorCannotComplete = %d\n kAXErrorNotImplemented = %d\n", (int)result, kAXErrorAttributeUnsupported, kAXErrorNoValue, kAXErrorIllegalArgument, kAXErrorInvalidUIElement, kAXErrorCannotComplete, kAXErrorNotImplemented);
    
    // grad the focus window
    if ((result = AXUIElementCopyAttributeValue(frontMostApp, kAXFocusedWindowAttribute, &window)) == kAXErrorSuccess) {
        if (CFGetTypeID(window) == AXUIElementGetTypeID()) {
            frontMostWindow = window;
        }
        
        // ok, no focus window grad it from the list of windows
    } else if ((result = AXUIElementCopyAttributeValues(frontMostApp, kAXWindowsAttribute, 0, 999, &windows)) == kAXErrorSuccess) {
        if (windows && CFArrayGetCount(windows) != 0) {
            window = CFArrayGetValueAtIndex(windows, 0);
            if (CFGetTypeID(window) == AXUIElementGetTypeID()) {
                frontMostWindow = window;
            }
        }
    }
    
    if (frontMostWindow) {
        AXValueRef temp;
        
        // 1st find new position
        AXUIElementCopyAttributeValue(frontMostWindow, kAXPositionAttribute, (CFTypeRef *)&temp);
        AXValueGetValue(temp, kAXValueCGPointType, &windowPosition);
        CFRelease(temp);
        
        // 2nd find new size
        AXUIElementCopyAttributeValue(frontMostWindow, kAXSizeAttribute, (CFTypeRef *)&temp);
        AXValueGetValue(temp, kAXValueCGSizeType, &windowSize);
        CFRelease(temp);
        
        // 1st move
        windowPosition = rect.origin;
        temp = AXValueCreate(kAXValueCGPointType, &windowPosition);
        AXUIElementSetAttributeValue(frontMostWindow, kAXPositionAttribute, temp);
        CFRelease(temp);
        
        // 2nd resize
        windowSize = rect.size;
        temp = AXValueCreate(kAXValueCGSizeType, &windowSize);
        AXUIElementSetAttributeValue(frontMostWindow, kAXSizeAttribute, temp);
        CFRelease(temp);
        
        CFRelease(frontMostWindow);
        
    } else {
        NSLog(@"no front most window");
    }
    
    CFRelease(frontMostApp);
    [self refocusApp];
}


+ (void) forceMove: (NSRect) rect {    // OPTION 2 -- use applescript

    // TODO: move all this check BEFORE MainWindow appears
    if ([self checkAccessibilityAccessAndPromptUser: NO] == NO) {
        return;
    }
    
    NSString *rectStr = [NSString stringWithFormat: @"{%d, %d, %d, %d}",
                         (int) rect.origin.x, (int) rect.size.width,
                         (int) rect.origin.y, (int) rect.size.height];
    
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
                           end nonScriptableApp", [appToMove localizedName], rectStr];
    NSAppleScript *AaplScript = [[NSAppleScript alloc] initWithSource: scriptStr];
    
    returnDescriptor = [AaplScript executeAndReturnError: &errorDict];
    if (returnDescriptor == NULL) {
        NSLog(@"error: didn't move %@ to %@", [appToMove localizedName], rectStr);
        NSLog(@"%@", returnDescriptor);
    }
}


+ (void) refocusApp {
    [appToMove activateWithOptions: 0]; // default option
}




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

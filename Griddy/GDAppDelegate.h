//
//  GDAppDelegate.h
//  Griddy
//
//  Created by Yan Sun on 2014-06-24.
//  Copyright (c) 2014 Sunnay. All rights reserved.
//

#import <Cocoa/Cocoa.h>



@interface GDAppDelegate : NSObject <NSApplicationDelegate>

//@property (strong, nonatomic) IBOutlet NSMenu *GDStatusMenu;

- (void) launchWindowsBehindWindowLevel: (NSInteger) topWindowLevel;
- (void) hideWindows;
- (void) showHoverWindowWithFrame: (NSRect) newFrame
                 BehindMainWindow: (NSWindow *) mainWindow;
- (void) hideHoverWindow;
- (void) moveAppWithResultRect: (NSString *) resultRect;
- (void) closeAllUnfocusedWindowsIncluding: (NSWindow *) curWindow;
- (void) closeAllOtherWindowsExcluding: (NSWindow *) curWindow;
- (void) openPreferences;
@end

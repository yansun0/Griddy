//
//  GDPreferences.h
//  Griddy
//
//  Created by Yan Sun on 2014-08-23.
//  Copyright (c) 2014 Sunnay. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface GDPreferenceController : NSWindowController {
    // window view outlets
    IBOutlet NSView *appearancesView;
    IBOutlet NSMatrix *mainWindowSizeChoiceMatrix;
    IBOutlet NSTextField *widthInputBox;
    IBOutlet NSTextField *widthInputBoxSuffix;
    IBOutlet NSTextField *heightInputBox;
    IBOutlet NSTextField *heightInputBoxSuffix;

    // grid view outlets
    IBOutlet NSView *functionalityView;
    IBOutlet NSTextField *gridDimensionsX;
    IBOutlet NSTextField *gridDimensionsY;
    
    // misc view outlets
    IBOutlet NSView *miscView;
    IBOutlet NSButton *statusItemCheckBox;
    IBOutlet NSButton *dockIconCheckBox;
    NSUInteger currentViewTag;
}

// appearance tab
- (IBAction) changeMainWindowSizeChoiceMatrix: (id) sender;
- (IBAction) changeWidthInputBox: (id) sender;
- (IBAction) changeHeightInputBox: (id) sender;

// grid tab
- (IBAction) changeGridDimensionsX: (id) sender;
- (IBAction) changeGridDimensionsY: (id) sender;

// misc tab
- (IBAction) changeStatusItemCheckBox: (id) sender;
- (IBAction) changeDockIconCheckBox: (id) sender;

- (void) preventHideWindow;
- (void) enableHideWindow;
- (BOOL) isWindowFocused;
- (IBAction) switchView: (id) sender;
+ (void) setUserDefaults;

@end

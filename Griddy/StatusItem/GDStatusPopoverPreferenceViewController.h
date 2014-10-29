//
//  GDStatusPopoverPreferenceViewController.h
//  Griddy
//
//  Created by Yan Sun on 2014-09-11.
//  Copyright (c) 2014 Sunnay. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GDStatusItem.h"
@class GDStatusItemController;



@interface GDStatusPopoverPreferenceViewController : NSViewController <GDStatusPopoverViewController> {
    IBOutlet NSButton *backButton;
    IBOutlet NSSegmentedControl *preferenceTab;
    IBOutlet NSButton *cancelButton;
    IBOutlet NSButton *acceptButton;
    IBOutlet NSView *contentView;
    
    // window view outlets
    IBOutlet NSView *windowView;
    IBOutlet NSMatrix *windowSizeTypeChoiceMatrix;
    IBOutlet NSTextField *widthInputBox;
    IBOutlet NSTextField *widthInputBoxSuffix;
    IBOutlet NSTextField *heightInputBox;
    IBOutlet NSTextField *heightInputBoxSuffix;
    
    // grid view outlets
    IBOutlet NSView *gridView;
    IBOutlet NSTextField *gridDimensionsX;
    IBOutlet NSTextField *gridDimensionsY;
    
    // misc view outlets
    IBOutlet NSView *miscView;
    IBOutlet NSButton *openOnStartupCheckbox; // TODO
    IBOutlet NSButton *forceWindowMove;
    IBOutlet NSButton *statusItemCheckBox;
    IBOutlet NSButton *dockIconCheckBox;
    NSUInteger currentViewTag;
}

@property (nonatomic, strong) GDStatusItemController *statusItemController;

// top buttons
- (IBAction) backToMenu: (id)sender;
- (IBAction) changedPreferenceTab: (id)sender;

// appearance tab
- (IBAction) changeWindowSizeTypeChoiceMatrix: (id) sender;
- (IBAction) changeWidthInputBox: (id) sender;
- (IBAction) changeHeightInputBox: (id) sender;

// grid tab
- (IBAction) changeGridDimensionsX: (id) sender;
- (IBAction) changeGridDimensionsY: (id) sender;

// misc tab
- (IBAction) changeOpenOnStartup: (id)sender;
- (IBAction) changeForceWindowMove: (id)sender;
- (IBAction) changeStatusItemCheckBox: (id) sender;
- (IBAction) changeDockIconCheckBox: (id) sender;

// bottom buttons
- (IBAction) cancelChanges: (id) sender;
- (IBAction) acceptChanges: (id) sender;

// manually hide demo windows if needed
- (void) hideDemoWindows;

@end
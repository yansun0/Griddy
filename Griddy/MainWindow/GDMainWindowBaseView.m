//
//  GDMainWindowBaseView.m
//  Griddy
//
//  Created by Yan Sun on 10 May 15.
//  Copyright (c) 2015 Sunnay. All rights reserved.
//

#import "GDMainWindowBaseView.h"
#import "GDScreen.h"
#import "GDGridBase.h"
#import "GDAssets.h"





// ----------------------------------
#pragma mark - GDMainWindowBaseView
// ----------------------------------

@implementation GDMainWindowBaseView

- ( id ) initWithGrid: ( GDGridBase * ) grid {
    self = [ super initWithFrame: grid.winFrame ];
    
    if ( self != nil ) {
        // setup self
        self.wantsLayer = YES;
        self.layer.frame = self.frame;
        self.layer.cornerRadius = 15.0;
        self.layer.masksToBounds = YES;
        
        // setup border
        self.layer.borderWidth = 1.0f;
        self.layer.borderColor = [ [ GDAssets getWindowBorder ] CGColor ];
        
        // setup vibrancy
        self.material = [ GDAssets getWindowMaterial ];
        self.blendingMode = NSVisualEffectBlendingModeBehindWindow;
        self.state = NSVisualEffectStateActive;
        
        [ [ NSNotificationCenter defaultCenter ] addObserver: self
                                                    selector: @selector( onAppearanceModeChanged: )
                                                        name: GDAppearanceModeChanged
                                                      object: nil ];
    }
    
    return self;
}


- ( void ) onAppearanceModeChanged: ( NSNotification * ) note {
    self.material = [ GDAssets getWindowMaterial ];
    self.layer.borderColor = [ [ GDAssets getWindowBorder ] CGColor ];
}


- ( void ) dealloc {
    [ [ NSNotificationCenter defaultCenter ] removeObserver: self ];
}

@end





// ----------------------------------
#pragma mark - GDMainWindowAppInfoView
// ----------------------------------

@implementation GDMainWindowBaseAppInfoView

- ( id ) initWithGrid: ( GDGridBase * ) grid {
    self = [ super initWithFrame: [ grid getAppInfoFrame ] ];
    
    if ( self != nil ) {
        self.appIcon = [ [ NSImageView alloc ] initWithFrame: [ grid getAppIconFrame ] ];
        self.appIcon.imageScaling = NSImageScaleAxesIndependently;
        [ self addSubview: self.appIcon ];
        
        self.appName = [ [ NSTextField alloc ] initWithFrame: [ grid getAppNameFrame ] ];
        self.appName.bezeled = NO;
        self.appName.drawsBackground = NO;
        self.appName.editable = NO;
        self.appName.selectable = NO;
        self.appName.textColor = [ GDAssets getTextColor ];
        [ self addSubview: self.appName ];
        
        [ [ NSNotificationCenter defaultCenter ] addObserver: self
                                                    selector: @selector( onAppearanceModeChanged: )
                                                        name: GDAppearanceModeChanged
                                                      object: nil ];
    }
    
    return self;
}


- ( void ) dealloc {
    [ [ NSNotificationCenter defaultCenter ] removeObserver: self ];
}


- ( void ) onAppearanceModeChanged: ( NSNotification * ) note {
    self.appName.textColor = [ GDAssets getTextColor ];
}

@end





// ---------------------------
#pragma mark - GDCellViewBase
// ---------------------------

@implementation GDCellViewBase

- ( id ) initWithFrame: ( NSRect ) frame {
    self = [ super initWithFrame: frame ];
    
    if ( self ) {
        self.wantsLayer = YES;
        self.layer.frame = self.frame;
        
        // setup rounded corners
        self.layer.cornerRadius = 3.0f;
        self.layer.masksToBounds = YES;
        
        // setup border
        self.layer.borderWidth = 1.0f;
        self.layer.borderColor = [ [ GDAssets getCellBorderBackground ] CGColor ];
        
        [ [ NSNotificationCenter defaultCenter ] addObserver: self
                                                    selector: @selector( onAppearanceModeChanged: )
                                                        name: GDAppearanceModeChanged
                                                      object: nil ];
    }
    
    return self;
}


- ( void ) dealloc {
    [ [ NSNotificationCenter defaultCenter ] removeObserver: self ];
}


- ( void ) onAppearanceModeChanged: ( NSNotification * ) note {
    self.layer.borderColor = [ [ GDAssets getCellBorderBackground ] CGColor ];
}


- ( void ) drawRect: ( NSRect ) dirtyRect {
    [ [ GDAssets getCellBackground ] set ];
    NSRectFill( dirtyRect );
}

@end

//
//  GDPreferences.m
//  Griddy
//
//  Created by Yan Sun on 2014-08-23.
//  Copyright (c) 2014 Sunnay. All rights reserved.
//

#import "GDPreferences.h"



// preference keys
NSString * const GDMainWindowTypeKey = @"GDMainWindowTypeKey";
NSString * const GDMainWindowAbsoluteSizeKey = @"GDMainWindowAbsoluteSizeKey";
NSString * const GDMainWindowRelativeSizeKey = @"GDMainWindowRelativeSizeKey";
NSString * const GDMainWindowBackgroundColorKey = @"GDMainWindowBackgroundColor";
NSString * const GDMainWindowBackgroundTransparencyKey = @"GDMainWindowBackgroundTransparencyKey";
NSString * const GDMainWindowGridColorKey = @"GDMainWindowGridColorKey";
NSString * const GDMainWindowGridTransparencyKey = @"GDMainWindowGridTransparencyKey";
NSString * const GDMainWindowGridUniversalDimensionsKey = @"GDMainWindowGridUniversalDimensionsKey";
NSString * const GDMainWindowRelativeGridSpecificDimensionsKey = @"GDMainWindowRelativeGridSpecificDimensionsKey";
NSString * const GDMainWindowAbsoluteGridSpecificDimensionsKey = @"GDMainWindowAbsoluteGridSpecificDimensionsKey";
NSString * const GDShortcutKey = @"GDShortcutKey";
NSString * const GDStatusItemVisibilityKey = @"GDStatusItemVisibilityKey";
NSString * const GDDockIconVisibilityKey = @"GDDockIconVisibilityKey";
NSString * const GDAutoLaunchOnLoginKey = @"GDAutoLaunchOnLoginKey";



// changes keys
NSString * const GDMainWindowTypeChanged = @"GDMainWindowTypeChanged";
NSString * const GDMainWindowAbsoluteSizeChanged = @"GDMainWindowAbsoluteSizeChanged";
NSString * const GDMainWindowRelativeSizeChanged = @"GDMainWindowRelativeSizeChanged";
NSString * const GDMainWindowGridUniversalDimensionsChanged = @"GDMainWindowGridUniversalDimensionsChanged";
NSString * const GDStatusItemVisibilityChanged = @"GDStatusItemVisibilityChanged";
NSString * const GDDockIconVisibilityChanged = @"GDDockIconVisibilityChanged";
NSString * const GDAutoLaunchOnLoginChanged = @"GDAutoLaunchOnLoginChanged";



@implementation GDPreferences



# pragma mark - USER DEFAULTS

+ (void) setUserDefaults {
    // archive necessary data
    NSSize mainWindowAbsSize = NSMakeSize(500, 400);
    NSData *mainWindowAbsSizeData = [NSKeyedArchiver archivedDataWithRootObject: [NSValue valueWithSize: mainWindowAbsSize]];
    NSSize mainWindowRelativeSize = NSMakeSize(0.2, 0.3);
    NSData *mainWindowRelativeSizeData = [NSKeyedArchiver archivedDataWithRootObject: [NSValue valueWithSize: mainWindowRelativeSize]];
    NSSize mainWindowAbsGridUniSize = NSMakeSize(7, 5);
    NSData *mainWindowAbsGridUniSizeData = [NSKeyedArchiver archivedDataWithRootObject: [NSValue valueWithSize: mainWindowAbsGridUniSize]];
    
	// create default dictionary
	NSMutableDictionary *defaultValues = [NSMutableDictionary dictionary];
	[defaultValues setObject: [NSNumber numberWithInteger: 1] // 0 = relative, 1 = abs
                      forKey: GDMainWindowTypeKey];
	[defaultValues setObject: mainWindowAbsSizeData
                      forKey: GDMainWindowAbsoluteSizeKey];
    [defaultValues setObject: mainWindowRelativeSizeData
                      forKey: GDMainWindowRelativeSizeKey];
    [defaultValues setObject: mainWindowAbsGridUniSizeData
                      forKey: GDMainWindowGridUniversalDimensionsKey];
	[defaultValues setObject: [NSNumber numberWithBool: NO]
                      forKey: GDDockIconVisibilityKey];
	[defaultValues setObject: [NSNumber numberWithBool: YES]
                      forKey: GDStatusItemVisibilityKey];
    
	// Register the dictionary of defaults
	[[NSUserDefaults standardUserDefaults] registerDefaults: defaultValues];
}


+ (void) setMainWindowTypeDefault: (NSUInteger) newType {
    // update user defaults
    [[NSUserDefaults standardUserDefaults] setObject: [NSNumber numberWithInteger: newType]
                                              forKey: GDMainWindowTypeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];

    // send notification
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName: GDMainWindowTypeChanged
                      object: self
                    userInfo: @{ @"info": [NSNumber numberWithBool: newType] }];
}


+ (void) setStatusItemVisibilityDefault: (BOOL) showItem {
    // update user defaults
    [[NSUserDefaults standardUserDefaults] setBool: showItem
                                            forKey: GDStatusItemVisibilityKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // send notification
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName: GDStatusItemVisibilityChanged
                      object: self
                    userInfo: @{ @"info": [NSNumber numberWithBool: showItem] }];
}


+ (void) setDockIconVisibilityDefault: (BOOL) showIcon {
    // update user defaults
    [[NSUserDefaults standardUserDefaults] setBool: showIcon
                                            forKey: GDDockIconVisibilityKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // send notification
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName: GDDockIconVisibilityChanged
                      object: self
                    userInfo: @{ @"info": [NSNumber numberWithBool: showIcon] }];
}


+ (void) setMainWindowRelativeSizeDefault: (NSSize) newSize {
    // update user defaults
    NSData *newRelativeSizeData = [NSKeyedArchiver archivedDataWithRootObject: [NSValue valueWithSize: newSize]];
    [[NSUserDefaults standardUserDefaults] setObject: newRelativeSizeData
                                              forKey: GDMainWindowRelativeSizeKey];
    
    // send notification
    NSValue *sizeValue = [NSValue valueWithSize: newSize];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName: GDMainWindowRelativeSizeChanged
                      object: self
                    userInfo: @{ @"info": sizeValue }];
}


+ (void) setMainWindowAbsoluteSizeDefault: (NSSize) newSize {
    // update user defaults
    NSData *newAbsSizeData = [NSKeyedArchiver archivedDataWithRootObject: [NSValue valueWithSize: newSize]];
    [[NSUserDefaults standardUserDefaults] setObject: newAbsSizeData
                                              forKey: GDMainWindowAbsoluteSizeKey];
    
    // send notification
    NSValue *sizeValue = [NSValue valueWithSize: newSize];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName: GDMainWindowAbsoluteSizeChanged
                      object: self
                    userInfo: @{ @"info": sizeValue }];
}


+ (void) setGridDimensionsDefault: (NSSize) newDimensions {
    // update user defaults
    NSData *newGridDimensions = [NSKeyedArchiver archivedDataWithRootObject: [NSValue valueWithSize: newDimensions]];
    [[NSUserDefaults standardUserDefaults] setObject: newGridDimensions
                                              forKey: GDMainWindowGridUniversalDimensionsKey];
    
    // send notification
    NSValue *sizeValue = [NSValue valueWithSize: newDimensions];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName: GDMainWindowGridUniversalDimensionsChanged
                      object: self
                    userInfo: @{ @"info": sizeValue }];
}

@end

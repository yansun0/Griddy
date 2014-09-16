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


// posted changes keys
NSString * const GDMainWindowTypePostChanges = @"GDMainWindowTypePostChanges";
NSString * const GDMainWindowAbsoluteSizePostChanges = @"GDMainWindowAbsoluteSizePostChanges";
NSString * const GDMainWindowRelativeSizePostChanges = @"GDMainWindowRelativeSizePostChanges";
NSString * const GDMainWindowGridUniversalDimensionsPostChanges = @"GDMainWindowGridUniversalDimensionsPostChanges";
NSString * const GDStatusItemVisibilityPostChanges = @"GDStatusItemVisibilityPostChanges";
NSString * const GDDockIconVisibilityPostChanges = @"GDDockIconVisibilityPostChanges";
NSString * const GDAutoLaunchOnLoginPostChanges = @"GDAutoLaunchOnLoginPostChanges";


// accepted changes keys
NSString * const GDMainWindowTypeChanged = @"GDMainWindowTypeChanged";
NSString * const GDMainWindowAbsoluteSizeChanged = @"GDMainWindowAbsoluteSizeChanged";
NSString * const GDMainWindowRelativeSizeChanged = @"GDMainWindowRelativeSizeChanged";
NSString * const GDMainWindowGridUniversalDimensionsChanged = @"GDMainWindowGridUniversalDimensionsChanged";
NSString * const GDStatusItemVisibilityChanged = @"GDStatusItemVisibilityChanged";
NSString * const GDDockIconVisibilityChanged = @"GDDockIconVisibilityChanged";
NSString * const GDAutoLaunchOnLoginChanged = @"GDAutoLaunchOnLoginChanged";





// ----------------------------------
#pragma mark - GDPreferences
// ----------------------------------

@implementation GDPreferences


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
    NSLog(@"stored it");
    // short circuit
    if (newType == [[[NSUserDefaults standardUserDefaults] objectForKey: GDMainWindowTypeKey] integerValue]) {
        return;
    }
    
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
    // short circuit
    if (showItem == [[[NSUserDefaults standardUserDefaults] objectForKey: GDStatusItemVisibilityKey] boolValue]) {
        return;
    }
    
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
    // short circuit
    if (showIcon == [[[NSUserDefaults standardUserDefaults] objectForKey: GDDockIconVisibilityKey] boolValue]) {
        return;
    }
    
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
    NSUserDefaults *defaultValues = [NSUserDefaults standardUserDefaults];

    // short circuit
    NSData *data = [defaultValues objectForKey: GDMainWindowRelativeSizeKey];
    NSSize oldSize = [[NSKeyedUnarchiver unarchiveObjectWithData: data] sizeValue];
    if (NSEqualSizes(newSize, oldSize)) {
        return;
    }
    
    // update user defaults
    NSData *newRelativeSizeData = [NSKeyedArchiver archivedDataWithRootObject: [NSValue valueWithSize: newSize]];
    [defaultValues setObject: newRelativeSizeData
                      forKey: GDMainWindowRelativeSizeKey];
    
    // send notification
    NSValue *sizeValue = [NSValue valueWithSize: newSize];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName: GDMainWindowRelativeSizeChanged
                      object: self
                    userInfo: @{ @"info": sizeValue }];
}


+ (void) setMainWindowAbsoluteSizeDefault: (NSSize) newSize {
    NSUserDefaults *defaultValues = [NSUserDefaults standardUserDefaults];

    // short circuit
    NSData *data = [defaultValues objectForKey: GDMainWindowAbsoluteSizeKey];
    NSSize oldSize = [[NSKeyedUnarchiver unarchiveObjectWithData: data] sizeValue];
    if (NSEqualSizes(newSize, oldSize)) {
        return;
    }
    
    // update user defaults
    NSData *newAbsSizeData = [NSKeyedArchiver archivedDataWithRootObject: [NSValue valueWithSize: newSize]];
    [defaultValues setObject: newAbsSizeData
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





// ----------------------------------
#pragma mark - GDPreferencesChangesController
// ----------------------------------

@interface GDPreferencesChangesController()
@property (nonatomic)  NSMutableArray *changes;
@end


@implementation GDPreferencesChangesController

@synthesize changes = _changes;


- (id) init {
    self = [super init];
    if (self) {
        [self listenToChangesNotifications];
    }
    return self;
}


- (NSMutableArray *) changes {
    if (_changes == nil) {
        _changes = [[NSMutableArray alloc] init];
    }
    return _changes;
}


- (void) listenToChangesNotifications {
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver: self
                      selector: @selector(addNewChange:)
                          name: GDMainWindowTypePostChanges
                        object: nil];
    [defaultCenter addObserver: self
                      selector: @selector(addNewChange:)
                          name: GDMainWindowAbsoluteSizePostChanges
                        object: nil];
    [defaultCenter addObserver: self
                      selector: @selector(addNewChange:)
                          name: GDMainWindowRelativeSizePostChanges
                        object: nil];
    [defaultCenter addObserver: self
                      selector: @selector(addNewChange:)
                          name: GDMainWindowGridUniversalDimensionsPostChanges
                        object: nil];
    [defaultCenter addObserver: self
                      selector: @selector(addNewChange:)
                          name: GDStatusItemVisibilityPostChanges
                        object: nil];
    [defaultCenter addObserver: self
                      selector: @selector(addNewChange:)
                          name: GDDockIconVisibilityPostChanges
                        object: nil];
    [defaultCenter addObserver: self
                      selector: @selector(addNewChange:)
                          name: GDAutoLaunchOnLoginPostChanges
                        object: nil];
}


- (void) addNewChange: (NSNotification *) note {
    GDPreferencesChange *newChange =  [[GDPreferencesChange alloc] initWithNotificationName: note.name AndData: note.userInfo];
    
    // check if smae type already exists in array , if so replace it
    BOOL sameTypeExists = NO;
    for (int i = 0; i < self.changes.count; i++) {
        GDPreferencesChange *curChange = [self.changes objectAtIndex: i];
        if ([curChange isSameType: note.name] == YES) {
            [self.changes replaceObjectAtIndex: i
                                withObject: newChange];
            sameTypeExists = YES;
            break; // there can only be one
        }
    }
    
    // if not append to the end
    if (sameTypeExists == NO) {
        [self.changes addObject: newChange];
    }
}


- (void) acceptChanges {
    for (int i = 0; i < self.changes.count; i++) {
        GDPreferencesChange *curChange = [self.changes objectAtIndex: i];
        [curChange acceptChange];
    }
    [self clearChanges];
}


- (void) clearChanges {
    [self.changes removeAllObjects];
}


- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}


@end





// ----------------------------------
#pragma mark - GDPreferencesChange
// ----------------------------------

@interface GDPreferencesChange() {
    NSString *_name;
    NSDictionary *_data;
}
@end


@implementation GDPreferencesChange

- (id) initWithNotificationName: (NSString *) name
                        AndData: (NSDictionary *) data {
    self = [super init];
    if (self) {
        _name = name;
        _data = data;
    }
    return self;
}


- (BOOL) isSameType: (NSString *) name {
    return [_name isEqualToString: name];
}

- (void) acceptChange {
    if ([_name isEqualToString: GDMainWindowTypePostChanges]) {
        NSUInteger newType = [[_data objectForKey: @"info"] integerValue];
        [GDPreferences setMainWindowTypeDefault: newType];
        
    } else if ([_name isEqualToString: GDMainWindowAbsoluteSizePostChanges]) {
        NSData *data = [_data objectForKey: @"info"];
        NSValue *unarchived = [NSKeyedUnarchiver unarchiveObjectWithData: data];
        NSSize newSize = [unarchived sizeValue];
        [GDPreferences setMainWindowAbsoluteSizeDefault: newSize];

    } else if ([_name isEqualToString: GDMainWindowRelativeSizePostChanges]) {
        NSData *data = [_data objectForKey: @"info"];
        NSValue *unarchived = [NSKeyedUnarchiver unarchiveObjectWithData: data];
        NSSize newSize = [unarchived sizeValue];
        [GDPreferences setMainWindowRelativeSizeDefault: newSize];
        
    } else if ([_name isEqualToString: GDMainWindowGridUniversalDimensionsPostChanges]) {
        NSData *data = [_data objectForKey: @"info"];
        NSValue *unarchived = [NSKeyedUnarchiver unarchiveObjectWithData: data];
        NSSize newSize = [unarchived sizeValue];
        [GDPreferences setGridDimensionsDefault: newSize];
        
    } else if ([_name isEqualToString: GDStatusItemVisibilityPostChanges]) {
        BOOL newState = [[_data objectForKey: @"info"] boolValue];
        [GDPreferences setStatusItemVisibilityDefault: newState];

    } else if ([_name isEqualToString: GDDockIconVisibilityPostChanges]) {
        BOOL newState = [[_data objectForKey: @"info"] boolValue];
        [GDPreferences setDockIconVisibilityDefault: newState];
        
    } else if ([_name isEqualToString: GDAutoLaunchOnLoginPostChanges]) {
        //
        
    }
}

@end


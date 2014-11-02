//
//  GDAssets.m
//  Griddy
//
//  Created by Yan Sun on 2014-08-21.
//  Copyright (c) 2014 Sunnay. All rights reserved.
//

#import "GDAssets.h"



NSString * const GDAppearanceModeChanged = @"GDAppearanceModeChanged";
static BOOL isDarkMode;



@implementation GDAssets



#pragma mark - COLORS

+ (void) initialize {
    [GDAssets onAppearanceModeChanged: nil];
    [[NSDistributedNotificationCenter defaultCenter] addObserver: self
                                                        selector: @selector(onAppearanceModeChanged:)
                                                            name: @"AppleInterfaceThemeChangedNotification"
                                                          object: nil];
}


+ (void) onAppearanceModeChanged: (NSNotification *) note {
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] persistentDomainForName: NSGlobalDomain];
    id style = [dict objectForKey: @"AppleInterfaceStyle"];
    isDarkMode = ( style && [style isKindOfClass:[NSString class]] && NSOrderedSame == [style caseInsensitiveCompare:@"dark"] );
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName: GDAppearanceModeChanged
                      object: self];
}


// color: window
+ (NSVisualEffectMaterial) getWindowMaterial {
    return isDarkMode ? NSVisualEffectMaterialDark: // dark mode
                        NSVisualEffectMaterialLight; // light mode
}

+ (NSColor *) getWindowBorder {
    return isDarkMode ? [NSColor colorWithCalibratedWhite: 0.0 alpha: 0.25f]: // dark mode
                        [NSColor colorWithCalibratedWhite: 1.0 alpha: 0.25f]; // light mode ???
}

+ (NSColor *) getOverlayInnerBorder {
    return isDarkMode ? [NSColor colorWithCalibratedWhite: 1.0 alpha: 0.9f]: // dark mode
                        [NSColor colorWithCalibratedWhite: 0.0 alpha: 0.4f]; // light mode ???
}

+ (NSColor *) getOverlayBackground {
    return isDarkMode ? [NSColor colorWithCalibratedWhite: 1.0 alpha: 0.5f]: // dark mode
                        [NSColor colorWithCalibratedWhite: 0.0 alpha: 0.2f]; // light mode ???
}


// color: cell
+ (NSColor *) getCellBorderBackground {
    return isDarkMode ? [NSColor colorWithCalibratedWhite: 1.0 alpha: 0.15f]:
                        [NSColor colorWithCalibratedWhite: 0.1 alpha: 0.15f];
}

+ (NSColor *) getCellBackground {
    return isDarkMode ? [NSColor colorWithCalibratedWhite: 0.0 alpha: 0.35f]:
                        [NSColor colorWithCalibratedWhite: 0.0 alpha: 0.05f];
}


// color: other
+ (NSColor *) getTextColor {
    return isDarkMode ? [NSColor colorWithCalibratedWhite: 1.0 alpha: 1.0f]: // dark mode
    [NSColor colorWithCalibratedWhite: 0.0 alpha: 1.0f]; // light mode ???
}

+ (NSColor *) getDividerColor {
    return isDarkMode ? [NSColor colorWithCalibratedWhite: 1.0 alpha: 0.5f]: // dark mode
    [NSColor colorWithCalibratedWhite: 0.0 alpha: 0.5f]; // light mode ???
}





#pragma mark - ICONS
// Default size: 64x64

+ (NSBezierPath *) getPathForGridFourIcon {
    NSBezierPath* gridFourPath = NSBezierPath.bezierPath;
    [gridFourPath moveToPoint: NSMakePoint(20, 24)];
    [gridFourPath lineToPoint: NSMakePoint(8, 24)];
    [gridFourPath curveToPoint: NSMakePoint(4, 20) controlPoint1: NSMakePoint(5.79, 24) controlPoint2: NSMakePoint(4, 22.21)];
    [gridFourPath lineToPoint: NSMakePoint(4, 8)];
    [gridFourPath curveToPoint: NSMakePoint(8, 4) controlPoint1: NSMakePoint(4, 5.79) controlPoint2: NSMakePoint(5.79, 4)];
    [gridFourPath lineToPoint: NSMakePoint(20, 4)];
    [gridFourPath curveToPoint: NSMakePoint(24, 8) controlPoint1: NSMakePoint(22.21, 4) controlPoint2: NSMakePoint(24, 5.79)];
    [gridFourPath lineToPoint: NSMakePoint(24, 20)];
    [gridFourPath curveToPoint: NSMakePoint(20, 24) controlPoint1: NSMakePoint(24, 22.21) controlPoint2: NSMakePoint(22.21, 24)];
    [gridFourPath closePath];
    [gridFourPath moveToPoint: NSMakePoint(28, 22)];
    [gridFourPath lineToPoint: NSMakePoint(28, 6)];
    [gridFourPath curveToPoint: NSMakePoint(22, 0) controlPoint1: NSMakePoint(28, 2.69) controlPoint2: NSMakePoint(25.31, 0)];
    [gridFourPath lineToPoint: NSMakePoint(6, 0)];
    [gridFourPath curveToPoint: NSMakePoint(0, 6) controlPoint1: NSMakePoint(2.69, 0) controlPoint2: NSMakePoint(0, 2.69)];
    [gridFourPath lineToPoint: NSMakePoint(0, 22)];
    [gridFourPath curveToPoint: NSMakePoint(6, 28) controlPoint1: NSMakePoint(0, 25.31) controlPoint2: NSMakePoint(2.69, 28)];
    [gridFourPath lineToPoint: NSMakePoint(22, 28)];
    [gridFourPath curveToPoint: NSMakePoint(28, 22) controlPoint1: NSMakePoint(25.31, 28) controlPoint2: NSMakePoint(28, 25.31)];
    [gridFourPath closePath];
    [gridFourPath moveToPoint: NSMakePoint(56, 24)];
    [gridFourPath lineToPoint: NSMakePoint(44, 24)];
    [gridFourPath curveToPoint: NSMakePoint(40, 20) controlPoint1: NSMakePoint(41.79, 24) controlPoint2: NSMakePoint(40, 22.21)];
    [gridFourPath lineToPoint: NSMakePoint(40, 8)];
    [gridFourPath curveToPoint: NSMakePoint(44, 4) controlPoint1: NSMakePoint(40, 5.79) controlPoint2: NSMakePoint(41.79, 4)];
    [gridFourPath lineToPoint: NSMakePoint(56, 4)];
    [gridFourPath curveToPoint: NSMakePoint(60, 8) controlPoint1: NSMakePoint(58.21, 4) controlPoint2: NSMakePoint(60, 5.79)];
    [gridFourPath lineToPoint: NSMakePoint(60, 20)];
    [gridFourPath curveToPoint: NSMakePoint(56, 24) controlPoint1: NSMakePoint(60, 22.21) controlPoint2: NSMakePoint(58.21, 24)];
    [gridFourPath closePath];
    [gridFourPath moveToPoint: NSMakePoint(64, 22)];
    [gridFourPath lineToPoint: NSMakePoint(64, 6)];
    [gridFourPath curveToPoint: NSMakePoint(58, 0) controlPoint1: NSMakePoint(64, 2.69) controlPoint2: NSMakePoint(61.31, 0)];
    [gridFourPath lineToPoint: NSMakePoint(42, 0)];
    [gridFourPath curveToPoint: NSMakePoint(36, 6) controlPoint1: NSMakePoint(38.69, 0) controlPoint2: NSMakePoint(36, 2.69)];
    [gridFourPath lineToPoint: NSMakePoint(36, 22)];
    [gridFourPath curveToPoint: NSMakePoint(42, 28) controlPoint1: NSMakePoint(36, 25.31) controlPoint2: NSMakePoint(38.69, 28)];
    [gridFourPath lineToPoint: NSMakePoint(58, 28)];
    [gridFourPath curveToPoint: NSMakePoint(64, 22) controlPoint1: NSMakePoint(61.31, 28) controlPoint2: NSMakePoint(64, 25.31)];
    [gridFourPath closePath];
    [gridFourPath moveToPoint: NSMakePoint(56, 60)];
    [gridFourPath lineToPoint: NSMakePoint(44, 60)];
    [gridFourPath curveToPoint: NSMakePoint(40, 56) controlPoint1: NSMakePoint(41.79, 60) controlPoint2: NSMakePoint(40, 58.21)];
    [gridFourPath lineToPoint: NSMakePoint(40, 44)];
    [gridFourPath curveToPoint: NSMakePoint(44, 40) controlPoint1: NSMakePoint(40, 41.79) controlPoint2: NSMakePoint(41.79, 40)];
    [gridFourPath lineToPoint: NSMakePoint(56, 40)];
    [gridFourPath curveToPoint: NSMakePoint(60, 44) controlPoint1: NSMakePoint(58.21, 40) controlPoint2: NSMakePoint(60, 41.79)];
    [gridFourPath lineToPoint: NSMakePoint(60, 56)];
    [gridFourPath curveToPoint: NSMakePoint(56, 60) controlPoint1: NSMakePoint(60, 58.21) controlPoint2: NSMakePoint(58.21, 60)];
    [gridFourPath closePath];
    [gridFourPath moveToPoint: NSMakePoint(64, 58)];
    [gridFourPath lineToPoint: NSMakePoint(64, 42)];
    [gridFourPath curveToPoint: NSMakePoint(58, 36) controlPoint1: NSMakePoint(64, 38.69) controlPoint2: NSMakePoint(61.31, 36)];
    [gridFourPath lineToPoint: NSMakePoint(42, 36)];
    [gridFourPath curveToPoint: NSMakePoint(36, 42) controlPoint1: NSMakePoint(38.69, 36) controlPoint2: NSMakePoint(36, 38.69)];
    [gridFourPath lineToPoint: NSMakePoint(36, 58)];
    [gridFourPath curveToPoint: NSMakePoint(42, 64) controlPoint1: NSMakePoint(36, 61.31) controlPoint2: NSMakePoint(38.69, 64)];
    [gridFourPath lineToPoint: NSMakePoint(58, 64)];
    [gridFourPath curveToPoint: NSMakePoint(64, 58) controlPoint1: NSMakePoint(61.31, 64) controlPoint2: NSMakePoint(64, 61.31)];
    [gridFourPath closePath];
    [gridFourPath moveToPoint: NSMakePoint(20, 60)];
    [gridFourPath lineToPoint: NSMakePoint(8, 60)];
    [gridFourPath curveToPoint: NSMakePoint(4, 56) controlPoint1: NSMakePoint(5.79, 60) controlPoint2: NSMakePoint(4, 58.21)];
    [gridFourPath lineToPoint: NSMakePoint(4, 44)];
    [gridFourPath curveToPoint: NSMakePoint(8, 40) controlPoint1: NSMakePoint(4, 41.79) controlPoint2: NSMakePoint(5.79, 40)];
    [gridFourPath lineToPoint: NSMakePoint(20, 40)];
    [gridFourPath curveToPoint: NSMakePoint(24, 44) controlPoint1: NSMakePoint(22.21, 40) controlPoint2: NSMakePoint(24, 41.79)];
    [gridFourPath lineToPoint: NSMakePoint(24, 56)];
    [gridFourPath curveToPoint: NSMakePoint(20, 60) controlPoint1: NSMakePoint(24, 58.21) controlPoint2: NSMakePoint(22.21, 60)];
    [gridFourPath closePath];
    [gridFourPath moveToPoint: NSMakePoint(28, 58)];
    [gridFourPath lineToPoint: NSMakePoint(28, 42)];
    [gridFourPath curveToPoint: NSMakePoint(22, 36) controlPoint1: NSMakePoint(28, 38.69) controlPoint2: NSMakePoint(25.31, 36)];
    [gridFourPath lineToPoint: NSMakePoint(6, 36)];
    [gridFourPath curveToPoint: NSMakePoint(0, 42) controlPoint1: NSMakePoint(2.69, 36) controlPoint2: NSMakePoint(0, 38.69)];
    [gridFourPath lineToPoint: NSMakePoint(0, 58)];
    [gridFourPath curveToPoint: NSMakePoint(6, 64) controlPoint1: NSMakePoint(0, 61.31) controlPoint2: NSMakePoint(2.69, 64)];
    [gridFourPath lineToPoint: NSMakePoint(22, 64)];
    [gridFourPath curveToPoint: NSMakePoint(28, 58) controlPoint1: NSMakePoint(25.31, 64) controlPoint2: NSMakePoint(28, 61.31)];
    [gridFourPath closePath];
    return gridFourPath;
}

+ (NSBezierPath *) getPathForGridNineIcon {
    NSBezierPath* gridNinePath = NSBezierPath.bezierPath;
    [gridNinePath moveToPoint: NSMakePoint(10, 60)];
    [gridNinePath curveToPoint: NSMakePoint(12, 58) controlPoint1: NSMakePoint(11.1, 60) controlPoint2: NSMakePoint(12, 59.1)];
    [gridNinePath lineToPoint: NSMakePoint(12, 54)];
    [gridNinePath curveToPoint: NSMakePoint(10, 52) controlPoint1: NSMakePoint(12, 52.9) controlPoint2: NSMakePoint(11.1, 52)];
    [gridNinePath lineToPoint: NSMakePoint(6, 52)];
    [gridNinePath curveToPoint: NSMakePoint(4, 54) controlPoint1: NSMakePoint(4.9, 52) controlPoint2: NSMakePoint(4, 52.9)];
    [gridNinePath lineToPoint: NSMakePoint(4, 58)];
    [gridNinePath curveToPoint: NSMakePoint(6, 60) controlPoint1: NSMakePoint(4, 59.1) controlPoint2: NSMakePoint(4.9, 60)];
    [gridNinePath lineToPoint: NSMakePoint(10, 60)];
    [gridNinePath closePath];
    [gridNinePath moveToPoint: NSMakePoint(10, 64)];
    [gridNinePath lineToPoint: NSMakePoint(6, 64)];
    [gridNinePath curveToPoint: NSMakePoint(0, 58) controlPoint1: NSMakePoint(2.69, 64) controlPoint2: NSMakePoint(0, 61.31)];
    [gridNinePath lineToPoint: NSMakePoint(0, 54)];
    [gridNinePath curveToPoint: NSMakePoint(6, 48) controlPoint1: NSMakePoint(0, 50.69) controlPoint2: NSMakePoint(2.69, 48)];
    [gridNinePath lineToPoint: NSMakePoint(10, 48)];
    [gridNinePath curveToPoint: NSMakePoint(16, 54) controlPoint1: NSMakePoint(13.31, 48) controlPoint2: NSMakePoint(16, 50.69)];
    [gridNinePath lineToPoint: NSMakePoint(16, 58)];
    [gridNinePath curveToPoint: NSMakePoint(10, 64) controlPoint1: NSMakePoint(16, 61.31) controlPoint2: NSMakePoint(13.31, 64)];
    [gridNinePath lineToPoint: NSMakePoint(10, 64)];
    [gridNinePath closePath];
    [gridNinePath moveToPoint: NSMakePoint(34, 60)];
    [gridNinePath curveToPoint: NSMakePoint(36, 58) controlPoint1: NSMakePoint(35.1, 60) controlPoint2: NSMakePoint(36, 59.1)];
    [gridNinePath lineToPoint: NSMakePoint(36, 54)];
    [gridNinePath curveToPoint: NSMakePoint(34, 52) controlPoint1: NSMakePoint(36, 52.9) controlPoint2: NSMakePoint(35.1, 52)];
    [gridNinePath lineToPoint: NSMakePoint(30, 52)];
    [gridNinePath curveToPoint: NSMakePoint(28, 54) controlPoint1: NSMakePoint(28.9, 52) controlPoint2: NSMakePoint(28, 52.9)];
    [gridNinePath lineToPoint: NSMakePoint(28, 58)];
    [gridNinePath curveToPoint: NSMakePoint(30, 60) controlPoint1: NSMakePoint(28, 59.1) controlPoint2: NSMakePoint(28.9, 60)];
    [gridNinePath lineToPoint: NSMakePoint(34, 60)];
    [gridNinePath closePath];
    [gridNinePath moveToPoint: NSMakePoint(34, 64)];
    [gridNinePath lineToPoint: NSMakePoint(30, 64)];
    [gridNinePath curveToPoint: NSMakePoint(24, 58) controlPoint1: NSMakePoint(26.69, 64) controlPoint2: NSMakePoint(24, 61.31)];
    [gridNinePath lineToPoint: NSMakePoint(24, 54)];
    [gridNinePath curveToPoint: NSMakePoint(30, 48) controlPoint1: NSMakePoint(24, 50.69) controlPoint2: NSMakePoint(26.69, 48)];
    [gridNinePath lineToPoint: NSMakePoint(34, 48)];
    [gridNinePath curveToPoint: NSMakePoint(40, 54) controlPoint1: NSMakePoint(37.31, 48) controlPoint2: NSMakePoint(40, 50.69)];
    [gridNinePath lineToPoint: NSMakePoint(40, 58)];
    [gridNinePath curveToPoint: NSMakePoint(34, 64) controlPoint1: NSMakePoint(40, 61.31) controlPoint2: NSMakePoint(37.31, 64)];
    [gridNinePath lineToPoint: NSMakePoint(34, 64)];
    [gridNinePath closePath];
    [gridNinePath moveToPoint: NSMakePoint(58, 60)];
    [gridNinePath curveToPoint: NSMakePoint(60, 58) controlPoint1: NSMakePoint(59.1, 60) controlPoint2: NSMakePoint(60, 59.1)];
    [gridNinePath lineToPoint: NSMakePoint(60, 54)];
    [gridNinePath curveToPoint: NSMakePoint(58, 52) controlPoint1: NSMakePoint(60, 52.9) controlPoint2: NSMakePoint(59.1, 52)];
    [gridNinePath lineToPoint: NSMakePoint(54, 52)];
    [gridNinePath curveToPoint: NSMakePoint(52, 54) controlPoint1: NSMakePoint(52.9, 52) controlPoint2: NSMakePoint(52, 52.9)];
    [gridNinePath lineToPoint: NSMakePoint(52, 58)];
    [gridNinePath curveToPoint: NSMakePoint(54, 60) controlPoint1: NSMakePoint(52, 59.1) controlPoint2: NSMakePoint(52.9, 60)];
    [gridNinePath lineToPoint: NSMakePoint(58, 60)];
    [gridNinePath closePath];
    [gridNinePath moveToPoint: NSMakePoint(58, 64)];
    [gridNinePath lineToPoint: NSMakePoint(54, 64)];
    [gridNinePath curveToPoint: NSMakePoint(48, 58) controlPoint1: NSMakePoint(50.69, 64) controlPoint2: NSMakePoint(48, 61.31)];
    [gridNinePath lineToPoint: NSMakePoint(48, 54)];
    [gridNinePath curveToPoint: NSMakePoint(54, 48) controlPoint1: NSMakePoint(48, 50.69) controlPoint2: NSMakePoint(50.69, 48)];
    [gridNinePath lineToPoint: NSMakePoint(58, 48)];
    [gridNinePath curveToPoint: NSMakePoint(64, 54) controlPoint1: NSMakePoint(61.31, 48) controlPoint2: NSMakePoint(64, 50.69)];
    [gridNinePath lineToPoint: NSMakePoint(64, 58)];
    [gridNinePath curveToPoint: NSMakePoint(58, 64) controlPoint1: NSMakePoint(64, 61.31) controlPoint2: NSMakePoint(61.31, 64)];
    [gridNinePath lineToPoint: NSMakePoint(58, 64)];
    [gridNinePath closePath];
    [gridNinePath moveToPoint: NSMakePoint(58, 36)];
    [gridNinePath curveToPoint: NSMakePoint(60, 34) controlPoint1: NSMakePoint(59.1, 36) controlPoint2: NSMakePoint(60, 35.1)];
    [gridNinePath lineToPoint: NSMakePoint(60, 30)];
    [gridNinePath curveToPoint: NSMakePoint(58, 28) controlPoint1: NSMakePoint(60, 28.9) controlPoint2: NSMakePoint(59.1, 28)];
    [gridNinePath lineToPoint: NSMakePoint(54, 28)];
    [gridNinePath curveToPoint: NSMakePoint(52, 30) controlPoint1: NSMakePoint(52.9, 28) controlPoint2: NSMakePoint(52, 28.9)];
    [gridNinePath lineToPoint: NSMakePoint(52, 34)];
    [gridNinePath curveToPoint: NSMakePoint(54, 36) controlPoint1: NSMakePoint(52, 35.1) controlPoint2: NSMakePoint(52.9, 36)];
    [gridNinePath lineToPoint: NSMakePoint(58, 36)];
    [gridNinePath closePath];
    [gridNinePath moveToPoint: NSMakePoint(58, 40)];
    [gridNinePath lineToPoint: NSMakePoint(54, 40)];
    [gridNinePath curveToPoint: NSMakePoint(48, 34) controlPoint1: NSMakePoint(50.69, 40) controlPoint2: NSMakePoint(48, 37.31)];
    [gridNinePath lineToPoint: NSMakePoint(48, 30)];
    [gridNinePath curveToPoint: NSMakePoint(54, 24) controlPoint1: NSMakePoint(48, 26.69) controlPoint2: NSMakePoint(50.69, 24)];
    [gridNinePath lineToPoint: NSMakePoint(58, 24)];
    [gridNinePath curveToPoint: NSMakePoint(64, 30) controlPoint1: NSMakePoint(61.31, 24) controlPoint2: NSMakePoint(64, 26.69)];
    [gridNinePath lineToPoint: NSMakePoint(64, 34)];
    [gridNinePath curveToPoint: NSMakePoint(58, 40) controlPoint1: NSMakePoint(64, 37.31) controlPoint2: NSMakePoint(61.31, 40)];
    [gridNinePath lineToPoint: NSMakePoint(58, 40)];
    [gridNinePath closePath];
    [gridNinePath moveToPoint: NSMakePoint(34, 36)];
    [gridNinePath curveToPoint: NSMakePoint(36, 34) controlPoint1: NSMakePoint(35.1, 36) controlPoint2: NSMakePoint(36, 35.1)];
    [gridNinePath lineToPoint: NSMakePoint(36, 30)];
    [gridNinePath curveToPoint: NSMakePoint(34, 28) controlPoint1: NSMakePoint(36, 28.9) controlPoint2: NSMakePoint(35.1, 28)];
    [gridNinePath lineToPoint: NSMakePoint(30, 28)];
    [gridNinePath curveToPoint: NSMakePoint(28, 30) controlPoint1: NSMakePoint(28.9, 28) controlPoint2: NSMakePoint(28, 28.9)];
    [gridNinePath lineToPoint: NSMakePoint(28, 34)];
    [gridNinePath curveToPoint: NSMakePoint(30, 36) controlPoint1: NSMakePoint(28, 35.1) controlPoint2: NSMakePoint(28.9, 36)];
    [gridNinePath lineToPoint: NSMakePoint(34, 36)];
    [gridNinePath closePath];
    [gridNinePath moveToPoint: NSMakePoint(34, 40)];
    [gridNinePath lineToPoint: NSMakePoint(30, 40)];
    [gridNinePath curveToPoint: NSMakePoint(24, 34) controlPoint1: NSMakePoint(26.69, 40) controlPoint2: NSMakePoint(24, 37.31)];
    [gridNinePath lineToPoint: NSMakePoint(24, 30)];
    [gridNinePath curveToPoint: NSMakePoint(30, 24) controlPoint1: NSMakePoint(24, 26.69) controlPoint2: NSMakePoint(26.69, 24)];
    [gridNinePath lineToPoint: NSMakePoint(34, 24)];
    [gridNinePath curveToPoint: NSMakePoint(40, 30) controlPoint1: NSMakePoint(37.31, 24) controlPoint2: NSMakePoint(40, 26.69)];
    [gridNinePath lineToPoint: NSMakePoint(40, 34)];
    [gridNinePath curveToPoint: NSMakePoint(34, 40) controlPoint1: NSMakePoint(40, 37.31) controlPoint2: NSMakePoint(37.31, 40)];
    [gridNinePath lineToPoint: NSMakePoint(34, 40)];
    [gridNinePath closePath];
    [gridNinePath moveToPoint: NSMakePoint(10, 36)];
    [gridNinePath curveToPoint: NSMakePoint(12, 34) controlPoint1: NSMakePoint(11.1, 36) controlPoint2: NSMakePoint(12, 35.1)];
    [gridNinePath lineToPoint: NSMakePoint(12, 30)];
    [gridNinePath curveToPoint: NSMakePoint(10, 28) controlPoint1: NSMakePoint(12, 28.9) controlPoint2: NSMakePoint(11.1, 28)];
    [gridNinePath lineToPoint: NSMakePoint(6, 28)];
    [gridNinePath curveToPoint: NSMakePoint(4, 30) controlPoint1: NSMakePoint(4.9, 28) controlPoint2: NSMakePoint(4, 28.9)];
    [gridNinePath lineToPoint: NSMakePoint(4, 34)];
    [gridNinePath curveToPoint: NSMakePoint(6, 36) controlPoint1: NSMakePoint(4, 35.1) controlPoint2: NSMakePoint(4.9, 36)];
    [gridNinePath lineToPoint: NSMakePoint(10, 36)];
    [gridNinePath closePath];
    [gridNinePath moveToPoint: NSMakePoint(10, 40)];
    [gridNinePath lineToPoint: NSMakePoint(6, 40)];
    [gridNinePath curveToPoint: NSMakePoint(0, 34) controlPoint1: NSMakePoint(2.69, 40) controlPoint2: NSMakePoint(0, 37.31)];
    [gridNinePath lineToPoint: NSMakePoint(0, 30)];
    [gridNinePath curveToPoint: NSMakePoint(6, 24) controlPoint1: NSMakePoint(0, 26.69) controlPoint2: NSMakePoint(2.69, 24)];
    [gridNinePath lineToPoint: NSMakePoint(10, 24)];
    [gridNinePath curveToPoint: NSMakePoint(16, 30) controlPoint1: NSMakePoint(13.31, 24) controlPoint2: NSMakePoint(16, 26.69)];
    [gridNinePath lineToPoint: NSMakePoint(16, 34)];
    [gridNinePath curveToPoint: NSMakePoint(10, 40) controlPoint1: NSMakePoint(16, 37.31) controlPoint2: NSMakePoint(13.31, 40)];
    [gridNinePath lineToPoint: NSMakePoint(10, 40)];
    [gridNinePath closePath];
    [gridNinePath moveToPoint: NSMakePoint(10, 12)];
    [gridNinePath curveToPoint: NSMakePoint(12, 10) controlPoint1: NSMakePoint(11.1, 12) controlPoint2: NSMakePoint(12, 11.1)];
    [gridNinePath lineToPoint: NSMakePoint(12, 6)];
    [gridNinePath curveToPoint: NSMakePoint(10, 4) controlPoint1: NSMakePoint(12, 4.9) controlPoint2: NSMakePoint(11.1, 4)];
    [gridNinePath lineToPoint: NSMakePoint(6, 4)];
    [gridNinePath curveToPoint: NSMakePoint(4, 6) controlPoint1: NSMakePoint(4.9, 4) controlPoint2: NSMakePoint(4, 4.9)];
    [gridNinePath lineToPoint: NSMakePoint(4, 10)];
    [gridNinePath curveToPoint: NSMakePoint(6, 12) controlPoint1: NSMakePoint(4, 11.1) controlPoint2: NSMakePoint(4.9, 12)];
    [gridNinePath lineToPoint: NSMakePoint(10, 12)];
    [gridNinePath closePath];
    [gridNinePath moveToPoint: NSMakePoint(10, 16)];
    [gridNinePath lineToPoint: NSMakePoint(6, 16)];
    [gridNinePath curveToPoint: NSMakePoint(0, 10) controlPoint1: NSMakePoint(2.69, 16) controlPoint2: NSMakePoint(0, 13.31)];
    [gridNinePath lineToPoint: NSMakePoint(0, 6)];
    [gridNinePath curveToPoint: NSMakePoint(6, 0) controlPoint1: NSMakePoint(0, 2.69) controlPoint2: NSMakePoint(2.69, 0)];
    [gridNinePath lineToPoint: NSMakePoint(10, 0)];
    [gridNinePath curveToPoint: NSMakePoint(16, 6) controlPoint1: NSMakePoint(13.31, 0) controlPoint2: NSMakePoint(16, 2.69)];
    [gridNinePath lineToPoint: NSMakePoint(16, 10)];
    [gridNinePath curveToPoint: NSMakePoint(10, 16) controlPoint1: NSMakePoint(16, 13.31) controlPoint2: NSMakePoint(13.31, 16)];
    [gridNinePath lineToPoint: NSMakePoint(10, 16)];
    [gridNinePath closePath];
    [gridNinePath moveToPoint: NSMakePoint(34, 12)];
    [gridNinePath curveToPoint: NSMakePoint(36, 10) controlPoint1: NSMakePoint(35.1, 12) controlPoint2: NSMakePoint(36, 11.1)];
    [gridNinePath lineToPoint: NSMakePoint(36, 6)];
    [gridNinePath curveToPoint: NSMakePoint(34, 4) controlPoint1: NSMakePoint(36, 4.9) controlPoint2: NSMakePoint(35.1, 4)];
    [gridNinePath lineToPoint: NSMakePoint(30, 4)];
    [gridNinePath curveToPoint: NSMakePoint(28, 6) controlPoint1: NSMakePoint(28.9, 4) controlPoint2: NSMakePoint(28, 4.9)];
    [gridNinePath lineToPoint: NSMakePoint(28, 10)];
    [gridNinePath curveToPoint: NSMakePoint(30, 12) controlPoint1: NSMakePoint(28, 11.1) controlPoint2: NSMakePoint(28.9, 12)];
    [gridNinePath lineToPoint: NSMakePoint(34, 12)];
    [gridNinePath closePath];
    [gridNinePath moveToPoint: NSMakePoint(34, 16)];
    [gridNinePath lineToPoint: NSMakePoint(30, 16)];
    [gridNinePath curveToPoint: NSMakePoint(24, 10) controlPoint1: NSMakePoint(26.69, 16) controlPoint2: NSMakePoint(24, 13.31)];
    [gridNinePath lineToPoint: NSMakePoint(24, 6)];
    [gridNinePath curveToPoint: NSMakePoint(30, 0) controlPoint1: NSMakePoint(24, 2.69) controlPoint2: NSMakePoint(26.69, 0)];
    [gridNinePath lineToPoint: NSMakePoint(34, 0)];
    [gridNinePath curveToPoint: NSMakePoint(40, 6) controlPoint1: NSMakePoint(37.31, 0) controlPoint2: NSMakePoint(40, 2.69)];
    [gridNinePath lineToPoint: NSMakePoint(40, 10)];
    [gridNinePath curveToPoint: NSMakePoint(34, 16) controlPoint1: NSMakePoint(40, 13.31) controlPoint2: NSMakePoint(37.31, 16)];
    [gridNinePath lineToPoint: NSMakePoint(34, 16)];
    [gridNinePath closePath];
    [gridNinePath moveToPoint: NSMakePoint(58, 12)];
    [gridNinePath curveToPoint: NSMakePoint(60, 10) controlPoint1: NSMakePoint(59.1, 12) controlPoint2: NSMakePoint(60, 11.1)];
    [gridNinePath lineToPoint: NSMakePoint(60, 6)];
    [gridNinePath curveToPoint: NSMakePoint(58, 4) controlPoint1: NSMakePoint(60, 4.9) controlPoint2: NSMakePoint(59.1, 4)];
    [gridNinePath lineToPoint: NSMakePoint(54, 4)];
    [gridNinePath curveToPoint: NSMakePoint(52, 6) controlPoint1: NSMakePoint(52.9, 4) controlPoint2: NSMakePoint(52, 4.9)];
    [gridNinePath lineToPoint: NSMakePoint(52, 10)];
    [gridNinePath curveToPoint: NSMakePoint(54, 12) controlPoint1: NSMakePoint(52, 11.1) controlPoint2: NSMakePoint(52.9, 12)];
    [gridNinePath lineToPoint: NSMakePoint(58, 12)];
    [gridNinePath closePath];
    [gridNinePath moveToPoint: NSMakePoint(58, 16)];
    [gridNinePath lineToPoint: NSMakePoint(54, 16)];
    [gridNinePath curveToPoint: NSMakePoint(48, 10) controlPoint1: NSMakePoint(50.69, 16) controlPoint2: NSMakePoint(48, 13.31)];
    [gridNinePath lineToPoint: NSMakePoint(48, 6)];
    [gridNinePath curveToPoint: NSMakePoint(54, 0) controlPoint1: NSMakePoint(48, 2.69) controlPoint2: NSMakePoint(50.69, 0)];
    [gridNinePath lineToPoint: NSMakePoint(58, 0)];
    [gridNinePath curveToPoint: NSMakePoint(64, 6) controlPoint1: NSMakePoint(61.31, 0) controlPoint2: NSMakePoint(64, 2.69)];
    [gridNinePath lineToPoint: NSMakePoint(64, 10)];
    [gridNinePath curveToPoint: NSMakePoint(58, 16) controlPoint1: NSMakePoint(64, 13.31) controlPoint2: NSMakePoint(61.31, 16)];
    [gridNinePath lineToPoint: NSMakePoint(58, 16)];
    [gridNinePath closePath];
    return gridNinePath;
}

+ (NSBezierPath *) getPathForGearsIcon {
    NSBezierPath* gearsPath = NSBezierPath.bezierPath;
    [gearsPath moveToPoint: NSMakePoint(32, 38)];
    [gearsPath curveToPoint: NSMakePoint(26, 32) controlPoint1: NSMakePoint(28.69, 38) controlPoint2: NSMakePoint(26, 35.31)];
    [gearsPath curveToPoint: NSMakePoint(32, 26) controlPoint1: NSMakePoint(26, 28.69) controlPoint2: NSMakePoint(28.69, 26)];
    [gearsPath curveToPoint: NSMakePoint(38, 32) controlPoint1: NSMakePoint(35.31, 26) controlPoint2: NSMakePoint(38, 28.69)];
    [gearsPath curveToPoint: NSMakePoint(32, 38) controlPoint1: NSMakePoint(38, 35.31) controlPoint2: NSMakePoint(35.31, 38)];
    [gearsPath closePath];
    [gearsPath moveToPoint: NSMakePoint(42, 32)];
    [gearsPath curveToPoint: NSMakePoint(32, 22) controlPoint1: NSMakePoint(42, 26.48) controlPoint2: NSMakePoint(37.52, 22)];
    [gearsPath curveToPoint: NSMakePoint(22, 32) controlPoint1: NSMakePoint(26.48, 22) controlPoint2: NSMakePoint(22, 26.48)];
    [gearsPath curveToPoint: NSMakePoint(32, 42) controlPoint1: NSMakePoint(22, 37.52) controlPoint2: NSMakePoint(26.48, 42)];
    [gearsPath curveToPoint: NSMakePoint(42, 32) controlPoint1: NSMakePoint(37.52, 42) controlPoint2: NSMakePoint(42, 37.52)];
    [gearsPath closePath];
    [gearsPath moveToPoint: NSMakePoint(40.86, 57.55)];
    [gearsPath lineToPoint: NSMakePoint(41.01, 57.08)];
    [gearsPath curveToPoint: NSMakePoint(43.37, 56.11) controlPoint1: NSMakePoint(41.82, 56.79) controlPoint2: NSMakePoint(42.6, 56.47)];
    [gearsPath lineToPoint: NSMakePoint(43.8, 56.33)];
    [gearsPath curveToPoint: NSMakePoint(48.34, 57.97) controlPoint1: NSMakePoint(45.07, 57.39) controlPoint2: NSMakePoint(46.66, 57.97)];
    [gearsPath curveToPoint: NSMakePoint(53.37, 55.88) controlPoint1: NSMakePoint(50.24, 57.97) controlPoint2: NSMakePoint(52.03, 57.23)];
    [gearsPath lineToPoint: NSMakePoint(55.88, 53.37)];
    [gearsPath curveToPoint: NSMakePoint(57.97, 48.34) controlPoint1: NSMakePoint(57.23, 52.03) controlPoint2: NSMakePoint(57.97, 50.24)];
    [gearsPath curveToPoint: NSMakePoint(56.33, 43.8) controlPoint1: NSMakePoint(57.97, 46.66) controlPoint2: NSMakePoint(57.39, 45.07)];
    [gearsPath lineToPoint: NSMakePoint(56.11, 43.37)];
    [gearsPath curveToPoint: NSMakePoint(57.08, 41.01) controlPoint1: NSMakePoint(56.47, 42.6) controlPoint2: NSMakePoint(56.79, 41.81)];
    [gearsPath lineToPoint: NSMakePoint(57.55, 40.86)];
    [gearsPath curveToPoint: NSMakePoint(64, 33.78) controlPoint1: NSMakePoint(61.16, 40.52) controlPoint2: NSMakePoint(64, 37.48)];
    [gearsPath lineToPoint: NSMakePoint(64, 30.22)];
    [gearsPath curveToPoint: NSMakePoint(57.55, 23.14) controlPoint1: NSMakePoint(64, 26.52) controlPoint2: NSMakePoint(61.16, 23.48)];
    [gearsPath lineToPoint: NSMakePoint(57.08, 22.99)];
    [gearsPath curveToPoint: NSMakePoint(56.11, 20.63) controlPoint1: NSMakePoint(56.79, 22.18) controlPoint2: NSMakePoint(56.47, 21.4)];
    [gearsPath lineToPoint: NSMakePoint(56.33, 20.2)];
    [gearsPath curveToPoint: NSMakePoint(57.97, 15.66) controlPoint1: NSMakePoint(57.39, 18.93) controlPoint2: NSMakePoint(57.97, 17.34)];
    [gearsPath curveToPoint: NSMakePoint(55.88, 10.63) controlPoint1: NSMakePoint(57.97, 13.76) controlPoint2: NSMakePoint(57.23, 11.97)];
    [gearsPath lineToPoint: NSMakePoint(53.37, 8.11)];
    [gearsPath curveToPoint: NSMakePoint(48.34, 6.03) controlPoint1: NSMakePoint(52.03, 6.77) controlPoint2: NSMakePoint(50.24, 6.03)];
    [gearsPath curveToPoint: NSMakePoint(43.8, 7.67) controlPoint1: NSMakePoint(46.66, 6.03) controlPoint2: NSMakePoint(45.08, 6.61)];
    [gearsPath lineToPoint: NSMakePoint(43.36, 7.89)];
    [gearsPath curveToPoint: NSMakePoint(41.02, 6.92) controlPoint1: NSMakePoint(42.6, 7.53) controlPoint2: NSMakePoint(41.82, 7.21)];
    [gearsPath lineToPoint: NSMakePoint(40.86, 6.43)];
    [gearsPath curveToPoint: NSMakePoint(33.78, 0) controlPoint1: NSMakePoint(40.52, 2.83) controlPoint2: NSMakePoint(37.47, 0)];
    [gearsPath lineToPoint: NSMakePoint(30.22, 0)];
    [gearsPath curveToPoint: NSMakePoint(23.14, 6.43) controlPoint1: NSMakePoint(26.53, 0) controlPoint2: NSMakePoint(23.48, 2.83)];
    [gearsPath lineToPoint: NSMakePoint(22.98, 6.92)];
    [gearsPath curveToPoint: NSMakePoint(20.64, 7.89) controlPoint1: NSMakePoint(22.18, 7.21) controlPoint2: NSMakePoint(21.4, 7.53)];
    [gearsPath lineToPoint: NSMakePoint(20.19, 7.66)];
    [gearsPath curveToPoint: NSMakePoint(15.66, 6.03) controlPoint1: NSMakePoint(18.92, 6.61) controlPoint2: NSMakePoint(17.33, 6.03)];
    [gearsPath curveToPoint: NSMakePoint(10.63, 8.11) controlPoint1: NSMakePoint(13.76, 6.03) controlPoint2: NSMakePoint(11.97, 6.77)];
    [gearsPath lineToPoint: NSMakePoint(8.12, 10.63)];
    [gearsPath curveToPoint: NSMakePoint(6.03, 15.66) controlPoint1: NSMakePoint(6.77, 11.97) controlPoint2: NSMakePoint(6.03, 13.76)];
    [gearsPath curveToPoint: NSMakePoint(7.66, 20.19) controlPoint1: NSMakePoint(6.03, 17.33) controlPoint2: NSMakePoint(6.61, 18.91)];
    [gearsPath lineToPoint: NSMakePoint(7.89, 20.64)];
    [gearsPath curveToPoint: NSMakePoint(6.92, 22.98) controlPoint1: NSMakePoint(7.53, 21.4) controlPoint2: NSMakePoint(7.21, 22.18)];
    [gearsPath lineToPoint: NSMakePoint(6.44, 23.14)];
    [gearsPath curveToPoint: NSMakePoint(0, 30.22) controlPoint1: NSMakePoint(2.83, 23.48) controlPoint2: NSMakePoint(0, 26.53)];
    [gearsPath lineToPoint: NSMakePoint(0, 33.78)];
    [gearsPath curveToPoint: NSMakePoint(6.44, 40.86) controlPoint1: NSMakePoint(0, 37.47) controlPoint2: NSMakePoint(2.83, 40.52)];
    [gearsPath lineToPoint: NSMakePoint(6.92, 41.02)];
    [gearsPath curveToPoint: NSMakePoint(7.89, 43.36) controlPoint1: NSMakePoint(7.21, 41.82) controlPoint2: NSMakePoint(7.53, 42.6)];
    [gearsPath lineToPoint: NSMakePoint(7.66, 43.81)];
    [gearsPath curveToPoint: NSMakePoint(6.03, 48.34) controlPoint1: NSMakePoint(6.61, 45.08) controlPoint2: NSMakePoint(6.03, 46.67)];
    [gearsPath curveToPoint: NSMakePoint(8.12, 53.37) controlPoint1: NSMakePoint(6.03, 50.24) controlPoint2: NSMakePoint(6.77, 52.03)];
    [gearsPath lineToPoint: NSMakePoint(10.63, 55.89)];
    [gearsPath curveToPoint: NSMakePoint(15.66, 57.97) controlPoint1: NSMakePoint(11.97, 57.23) controlPoint2: NSMakePoint(13.76, 57.97)];
    [gearsPath curveToPoint: NSMakePoint(20.19, 56.34) controlPoint1: NSMakePoint(17.33, 57.97) controlPoint2: NSMakePoint(18.91, 57.39)];
    [gearsPath lineToPoint: NSMakePoint(20.64, 56.11)];
    [gearsPath curveToPoint: NSMakePoint(22.99, 57.08) controlPoint1: NSMakePoint(21.4, 56.47) controlPoint2: NSMakePoint(22.19, 56.8)];
    [gearsPath lineToPoint: NSMakePoint(23.14, 57.55)];
    [gearsPath curveToPoint: NSMakePoint(30.22, 64) controlPoint1: NSMakePoint(23.47, 61.16) controlPoint2: NSMakePoint(26.52, 64)];
    [gearsPath lineToPoint: NSMakePoint(33.78, 64)];
    [gearsPath curveToPoint: NSMakePoint(40.86, 57.55) controlPoint1: NSMakePoint(37.48, 64) controlPoint2: NSMakePoint(40.52, 61.16)];
    [gearsPath closePath];
    [gearsPath moveToPoint: NSMakePoint(33.75, 60.01)];
    [gearsPath lineToPoint: NSMakePoint(30.25, 60.01)];
    [gearsPath curveToPoint: NSMakePoint(26.75, 56.51) controlPoint1: NSMakePoint(28.32, 60.01) controlPoint2: NSMakePoint(26.75, 58.44)];
    [gearsPath lineToPoint: NSMakePoint(25.8, 54.25)];
    [gearsPath curveToPoint: NSMakePoint(20.67, 52.13) controlPoint1: NSMakePoint(23.99, 53.74) controlPoint2: NSMakePoint(22.27, 53.03)];
    [gearsPath lineToPoint: NSMakePoint(18.17, 53.37)];
    [gearsPath curveToPoint: NSMakePoint(15.91, 54.07) controlPoint1: NSMakePoint(17.48, 54.06) controlPoint2: NSMakePoint(16.81, 54.07)];
    [gearsPath curveToPoint: NSMakePoint(13.43, 53.04) controlPoint1: NSMakePoint(15.01, 54.07) controlPoint2: NSMakePoint(14.12, 53.72)];
    [gearsPath lineToPoint: NSMakePoint(10.96, 50.57)];
    [gearsPath curveToPoint: NSMakePoint(10.96, 45.61) controlPoint1: NSMakePoint(9.59, 49.2) controlPoint2: NSMakePoint(9.59, 46.98)];
    [gearsPath lineToPoint: NSMakePoint(12.18, 43.16)];
    [gearsPath curveToPoint: NSMakePoint(10.1, 38.13) controlPoint1: NSMakePoint(11.29, 41.59) controlPoint2: NSMakePoint(10.6, 39.9)];
    [gearsPath lineToPoint: NSMakePoint(7.49, 37.25)];
    [gearsPath curveToPoint: NSMakePoint(3.99, 33.75) controlPoint1: NSMakePoint(5.56, 37.25) controlPoint2: NSMakePoint(3.99, 35.68)];
    [gearsPath lineToPoint: NSMakePoint(3.99, 30.25)];
    [gearsPath curveToPoint: NSMakePoint(7.49, 26.75) controlPoint1: NSMakePoint(3.99, 28.31) controlPoint2: NSMakePoint(5.56, 26.75)];
    [gearsPath lineToPoint: NSMakePoint(10.1, 25.87)];
    [gearsPath curveToPoint: NSMakePoint(12.18, 20.84) controlPoint1: NSMakePoint(10.6, 24.1) controlPoint2: NSMakePoint(11.3, 22.41)];
    [gearsPath lineToPoint: NSMakePoint(10.96, 18.38)];
    [gearsPath curveToPoint: NSMakePoint(10.96, 13.43) controlPoint1: NSMakePoint(9.59, 17.02) controlPoint2: NSMakePoint(9.59, 14.8)];
    [gearsPath lineToPoint: NSMakePoint(13.43, 10.96)];
    [gearsPath curveToPoint: NSMakePoint(15.91, 9.93) controlPoint1: NSMakePoint(14.12, 10.27) controlPoint2: NSMakePoint(15.01, 9.93)];
    [gearsPath curveToPoint: NSMakePoint(18.38, 10.96) controlPoint1: NSMakePoint(16.81, 9.93) controlPoint2: NSMakePoint(17.7, 10.27)];
    [gearsPath lineToPoint: NSMakePoint(20.84, 12.18)];
    [gearsPath curveToPoint: NSMakePoint(25.87, 10.1) controlPoint1: NSMakePoint(22.41, 11.29) controlPoint2: NSMakePoint(24.1, 10.6)];
    [gearsPath lineToPoint: NSMakePoint(26.75, 7.49)];
    [gearsPath curveToPoint: NSMakePoint(30.25, 3.99) controlPoint1: NSMakePoint(26.75, 5.56) controlPoint2: NSMakePoint(28.32, 3.99)];
    [gearsPath lineToPoint: NSMakePoint(33.75, 3.99)];
    [gearsPath curveToPoint: NSMakePoint(37.25, 7.49) controlPoint1: NSMakePoint(35.68, 3.99) controlPoint2: NSMakePoint(37.25, 5.56)];
    [gearsPath lineToPoint: NSMakePoint(38.13, 10.1)];
    [gearsPath curveToPoint: NSMakePoint(43.18, 12.19) controlPoint1: NSMakePoint(39.91, 10.6) controlPoint2: NSMakePoint(41.6, 11.3)];
    [gearsPath lineToPoint: NSMakePoint(45.62, 10.96)];
    [gearsPath curveToPoint: NSMakePoint(48.09, 9.93) controlPoint1: NSMakePoint(46.3, 10.27) controlPoint2: NSMakePoint(47.19, 9.93)];
    [gearsPath curveToPoint: NSMakePoint(50.57, 10.96) controlPoint1: NSMakePoint(48.99, 9.93) controlPoint2: NSMakePoint(49.88, 10.27)];
    [gearsPath lineToPoint: NSMakePoint(53.04, 13.43)];
    [gearsPath curveToPoint: NSMakePoint(53.04, 18.38) controlPoint1: NSMakePoint(54.41, 14.8) controlPoint2: NSMakePoint(54.41, 17.02)];
    [gearsPath lineToPoint: NSMakePoint(51.81, 20.82)];
    [gearsPath curveToPoint: NSMakePoint(53.9, 25.89) controlPoint1: NSMakePoint(52.7, 22.4) controlPoint2: NSMakePoint(53.4, 24.1)];
    [gearsPath lineToPoint: NSMakePoint(56.51, 26.75)];
    [gearsPath curveToPoint: NSMakePoint(60.01, 30.25) controlPoint1: NSMakePoint(58.44, 26.75) controlPoint2: NSMakePoint(60.01, 28.31)];
    [gearsPath lineToPoint: NSMakePoint(60.01, 33.75)];
    [gearsPath curveToPoint: NSMakePoint(56.51, 37.25) controlPoint1: NSMakePoint(60.01, 35.68) controlPoint2: NSMakePoint(58.44, 37.25)];
    [gearsPath lineToPoint: NSMakePoint(53.9, 38.1)];
    [gearsPath curveToPoint: NSMakePoint(51.81, 43.18) controlPoint1: NSMakePoint(53.41, 39.89) controlPoint2: NSMakePoint(52.7, 41.59)];
    [gearsPath lineToPoint: NSMakePoint(53.04, 45.61)];
    [gearsPath curveToPoint: NSMakePoint(53.04, 50.57) controlPoint1: NSMakePoint(54.41, 46.98) controlPoint2: NSMakePoint(54.41, 49.2)];
    [gearsPath lineToPoint: NSMakePoint(50.57, 53.04)];
    [gearsPath curveToPoint: NSMakePoint(48.34, 54.41) controlPoint1: NSMakePoint(49.88, 53.72) controlPoint2: NSMakePoint(49.25, 54.41)];
    [gearsPath curveToPoint: NSMakePoint(45.62, 53.04) controlPoint1: NSMakePoint(47.43, 54.41) controlPoint2: NSMakePoint(46.3, 53.72)];
    [gearsPath lineToPoint: NSMakePoint(43.18, 51.81)];
    [gearsPath curveToPoint: NSMakePoint(38.11, 53.9) controlPoint1: NSMakePoint(41.6, 52.7) controlPoint2: NSMakePoint(39.9, 53.4)];
    [gearsPath lineToPoint: NSMakePoint(37.25, 56.51)];
    [gearsPath curveToPoint: NSMakePoint(33.75, 60.01) controlPoint1: NSMakePoint(37.25, 58.44) controlPoint2: NSMakePoint(35.68, 60.01)];
    [gearsPath closePath];
    return gearsPath;
}

+ (NSBezierPath *) getPathForQuestionIcon {
    NSBezierPath* questionPath = NSBezierPath.bezierPath;
    [questionPath moveToPoint: NSMakePoint(32, 60)];
    [questionPath curveToPoint: NSMakePoint(4, 32) controlPoint1: NSMakePoint(16.54, 60) controlPoint2: NSMakePoint(4, 47.46)];
    [questionPath curveToPoint: NSMakePoint(32, 4) controlPoint1: NSMakePoint(4, 16.54) controlPoint2: NSMakePoint(16.54, 4)];
    [questionPath curveToPoint: NSMakePoint(60, 32) controlPoint1: NSMakePoint(47.46, 4) controlPoint2: NSMakePoint(60, 16.54)];
    [questionPath curveToPoint: NSMakePoint(32, 60) controlPoint1: NSMakePoint(60, 47.46) controlPoint2: NSMakePoint(47.46, 60)];
    [questionPath closePath];
    [questionPath moveToPoint: NSMakePoint(64, 32)];
    [questionPath curveToPoint: NSMakePoint(32, 0) controlPoint1: NSMakePoint(64, 14.33) controlPoint2: NSMakePoint(49.67, 0)];
    [questionPath curveToPoint: NSMakePoint(0, 32) controlPoint1: NSMakePoint(14.33, 0) controlPoint2: NSMakePoint(0, 14.33)];
    [questionPath curveToPoint: NSMakePoint(32, 64) controlPoint1: NSMakePoint(0, 49.67) controlPoint2: NSMakePoint(14.33, 64)];
    [questionPath curveToPoint: NSMakePoint(64, 32) controlPoint1: NSMakePoint(49.67, 64) controlPoint2: NSMakePoint(64, 49.67)];
    [questionPath closePath];
    [questionPath moveToPoint: NSMakePoint(24.64, 36.66)];
    [questionPath curveToPoint: NSMakePoint(26.15, 36.09) controlPoint1: NSMakePoint(25.05, 36.28) controlPoint2: NSMakePoint(25.56, 36.09)];
    [questionPath curveToPoint: NSMakePoint(28.22, 37.73) controlPoint1: NSMakePoint(27.17, 36.09) controlPoint2: NSMakePoint(27.85, 36.64)];
    [questionPath curveToPoint: NSMakePoint(29.62, 40.11) controlPoint1: NSMakePoint(28.6, 38.78) controlPoint2: NSMakePoint(29.07, 39.57)];
    [questionPath curveToPoint: NSMakePoint(32.21, 40.91) controlPoint1: NSMakePoint(30.18, 40.65) controlPoint2: NSMakePoint(31.04, 40.91)];
    [questionPath curveToPoint: NSMakePoint(34.66, 40.12) controlPoint1: NSMakePoint(33.21, 40.91) controlPoint2: NSMakePoint(34.03, 40.65)];
    [questionPath curveToPoint: NSMakePoint(35.62, 38.15) controlPoint1: NSMakePoint(35.3, 39.58) controlPoint2: NSMakePoint(35.62, 38.93)];
    [questionPath curveToPoint: NSMakePoint(35.3, 37.05) controlPoint1: NSMakePoint(35.62, 37.75) controlPoint2: NSMakePoint(35.51, 37.39)];
    [questionPath curveToPoint: NSMakePoint(34.54, 36.12) controlPoint1: NSMakePoint(35.1, 36.71) controlPoint2: NSMakePoint(34.84, 36.4)];
    [questionPath curveToPoint: NSMakePoint(33.06, 34.9) controlPoint1: NSMakePoint(34.23, 35.85) controlPoint2: NSMakePoint(33.74, 35.44)];
    [questionPath curveToPoint: NSMakePoint(31.2, 33.29) controlPoint1: NSMakePoint(32.28, 34.28) controlPoint2: NSMakePoint(31.66, 33.74)];
    [questionPath curveToPoint: NSMakePoint(30.1, 31.72) controlPoint1: NSMakePoint(30.75, 32.84) controlPoint2: NSMakePoint(30.38, 32.31)];
    [questionPath curveToPoint: NSMakePoint(29.69, 29.6) controlPoint1: NSMakePoint(29.82, 31.12) controlPoint2: NSMakePoint(29.69, 30.42)];
    [questionPath curveToPoint: NSMakePoint(30.25, 28.13) controlPoint1: NSMakePoint(29.69, 28.95) controlPoint2: NSMakePoint(29.88, 28.46)];
    [questionPath curveToPoint: NSMakePoint(31.65, 27.64) controlPoint1: NSMakePoint(30.63, 27.81) controlPoint2: NSMakePoint(31.1, 27.64)];
    [questionPath curveToPoint: NSMakePoint(33.55, 29.15) controlPoint1: NSMakePoint(32.72, 27.64) controlPoint2: NSMakePoint(33.35, 28.14)];
    [questionPath curveToPoint: NSMakePoint(33.82, 30.15) controlPoint1: NSMakePoint(33.67, 29.63) controlPoint2: NSMakePoint(33.76, 29.96)];
    [questionPath curveToPoint: NSMakePoint(34.07, 30.72) controlPoint1: NSMakePoint(33.88, 30.34) controlPoint2: NSMakePoint(33.96, 30.53)];
    [questionPath curveToPoint: NSMakePoint(34.55, 31.34) controlPoint1: NSMakePoint(34.17, 30.9) controlPoint2: NSMakePoint(34.33, 31.11)];
    [questionPath curveToPoint: NSMakePoint(35.42, 32.13) controlPoint1: NSMakePoint(34.77, 31.57) controlPoint2: NSMakePoint(35.06, 31.83)];
    [questionPath curveToPoint: NSMakePoint(38.15, 34.41) controlPoint1: NSMakePoint(36.73, 33.2) controlPoint2: NSMakePoint(37.64, 33.96)];
    [questionPath curveToPoint: NSMakePoint(39.46, 36.02) controlPoint1: NSMakePoint(38.65, 34.86) controlPoint2: NSMakePoint(39.09, 35.39)];
    [questionPath curveToPoint: NSMakePoint(40.01, 38.18) controlPoint1: NSMakePoint(39.83, 36.64) controlPoint2: NSMakePoint(40.01, 37.36)];
    [questionPath curveToPoint: NSMakePoint(39.04, 41.09) controlPoint1: NSMakePoint(40.01, 39.23) controlPoint2: NSMakePoint(39.69, 40.2)];
    [questionPath curveToPoint: NSMakePoint(36.3, 43.2) controlPoint1: NSMakePoint(38.4, 41.98) controlPoint2: NSMakePoint(37.49, 42.69)];
    [questionPath curveToPoint: NSMakePoint(32.21, 43.98) controlPoint1: NSMakePoint(35.12, 43.72) controlPoint2: NSMakePoint(33.76, 43.98)];
    [questionPath curveToPoint: NSMakePoint(27.85, 43.05) controlPoint1: NSMakePoint(30.55, 43.98) controlPoint2: NSMakePoint(29.09, 43.67)];
    [questionPath curveToPoint: NSMakePoint(25, 40.7) controlPoint1: NSMakePoint(26.6, 42.43) controlPoint2: NSMakePoint(25.65, 41.65)];
    [questionPath curveToPoint: NSMakePoint(24.03, 37.91) controlPoint1: NSMakePoint(24.35, 39.76) controlPoint2: NSMakePoint(24.03, 38.83)];
    [questionPath curveToPoint: NSMakePoint(24.64, 36.66) controlPoint1: NSMakePoint(24.03, 37.46) controlPoint2: NSMakePoint(24.23, 37.04)];
    [questionPath closePath];
    [questionPath moveToPoint: NSMakePoint(33.49, 20.55)];
    [questionPath curveToPoint: NSMakePoint(34.21, 22.15) controlPoint1: NSMakePoint(33.97, 20.94) controlPoint2: NSMakePoint(34.21, 21.47)];
    [questionPath curveToPoint: NSMakePoint(33.52, 23.69) controlPoint1: NSMakePoint(34.21, 22.76) controlPoint2: NSMakePoint(33.98, 23.28)];
    [questionPath curveToPoint: NSMakePoint(31.83, 24.32) controlPoint1: NSMakePoint(33.06, 24.11) controlPoint2: NSMakePoint(32.5, 24.32)];
    [questionPath curveToPoint: NSMakePoint(30.1, 23.69) controlPoint1: NSMakePoint(31.15, 24.32) controlPoint2: NSMakePoint(30.57, 24.11)];
    [questionPath curveToPoint: NSMakePoint(29.4, 22.15) controlPoint1: NSMakePoint(29.63, 23.28) controlPoint2: NSMakePoint(29.4, 22.76)];
    [questionPath curveToPoint: NSMakePoint(30.13, 20.54) controlPoint1: NSMakePoint(29.4, 21.46) controlPoint2: NSMakePoint(29.64, 20.93)];
    [questionPath curveToPoint: NSMakePoint(31.83, 19.97) controlPoint1: NSMakePoint(30.61, 20.16) controlPoint2: NSMakePoint(31.18, 19.97)];
    [questionPath curveToPoint: NSMakePoint(33.49, 20.55) controlPoint1: NSMakePoint(32.46, 19.97) controlPoint2: NSMakePoint(33.01, 20.16)];
    [questionPath closePath];
    return questionPath;
}

+ (NSBezierPath *) getPathForTimesIcon {
    NSBezierPath* timesPath = NSBezierPath.bezierPath;
    [timesPath moveToPoint: NSMakePoint(32, 60)];
    [timesPath curveToPoint: NSMakePoint(4, 32) controlPoint1: NSMakePoint(16.54, 60) controlPoint2: NSMakePoint(4, 47.46)];
    [timesPath curveToPoint: NSMakePoint(32, 4) controlPoint1: NSMakePoint(4, 16.54) controlPoint2: NSMakePoint(16.54, 4)];
    [timesPath curveToPoint: NSMakePoint(60, 32) controlPoint1: NSMakePoint(47.46, 4) controlPoint2: NSMakePoint(60, 16.54)];
    [timesPath curveToPoint: NSMakePoint(32, 60) controlPoint1: NSMakePoint(60, 47.46) controlPoint2: NSMakePoint(47.46, 60)];
    [timesPath closePath];
    [timesPath moveToPoint: NSMakePoint(64, 32)];
    [timesPath curveToPoint: NSMakePoint(32, 0) controlPoint1: NSMakePoint(64, 14.33) controlPoint2: NSMakePoint(49.67, 0)];
    [timesPath curveToPoint: NSMakePoint(0, 32) controlPoint1: NSMakePoint(14.33, 0) controlPoint2: NSMakePoint(0, 14.33)];
    [timesPath curveToPoint: NSMakePoint(32, 64) controlPoint1: NSMakePoint(0, 49.67) controlPoint2: NSMakePoint(14.33, 64)];
    [timesPath curveToPoint: NSMakePoint(64, 32) controlPoint1: NSMakePoint(49.67, 64) controlPoint2: NSMakePoint(64, 49.67)];
    [timesPath closePath];
    [timesPath moveToPoint: NSMakePoint(41.43, 41.43)];
    [timesPath curveToPoint: NSMakePoint(41.43, 38.73) controlPoint1: NSMakePoint(42.17, 40.68) controlPoint2: NSMakePoint(42.17, 39.48)];
    [timesPath curveToPoint: NSMakePoint(34.69, 32) controlPoint1: NSMakePoint(41.43, 38.73) controlPoint2: NSMakePoint(38.24, 35.54)];
    [timesPath curveToPoint: NSMakePoint(41.43, 25.26) controlPoint1: NSMakePoint(38.24, 28.45) controlPoint2: NSMakePoint(41.43, 25.26)];
    [timesPath curveToPoint: NSMakePoint(41.43, 22.57) controlPoint1: NSMakePoint(42.17, 24.52) controlPoint2: NSMakePoint(42.17, 23.32)];
    [timesPath curveToPoint: NSMakePoint(38.73, 22.57) controlPoint1: NSMakePoint(40.68, 21.83) controlPoint2: NSMakePoint(39.48, 21.83)];
    [timesPath curveToPoint: NSMakePoint(32, 29.3) controlPoint1: NSMakePoint(38.73, 22.57) controlPoint2: NSMakePoint(35.54, 25.76)];
    [timesPath curveToPoint: NSMakePoint(25.27, 22.57) controlPoint1: NSMakePoint(28.46, 25.76) controlPoint2: NSMakePoint(25.27, 22.57)];
    [timesPath curveToPoint: NSMakePoint(22.57, 22.57) controlPoint1: NSMakePoint(24.52, 21.83) controlPoint2: NSMakePoint(23.32, 21.83)];
    [timesPath curveToPoint: NSMakePoint(22.57, 25.26) controlPoint1: NSMakePoint(21.83, 23.32) controlPoint2: NSMakePoint(21.83, 24.52)];
    [timesPath curveToPoint: NSMakePoint(29.31, 32) controlPoint1: NSMakePoint(22.57, 25.26) controlPoint2: NSMakePoint(25.76, 28.45)];
    [timesPath curveToPoint: NSMakePoint(22.57, 38.73) controlPoint1: NSMakePoint(25.76, 35.54) controlPoint2: NSMakePoint(22.57, 38.73)];
    [timesPath curveToPoint: NSMakePoint(22.57, 41.43) controlPoint1: NSMakePoint(21.83, 39.48) controlPoint2: NSMakePoint(21.83, 40.68)];
    [timesPath curveToPoint: NSMakePoint(25.27, 41.43) controlPoint1: NSMakePoint(23.32, 42.17) controlPoint2: NSMakePoint(24.52, 42.17)];
    [timesPath curveToPoint: NSMakePoint(32, 34.69) controlPoint1: NSMakePoint(25.27, 41.43) controlPoint2: NSMakePoint(28.45, 38.24)];
    [timesPath curveToPoint: NSMakePoint(38.73, 41.43) controlPoint1: NSMakePoint(35.55, 38.24) controlPoint2: NSMakePoint(38.73, 41.43)];
    [timesPath curveToPoint: NSMakePoint(41.43, 41.43) controlPoint1: NSMakePoint(39.48, 42.17) controlPoint2: NSMakePoint(40.68, 42.17)];
    [timesPath closePath];
    return timesPath;
}


@end

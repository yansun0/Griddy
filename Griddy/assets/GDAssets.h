//
//  GDAssets.h
//  Griddy
//
//  Created by Yan Sun on 2014-08-21.
//  Copyright (c) 2014 Sunnay. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface GDAssets : NSObject


#pragma mark - COLORS

// window
+ (NSVisualEffectMaterial) getWindowMaterial;
+ (NSColor *) getWindowBorder;
+ (NSColor *) getOverlayInnerBorder;
+ (NSColor *) getOverlayBackground;

// cell
+ (NSColor *) getCellBorderBackground;
+ (NSColor *) getCellBackground;

// other
+ (NSColor *) getTextColor;
+ (NSColor *) getDividerColor;


#pragma mark - ICONS
// Default size: 64x64

+ (NSBezierPath *) getPathForGridNineIcon;
+ (NSBezierPath *) getPathForGridFourIcon;
+ (NSBezierPath *) getPathForGearsIcon;
+ (NSBezierPath *) getPathForQuestionIcon;
+ (NSBezierPath *) getPathForTimesIcon;

@end

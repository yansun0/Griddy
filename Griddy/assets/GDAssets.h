//
//  GDAssets.h
//  Griddy
//
//  Created by Yan Sun on 2014-08-21.
//  Copyright (c) 2014 Sunnay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GDAssets : NSObject

+ (NSColor *) getLightColorBackground;
+ (NSColor *) getLightColorText;
+ (NSColor *) getDarkColorBackground;
+ (NSColor *) getDarkColorText;

// DEFAULT ICON SIZE = 64
+ (NSBezierPath *) getPathForGridNineIcon;
+ (NSBezierPath *) getPathForGridFourIcon;
+ (NSBezierPath *) getPathForGearsIcon;
+ (NSBezierPath *) getPathForQuestionIcon;
+ (NSBezierPath *) getPathForTimesIcon;

@end

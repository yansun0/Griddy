//
//  GDAssets.h
//  Griddy
//
//  Created by Yan Sun on 2014-08-21.
//  Copyright (c) 2014 Sunnay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GDAssets : NSObject
// light
// background: 233 231 235
// text:       97 97 100

// dark
// background: 155 155 155
// text:       255 255 255

+ (NSBezierPath *) getPathForGridNineIcon;
+ (NSBezierPath *) getPathForGridFourIcon;
+ (NSBezierPath *) getPathForGearsIcon;
+ (NSBezierPath *) getPathForQuestionIcon;
+ (NSBezierPath *) getPathForTimesIcon;

@end

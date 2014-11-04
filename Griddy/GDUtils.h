//
//  GDUtils.h
//  Griddy
//
//  Created by Yan Sun on 11/8/14.
//  Copyright (c) 2014 Sunnay. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GDGrid;

@interface GDUtils : NSObject

+ (BOOL) checkAccessibilityAccessAndPromptUser: (BOOL) doPrompt;
+ (void) moveFromCell1: (NSPoint) cell1
               toCell2: (NSPoint) cell2
              withGrid: (GDGrid *) grid;
+ ( void ) updateCurScreens: ( NSMutableArray * ) curScreens
             WithNewScreens: ( NSMutableArray ** ) newScreens
          AndRemovedScreens: ( NSMutableArray ** ) rmScreens;
@end

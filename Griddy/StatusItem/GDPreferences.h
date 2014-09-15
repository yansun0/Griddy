//
//  GDPreferences.h
//  Griddy
//
//  Created by Yan Sun on 2014-08-23.
//  Copyright (c) 2014 Sunnay. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface GDPreferences : NSObject

+ (void) setUserDefaults;
+ (void) setMainWindowTypeDefault: (NSUInteger) newType;
+ (void) setStatusItemVisibilityDefault: (BOOL) showItem;
+ (void) setDockIconVisibilityDefault: (BOOL) showIcon;
+ (void) setMainWindowRelativeSizeDefault: (NSSize) newSize;
+ (void) setMainWindowAbsoluteSizeDefault: (NSSize) newSize;
+ (void) setGridDimensionsDefault: (NSSize) newDimensions;
@end

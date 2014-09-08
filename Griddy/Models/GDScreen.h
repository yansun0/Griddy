//
//  GDScreen.h
//  Griddy
//
//  Created by Yan Sun on 2014-07-05.
//  Copyright (c) 2014 Sunnay. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface GDScreen : NSObject

@property (nonatomic) NSNumber *screenID;
@property (nonatomic) NSRect screenInfo;

- (id) initWithScreen: (NSScreen *)screen;
- (void) updateScreen: (NSScreen *)newScreen;
- (BOOL) isSameNSScreen: (NSScreen *)thisScreen;
- (BOOL) isSameGDScreen: (GDScreen *)thisScreen;
- (void) setNumWidth: (NSInteger) numCellHorizontal
           NumHeight: (NSInteger) numCellVertical;
- (NSSize) getMainWindowSizeForScreenPercentageSize: (NSSize) sizeP;
- (NSString *) getScreenBoundsForGridRect: (NSRect) newPosRect;
- (NSRect) getScreenFrameForGridRect: (NSRect) gridRect;
@end

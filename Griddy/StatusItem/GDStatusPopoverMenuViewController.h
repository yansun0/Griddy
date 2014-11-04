//
//  GDStatusPanel.h
//  Griddy
//
//  Created by Yan Sun on 2014-08-19.
//  Copyright (c) 2014 Sunnay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDStatusItem.h"


@interface GDStatusPopoverMenuViewController : NSViewController <GDStatusPopoverViewController>
@end

@interface GDStatusPopoverActivateButton : NSView
@end

@interface GDStatusPopoverAboutButton : NSView
@end

@interface GDStatusPopoverSettingsButton : NSView
@end

@interface GDStatusPopoverQuitButton : NSView
@end

@interface GDStatusPopoverDivider : NSBox
@end
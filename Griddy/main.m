//
//  main.m
//  Griddy
//
//  Created by Yan Sun on 2014-06-24.
//  Copyright (c) 2014 Sunnay. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GDAppDelegate.h"

int main(int argc, const char * argv[]) {
    GDAppDelegate *delegate = [[GDAppDelegate alloc] init];
    [[NSApplication sharedApplication] setDelegate: delegate];
    [NSApp setActivationPolicy: NSApplicationActivationPolicyAccessory];
    [NSApp run];
}

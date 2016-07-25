//
//  Warning Doom.h
//  Warning Doom
//
//  Created by ALEXEY ULENKOV on 23.07.16.
//  Copyright © 2016 Alexey Ulenkov. All rights reserved.
//

@import AppKit;
@import Cocoa;

@class WDMRoot;

static WDMRoot *sharedPlugin;

@interface WDMRoot : NSObject
@property (nonatomic, strong, readonly) NSBundle* bundle;

+ (instancetype)sharedPlugin;
- (id)initWithBundle:(NSBundle *)plugin;

@end

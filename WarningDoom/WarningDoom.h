//
//  WarningDoom.h
//  WarningDoom
//
//  Created by ALEXEY ULENKOV on 24.07.16.
//  Copyright © 2016 Alexey Ulenkov. All rights reserved.
//

#import <AppKit/AppKit.h>

@class WarningDoom;

static WarningDoom *sharedPlugin;

@interface WarningDoom : NSObject

+ (instancetype)sharedPlugin;
- (id)initWithBundle:(NSBundle *)plugin;

@property (nonatomic, strong, readonly) NSBundle* bundle;
@end
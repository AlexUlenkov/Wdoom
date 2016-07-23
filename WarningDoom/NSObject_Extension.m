//
//  NSObject_Extension.m
//  WarningDoom
//
//  Created by ALEXEY ULENKOV on 24.07.16.
//  Copyright © 2016 Alexey Ulenkov. All rights reserved.
//


#import "NSObject_Extension.h"
#import "WarningDoom.h"

@implementation NSObject (Xcode_Plugin_Template_Extension)

+ (void)pluginDidLoad:(NSBundle *)plugin
{
    static dispatch_once_t onceToken;
    NSString *currentApplicationName = [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
    if ([currentApplicationName isEqual:@"Xcode"]) {
        dispatch_once(&onceToken, ^{
            sharedPlugin = [[WarningDoom alloc] initWithBundle:plugin];
        });
    }
}
@end

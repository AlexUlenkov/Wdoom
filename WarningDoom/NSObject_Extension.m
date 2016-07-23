//
//  NSObject_Extension.m
//  Warning Doom
//
//  Created by ALEXEY ULENKOV on 23.07.16.
//  Copyright © 2016 Alexey Ulenkov. All rights reserved.
//


#import "NSObject_Extension.h"
#import "WDMRoot.h"

@implementation NSObject (Xcode_Plugin_Template_Extension)

+ (void)pluginDidLoad:(NSBundle *)plugin
{
    static dispatch_once_t onceToken;
    NSString *currentApplicationName = [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
    if ([currentApplicationName isEqual:@"Xcode"]) {
        dispatch_once(&onceToken, ^{
            sharedPlugin = [[WDMRoot alloc] initWithBundle:plugin];
        });
    }
}
@end

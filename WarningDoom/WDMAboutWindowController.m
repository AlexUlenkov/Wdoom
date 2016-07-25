//
//  WDMAboutWindowController.m
//  WarningDoom
//
//  Created by ALEXEY ULENKOV on 24.07.16.
//  Copyright © 2016 Alexey Ulenkov. All rights reserved.
//

#import "WDMRoot.h"
#import "WDMAboutWindowController.h"

@implementation WDMAboutWindowController

@synthesize textView;

- (void)windowDidLoad {
  [super windowDidLoad];
  NSBundle *bundle = [NSBundle bundleWithIdentifier: @"ru.fakeboss.WarningDoom"];
  NSString *resourcePath = [bundle resourcePath];
  NSData *data = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", resourcePath,@"About.rtf"]];
  
  if (!data)
  {
    return;
  }
  NSAttributedString *content = [[NSAttributedString alloc] initWithRTF:data documentAttributes:NULL];
  [self.textView.textStorage setAttributedString:content];
  self.textView.editable = NO;
}

@end

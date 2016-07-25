//
//  WDMRadioButton.h
//  WarningDoom
//
//  Created by ALEXEY ULENKOV on 24.07.16.
//  Copyright © 2016 Alexey Ulenkov. All rights reserved.
//

@import Cocoa;

IB_DESIGNABLE
@interface WDMButton : NSButton

@property (nonatomic, strong) IBInspectable NSColor *backgroundColor;
@property (nonatomic, strong) IBInspectable NSColor *textColor;

@end

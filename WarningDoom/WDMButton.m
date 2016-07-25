//
//  WDMRadioButton.m
//  WarningDoom
//
//  Created by ALEXEY ULENKOV on 24.07.16.
//  Copyright © 2016 Alexey Ulenkov. All rights reserved.
//

#import "WDMButton.h"

@implementation WDMButton

@synthesize backgroundColor;
@synthesize textColor;

- (void)awakeFromNib
{
  if (self.textColor)
  {
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setAlignment:NSCenterTextAlignment];
    NSDictionary *attrsDictionary  = [NSDictionary dictionaryWithObjectsAndKeys:
                                      self.textColor, NSForegroundColorAttributeName,
                                      self.font, NSFontAttributeName,
                                      style, NSParagraphStyleAttributeName, nil];
    NSAttributedString *attrString = [[NSAttributedString alloc]initWithString:self.title attributes:attrsDictionary];
    [self setAttributedTitle:attrString];
  }
}


- (void)drawRect:(NSRect)dirtyRect
{
  if (self.backgroundColor)
  {
    // add a background colour
    [self.backgroundColor setFill];
    NSRectFill(dirtyRect);
  }
  
  [super drawRect:dirtyRect];
}

@end

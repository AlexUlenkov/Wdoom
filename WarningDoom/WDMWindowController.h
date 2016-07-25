//
//  WDMWindowController.h
//  WarningDoom
//
//  Created by ALEXEY ULENKOV on 24.07.16.
//  Copyright © 2016 Alexey Ulenkov. All rights reserved.
//

@import Cocoa;

@class WDMButton;

@interface WDMWindowController : NSWindowController

// !!!: Not appear in builder. 
@property(nonatomic, strong) IBOutletCollection(WDMButton) NSArray *radioButtons;

@property(nonatomic, weak) IBOutlet WDMButton *easyLevelButton;
@property(nonatomic, weak) IBOutlet WDMButton *mediumLevelButton;
@property(nonatomic, weak) IBOutlet WDMButton *hardLevelButton;
@property(nonatomic, weak) IBOutlet WDMButton *insaneLevelButton;
@property(nonatomic, weak) IBOutlet WDMButton *okButton;

- (IBAction)openHelp:(id)sender;
- (IBAction)selectLevel:(id)sender;
- (IBAction)confirm:(id)sender;

@end

//
//  WDMWindowController.m
//  WarningDoom
//
//  Created by ALEXEY ULENKOV on 24.07.16.
//  Copyright © 2016 Alexey Ulenkov. All rights reserved.
//

#import "WDMRoot.h"
#import "WDMModel.h"
#import "WDMWindowController.h"
#import "WDMAboutWindowController.h"
#import "WDMButton.h"

static NSString *_Nonnull const  kWDMSettingName = @"Wdoom";

@interface WDMWindowController ()
@property(nonatomic, strong) WDMModel *appModel;
@property(nonatomic, strong) WDMAboutWindowController *aboutController;
@property(nonatomic, strong) NSString *currentSelectedDifficulty;
@end

@implementation WDMWindowController

@synthesize appModel;
@synthesize aboutController;
@synthesize radioButtons;
@synthesize currentSelectedDifficulty;

@synthesize easyLevelButton;
@synthesize mediumLevelButton;
@synthesize hardLevelButton;
@synthesize insaneLevelButton;
@synthesize okButton;

- (void)windowDidLoad {
  [super windowDidLoad];
  if (self.aboutController == nil) {
    self.aboutController = [[WDMAboutWindowController alloc] initWithWindowNibName:@"WDMAboutWindowController"];
  }
  self.radioButtons = @[self.easyLevelButton,
                        self.mediumLevelButton,
                        self.hardLevelButton,
                        self.insaneLevelButton];
  
  NSString *storedDifficulty = [[NSUserDefaults standardUserDefaults] objectForKey:[kWDMSettingName copy]];
  if (storedDifficulty) {
    self.currentSelectedDifficulty = storedDifficulty;
    [self configButtonsStates:storedDifficulty];
  }
  self.appModel = [[WDMModel alloc] init];
}

- (void)configButtonsStates:(NSString *)selectedButtonTitle {
  for (WDMButton *button in self.radioButtons) {
    if ([button.title compare:selectedButtonTitle] == NSOrderedSame) {
      button.cell.state = 1;
    }
  }
}

- (IBAction)openHelp:(id)sender{
  if (self.aboutController.window.isVisible) {
    [self.aboutController close];
    
  }
  else {
    [self.aboutController loadWindow];
    [self.aboutController showWindow:sender];
  }
}

- (IBAction)selectLevel:(id)sender {
  for (WDMButton *button in self.radioButtons) {
    if ([button isEqual:sender]) {
      self.currentSelectedDifficulty = button.title;
    }
  }
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-parameter"
- (IBAction)confirm:(id)sender {
  NSString *selected;
  for (WDMButton *button in self.radioButtons) {
    if (button.state == 1) {
      selected = button.title;
      break;
    }
  }
  dispatch_async(dispatch_get_main_queue(), ^{
    [self.appModel updatePbxProjForKey:selected];
    [[NSUserDefaults standardUserDefaults] setObject:self.currentSelectedDifficulty forKey:[kWDMSettingName copy]];
    [[NSUserDefaults standardUserDefaults] synchronize];
  });
  [self close];
}
#pragma clang diagnostic pop

@end

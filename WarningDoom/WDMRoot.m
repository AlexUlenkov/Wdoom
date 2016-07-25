//
//  Warning Doom.m
//  Warning Doom
//
//  Created by ALEXEY ULENKOV on 23.07.16.
//  Copyright © 2016 Alexey Ulenkov. All rights reserved.
//

#import "WDMRoot.h"
#import "WDMModel.h"
#import "WDMWindowController.h"

@interface WDMRoot ()
@property (nonatomic, strong) WDMWindowController* windowController;
@property (nonatomic, strong, readwrite) NSBundle *bundle;
@end

@implementation WDMRoot

@synthesize windowController;
@synthesize bundle;

+ (instancetype)sharedPlugin
{
    return sharedPlugin;
}

+ (void)pluginDidLoad:(NSBundle*)plugin
{
  static dispatch_once_t onceToken;
  
  NSString* currentApplicationName = [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
  if (sharedPlugin == nil && [currentApplicationName isEqual:@"Xcode"]) {
    dispatch_once(&onceToken, ^{
      sharedPlugin=[[self alloc] initWithBundle:plugin];
    });
  }
}

- (id)initWithBundle:(NSBundle *)plugin
{
  self = [super init];
    if (self) {
        // reference to plugin's bundle, for resource access
        self.bundle = plugin;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didApplicationFinishLaunchingNotification:)
                                                     name:NSApplicationDidFinishLaunchingNotification
                                                   object:nil];
    }
    return self;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wextra"
- (void)didApplicationFinishLaunchingNotification:(NSNotification*)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSApplicationDidFinishLaunchingNotification object:nil];
  
    NSMenuItem *menuItem = [[NSApp mainMenu] itemWithTitle:@"Edit"];
    if (menuItem) {
        [[menuItem submenu] addItem:[NSMenuItem separatorItem]];
        NSMenuItem *actionMenuItem = [[NSMenuItem alloc] initWithTitle:@"-Wdoom" action:@selector(openPluginWindow) keyEquivalent:@"d"];
        [actionMenuItem setKeyEquivalentModifierMask:NSControlKeyMask | NSShiftKeyMask];
        [actionMenuItem setTarget:self];
        [[menuItem submenu] addItem:actionMenuItem];
    }
}
#pragma clang diagnostic pop

- (void)openPluginWindow
{
  if (self.windowController.window.isVisible) {
    [self.windowController.window close];
  } else {
    if (self.windowController == nil) {
      self.windowController = [[WDMWindowController alloc] initWithWindowNibName:@"WDMWindowController"];
    }
    [WDMModel sharedModel].fileUrl = [WDMModel currentWorkspaceDocument].workspace.representingFilePath.fileURL;
    [self.windowController.window makeKeyAndOrderFront:nil];
  }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

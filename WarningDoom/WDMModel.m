//
//  WDMModel.m
//  WarningDoom
//
//  Created by ALEXEY ULENKOV on 24.07.16.
//  Copyright © 2016 Alexey Ulenkov. All rights reserved.
//

#import "WDMModel.h"

NSString *const kWDMEasy = @"I'm too young to die";
NSString *const kWDMMedium = @"Hey, not to rough";
NSString *const kWDMHard = @"Ultra-Violence";
NSString *const kWDMInsane = @"Nightmare!";

static NSString *const kWDMPbjProj = @"project.pbxproj";
static NSString *const kWDMxcProj = @".xcodeproj";
static NSString *const kWDMxcWorkspace = @".xcworkspace";
static NSString *const kWDMxcWorkspaceSettings = @"contents.xcworkspacedata";

static NSString *const kWDMEasyDifficulty = @"\t\t\t\tWARNING_CFLAGS = \"\";";
static NSString *const kWDMMediumDifficulty = @"\t\t\t\tWARNING_CFLAGS = (\n\
\t\t\t\t\t\"-Wfloat-equal\", \n\
\t\t\t\t\t\"-Wimplicit-retain-self\",\n\
\t\t\t\t\t\"-Wshadow\",\n\
\t\t\t\t\t\"-Wsign-compare\",\n\
\t\t\t\t\t\"-Wundef\",\n\
\t\t\t\t\t);";
static NSString *const kWDMHardDifficulty = @"\t\t\t\tWARNING_CFLAGS = (\n\
\t\t\t\t\t\"-Wall\", \n\
\t\t\t\t\t\"-Wfloat-equal\", \n\
\t\t\t\t\t\"-Wimplicit-retain-self\",\n\
\t\t\t\t\t\"-Wnewline-eof\",\n\
\t\t\t\t\t\"-Wshadow\",\n\
\t\t\t\t\t\"-Wsign-compare\",\n\
\t\t\t\t\t\"-Wundef\",\n\
\t\t\t\t\t\"-Weverything\",\n\
\t\t\t\t\t);";
static NSString *const kWDMInsaneDifficulty = @"\t\t\t\tWARNING_CFLAGS = (\n\
\t\t\t\t\t\"-Werror\", \n\
\t\t\t\t\t\"-Wextra\", \n\
\t\t\t\t\t\"-Wall\", \n\
\t\t\t\t\t\"-Wfloat-equal\", \n\
\t\t\t\t\t\"-Wimplicit-retain-self\",\n\
\t\t\t\t\t\"-Wnewline-eof\",\n\
\t\t\t\t\t\"-Wshadow\",\n\
\t\t\t\t\t\"-Wsign-compare\",\n\
\t\t\t\t\t\"-Wundef\",\n\
\t\t\t\t\t\"-Weverything\",\n\
\t\t\t\t\t);";

@interface WDMModel ()
@property(nonatomic,strong) NSDictionary<NSString *, NSString *> *difficulties;
@end

@implementation WDMModel

@synthesize fileUrl;
@synthesize difficulties = _difficulties;

- (instancetype)init {
  self = [super init];
  if (self) {
    _difficulties = @{
                      kWDMEasy:kWDMEasyDifficulty,
                      kWDMMedium:kWDMMediumDifficulty,
                      kWDMHard:kWDMHardDifficulty,
                      kWDMInsane:kWDMInsaneDifficulty
                      };
  }
  return self;
}

+ (instancetype)sharedModel{
  static dispatch_once_t once;
  static id sharedModel;
  dispatch_once(&once, ^{
    sharedModel = [[self alloc] init];
  });
  return sharedModel;
}

- (void)updatePbxProjForKey:(NSString *)settingKey {
  NSString *workspacePath = [WDMModel sharedModel].fileUrl.path;
  if ([self isWorkspace:workspacePath]) {
    NSArray *projectPaths = [self findXcProjPaths:workspacePath];
    for (NSString *path in projectPaths) {
        [self updatePbxProjFile:path forKey:settingKey];
    }
  }
  else if ([self isProject:workspacePath]) {
      [self updatePbxProjFile:workspacePath forKey:settingKey];
  }
  else {
    NSAlert *alert = [[NSAlert alloc] init];
    alert.messageText = @"Couldn't detect workspace type.";
    [alert runModal];
  }
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wassign-enum"
- (void)updatePbxProjFile:(NSString *)filePath forKey:(NSString *)settingsKey {
  NSString *pbxProjPath = [filePath stringByAppendingFormat:@"/%@", kWDMPbjProj];
  NSString *replacingString = [NSString stringWithString:(NSString *_Nonnull)self.difficulties[settingsKey]];
  NSData* data = [[NSFileManager defaultManager] contentsAtPath: pbxProjPath];
  NSString *settings = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
  NSRegularExpression *regex;
  NSArray *matchResult;
  
  regex = [NSRegularExpression regularExpressionWithPattern:@"(\t+WARNING_CFLAGS = (?:.*?);)" options:NSRegularExpressionDotMatchesLineSeparators error:NULL];
  matchResult = [regex matchesInString:settings options:0 range:NSMakeRange(0, [settings length])] ;
  
  if (matchResult.count != 0){
    NSMutableArray *matchedStrings = [[NSMutableArray alloc] initWithCapacity:matchResult.count];
    for (NSTextCheckingResult *match in matchResult) {
      NSRange matchRange = [match rangeAtIndex:1];
      NSString *currentMatched = [settings substringWithRange:matchRange];
      NSLog(@"%@",currentMatched);
      [matchedStrings addObject:currentMatched];
    }
    for (NSString *matchedString in matchedStrings) {
      settings = [settings stringByReplacingOccurrencesOfString:matchedString withString:replacingString];
    }
  }
  else {
    regex = [NSRegularExpression regularExpressionWithPattern:@"(PRODUCT_NAME = (?:.*?);)" options:NSRegularExpressionDotMatchesLineSeparators error:NULL];
    matchResult = [regex matchesInString:settings options:0 range:NSMakeRange(0, [settings length])] ;
    NSUInteger currentMathIndex = 0;
    NSUInteger rangeOffset = 0;
    for (NSTextCheckingResult *match in matchResult) {
      if (currentMathIndex>1) break;
      NSRange matchRange = NSMakeRange([match rangeAtIndex:1].location + rangeOffset, [match rangeAtIndex:1].length) ;
      NSString *currentMatched = [settings substringWithRange:matchRange];
      NSString *stringForReplacing = [NSString stringWithFormat:@"%@\n%@", currentMatched, replacingString];
      settings = [settings stringByReplacingCharactersInRange:matchRange withString:stringForReplacing];
      rangeOffset += replacingString.length + 1;
      ++currentMathIndex;
    }
  }
  [settings writeToFile:pbxProjPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

- (NSArray <NSString *> *)findXcProjPaths:(NSString *)filePath{
  NSString *settingsFilePath = [filePath stringByAppendingFormat:@"/%@", kWDMxcWorkspaceSettings];
  NSData* data = [[NSFileManager defaultManager] contentsAtPath:settingsFilePath];
  NSString *settings = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
  
  NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<FileRef\n +location = \"group:(.*?)\">" options:NSRegularExpressionAnchorsMatchLines error:NULL];
  NSArray *matchResult = [regex matchesInString:settings options:0 range:NSMakeRange(0, [settings length])] ;
  NSMutableArray *projectNames = [NSMutableArray arrayWithCapacity:[matchResult count]];
  
  NSString *directory = [[[NSURL URLWithString:filePath] absoluteString] stringByDeletingLastPathComponent];
  
  for (NSTextCheckingResult *match in matchResult) {
    NSRange matchRange = [match rangeAtIndex:1];
    NSString *currentMatched = [settings substringWithRange:matchRange];
    if (([currentMatched compare:@"Pods"] != NSOrderedSame) &&
        ([currentMatched compare:@"Carthage"] != NSOrderedSame)){
      [projectNames addObject: [directory stringByAppendingFormat:@"/%@",[settings substringWithRange:matchRange]]];
    }
  }
  return [projectNames copy];
}
#pragma clang diagnostic push

- (BOOL)isWorkspace:(NSString *)filepath {
  NSRange workspaceRange = [filepath rangeOfString:kWDMxcWorkspace];
  BOOL isWorkSpace = (workspaceRange.length != 0)?YES:NO;
  return isWorkSpace;
}

- (BOOL)isProject:(NSString *)filepath {
  NSRange projectRange = [filepath rangeOfString:(NSString *_Nonnull)kWDMxcProj];
  BOOL isProject = (projectRange.length != 0)?YES:NO;
  return isProject;
}


+ (IDEWorkspaceDocument*)currentWorkspaceDocument
{
  NSWindowController* currentWindowController =
  [[NSApp mainWindow] windowController];
  id document = [currentWindowController document];
  if (currentWindowController &&
      [document isKindOfClass:NSClassFromString(@"IDEWorkspaceDocument")]) {
    return (IDEWorkspaceDocument*)document;
  }
  return nil;
}


@end

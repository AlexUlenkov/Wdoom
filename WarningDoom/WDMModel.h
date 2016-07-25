//
//  WDMModel.h
//  WarningDoom
//
//  Created by ALEXEY ULENKOV on 24.07.16.
//  Copyright © 2016 Alexey Ulenkov. All rights reserved.
//

@import Foundation;
@import AppKit;

extern NSString *const kWDMEasy;
extern NSString *const kWDMMedium;
extern NSString *const kWDMHard;
extern NSString *const kWDMInsane;

@interface DVTFileDataType : NSObject
@property (readonly) NSString* identifier;
@end

@interface DVTFilePath : NSObject
@property (readonly) NSURL* fileURL;
@property (readonly) DVTFileDataType* fileDataTypePresumed;
@end

@interface IDEWorkspace : NSWorkspace
@property (readonly) DVTFilePath* representingFilePath;
@end

@interface IDEWorkspaceDocument : NSDocument
@property (readonly) IDEWorkspace* workspace;
@end

@interface WDMModel: NSObject

@property(nonatomic, copy) NSURL *fileUrl;

- (instancetype)init NS_DESIGNATED_INITIALIZER;
- (void)updatePbxProjForKey:(NSString *)settingKey;

+ (instancetype)sharedModel;
+ (IDEWorkspaceDocument*)currentWorkspaceDocument;

@end

//
//  YGRunMode.h
//  noter
//
//  Created by Ян on 18/05/2017.
//  Copyright © 2017 Yan Gerasimuk. All rights reserved.
//

#import <Foundation/Foundation.h>

enum YGFileType {
    YGFileTypeNote,
    YGFileTypeDraft
};
typedef enum YGFileType YGFileType;

enum YGOutputMode {
    YGOutputModeErrorOnly,
    YGOutputModeLogAndError
};
typedef enum YGOutputMode YGOutputMode;

enum YGLaunchExternEditor {
    YGLaunchExternEditorYes,
    YGLaunchExternEditorNo
};
typedef enum YGLaunchExternEditor YGLaunchExternEditor;

enum YGLaunchExternViewer {
    YGLaunchExternViewerYes,
    YGLaunchExternViewerNo
};
typedef enum YGLaunchExternViewer YGLaunchExternViewer;

enum YGSourceOfTemplate {
    YGSourceOfTemplateCode,
    YGSourceOfTemplateFile
};
typedef enum YGSourceOfTemplate YGSourceOfTemplate;

enum YGTimeStamp {
    YGTimeStampNow,
    YGTimeStampCustom
};
typedef enum YGTimeStamp YGTimeStamp;

enum YGPrintHelp {
    YGPrintHelpYes,
    YGPrintHelpNo
};
typedef enum YGPrintHelp YGPrintHelp;

@interface YGRunMode : NSObject

- (void)parsingArguments:(NSArray *)args;

@property (readonly) YGFileType fileType;
@property (readonly) NSString *noteName;
@property (readonly) YGOutputMode outputMode;
@property (readonly) YGLaunchExternEditor launchExternEditor;
@property (readonly) YGLaunchExternViewer launchExternViewer;
@property (readonly) YGSourceOfTemplate sourceOfTemplate;
@property (readonly) YGTimeStamp timeStamp;
@property (readonly) NSString *noteTimeStamp;
@property (readonly) YGPrintHelp printHelp;

@end

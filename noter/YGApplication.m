//
//  YGApplication.m
//  noter
//
//  Created by Ян on 17/05/2017.
//  Copyright © 2017 Yan Gerasimuk. All rights reserved.
//

#import "YGApplication.h"
#import "define.h"

@implementation YGApplication

/**
 Base init. Set properties for default and actual options.
 */
- (instancetype) init{
    self = [super init];
    if(self){
        _runMode = [[YGRunMode alloc] init];
    }
    return self;
}


- (BOOL) isNoteNameFree:(YGNoteName *)name{
    NSFileManager *fm = [NSFileManager defaultManager];
    
    if([fm fileExistsAtPath:name.fullName]){
        _lastErrorNumber = kNewNoterNameErrorN;
        _lastErrorMessage = kNewNoterNameErrorMessage;
        return NO;
    }
    else
        return YES;
}

- (BOOL) isNewNoteSaved:(YGNoteName *)name{
    NSFileManager *fm = [NSFileManager defaultManager];
    
    if([fm fileExistsAtPath:name.fullName])
        return YES;
    else{
        self.lastErrorNumber = kNewNoterNotSavedErrorN;
        self.lastErrorMessage = kNewNoterNotSavedErrorMessage;
        return NO;
    }
}


/**
 Singleton for application instance.
 */
+ (YGApplication *) sharedInstance{
    
    static YGApplication *app = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        app = [[YGApplication alloc] init];
    });
    
    return app;
}

- (NSString *) runModeInfo{
    NSMutableString *result = [[NSMutableString alloc] init];
    
    if(self.runMode.fileType == YGFileTypeNote)
        [result appendString:@"FileType: Note"];
    else
        [result appendString:@"FileType: Draft"];
    
    if(self.runMode.launchExternViewer == YGLaunchExternViewerYes)
        [result appendString:@" | LaunchExternViewer: Yes"];
    else
        [result appendString:@" | LaunchExternViewer: No"];
    
    if(self.runMode.launchExternEditor == YGLaunchExternEditorYes)
        [result appendString:@" | LaunchExternEditor: Yes"];
    else
        [result appendString:@" | LaunchExternEditor: No"];
    
    if(self.runMode.outputMode == YGOutputModeLogAndError)
        [result appendString:@" | OutputMode: LogAndError"];
    else
        [result appendString:@" | OutputMode: ErrorOnly"];
    
    if(self.runMode.printHelp == YGPrintHelpYes)
        [result appendString:@" | PrintHelp: Yes"];
    else
        [result appendString:@" | PrintHelp: No"];
    
    return [result copy];
}

+ (void) printInfoAndHelp{
    printf("\nnoter. Create html-note from template. Version: %s, build: %s. %s.", [kNoterVersion UTF8String], [kNoterBuild UTF8String], [kNoterAuthor UTF8String]);
    
    printf("\nUsage: \
           \nnoter -<options:ndhlexvs> <name> \
           \nOptions: \
           \n\tn - generate note (default) \
           \n\td - generate draft from template \
           \n\th - print help \
           \n\te - print only error (default) \
           \n\tl - print log about app works \
           \n\tx - launch extern editor (default) \
           \n\tv - launch extern viewer (default) \
           \n\ts - do not launch extern apps");
    
    printf("\nConfig file: ~/.noter.config.xml");
    printf("\nMIT license. Sources: https://github.com/yangerasimuk/noter");
}

@end

//
//  YGRunMode.m
//  noter
//
//  Created by Ян on 18/05/2017.
//  Copyright © 2017 Yan Gerasimuk. All rights reserved.
//

#import "YGRunMode.h"
#import "YGApplication.h"
#import "define.h"
#import <YGConfig.h>

@interface YGRunMode ()
- (void)defaultRunMode;
@end

@implementation YGRunMode

-(instancetype)init{
    self = [super init];
    if(self){
        [self defaultRunMode];
    }
    return self;
}

-(void)defaultRunMode{
    YGConfig *config = [[YGConfig alloc] initWithApplicationName:kNoterAppName];
    
    NSString *value = nil;
    
    value = [config valueForKey:kPreferenceFileTypeKey];
    if([value compare:@"Note"] == NSOrderedSame)
        _fileType = YGFileTypeNote;
    else if([value compare:@"Draft"] == NSOrderedSame)
        _fileType = YGFileTypeDraft;
    else{
        [config setValue:@"Note" forKey:kPreferenceFileTypeKey];
        _fileType = YGFileTypeNote;
    }
    
    value = [config valueForKey:kPreferenceOutputModeKey];
    if([value compare:@"ErrorOnly"] == NSOrderedSame)
        _outputMode = YGOutputModeErrorOnly;
    else if([value compare:@"LogAndError"] == NSOrderedSame)
        _outputMode = YGOutputModeLogAndError;
    else{
        [config setValue:@"ErrorOnly" forKey:kPreferenceOutputModeKey];
        _outputMode = YGOutputModeErrorOnly;
    }
    
    value = [config valueForKey:kPreferenceLaunchExternEditorKey];
    if([value compare:@"Yes"] == NSOrderedSame)
        _launchExternEditor = YGLaunchExternEditorYes;
    else if([value compare:@"No"] == NSOrderedSame)
        _launchExternEditor = YGLaunchExternEditorNo;
    else{
        [config setValue:@"Yes" forKey:kPreferenceLaunchExternEditorKey];
        _launchExternEditor = YGLaunchExternEditorYes;
    }
    
    value = [config valueForKey:kPreferenceLaunchExternViewerKey];
    if([value compare:@"Yes"] == NSOrderedSame)
        _launchExternViewer = YGLaunchExternViewerYes;
    else if([value compare:@"No"] == NSOrderedSame)
        _launchExternViewer = YGLaunchExternViewerNo;
    else{
        [config setValue:@"Yes" forKey:kPreferenceLaunchExternViewerKey];
        _launchExternViewer = YGLaunchExternViewerYes;
    }
    
    _printHelp = YGPrintHelpNo;
}

-(void)parsingArguments:(NSArray *)args{
    
    unsigned long count = [args count];
    if (count == 0 || count > 3){
        YGApplication *app = [YGApplication sharedInstance];
        app.lastErrorNumber = kArgErrorWrongCountN;
        app.lastErrorMessage = kArgErrorWrondCountMessage;
        return;
    }
    
    for(NSString *s in args){
        if([s characterAtIndex:0] == '-'){
            
            // weak preferences
            for(NSUInteger i = 0; i < [s length]; i++){
                unichar ch = [s characterAtIndex:i];
                
                if(ch == 'd')
                    _fileType = YGFileTypeDraft;
                else if(ch == 'l')
                    _outputMode = YGOutputModeLogAndError;
                else if(ch == 'x')
                    _launchExternEditor = YGLaunchExternEditorYes;
                else if(ch == 'v')
                    _launchExternViewer = YGLaunchExternViewerYes;
                else if(ch == 'h')
                    _printHelp = YGPrintHelpYes;
            }
            
            // strong preferences
            for(NSUInteger i = 0; i < [s length]; i++){
                unichar ch = [s characterAtIndex:i];
                
                if(ch == 'n')
                    _fileType = YGFileTypeNote;
                else if(ch == 'e')
                    _outputMode = YGOutputModeErrorOnly;
                else if(ch == 's'){
                    _launchExternEditor = YGLaunchExternEditorNo;
                    _launchExternViewer = YGLaunchExternViewerNo;
                }
            }
        }
        else{
            _noteName = [s copy];
        }
    }
    
    if (!_noteName || [_noteName compare:@""] == NSOrderedSame){
        YGApplication *app = [YGApplication sharedInstance];
        app.lastErrorNumber = kArgErrorUnknownNameN;
        app.lastErrorMessage = kArgErrorUnknownNameMessage;
        return;
    }
}

@end

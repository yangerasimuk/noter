//
//  YGRunMode.m
//  noter
//
//  Created by Ян on 18/05/2017.
//  Copyright © 2017 Yan Gerasimuk. All rights reserved.
//

#import "YGRunMode.h"
#import "YGApplication.h"
#import "YGTool.h"
#import "define.h"
#import <YGConfig.h>

@interface YGRunMode ()
- (void)defaultRunMode;
@end

@implementation YGRunMode

- (instancetype)init{
    self = [super init];
    if(self){
        [self defaultRunMode];
    }
    return self;
}

- (void)defaultRunMode{
    
    YGConfig *config = [[YGConfig alloc] initWithApplicationName:kNoterAppName];
    
    NSString *value = nil;
    
    value = [config valueForKey:kPreferenceFileTypeKey];
    if([value isEqualToString:@"Note"])
        _fileType = YGFileTypeNote;
    else if([value isEqualToString:@"Draft"])
        _fileType = YGFileTypeDraft;
    else{
        [config setValue:@"Note" forKey:kPreferenceFileTypeKey];
        _fileType = YGFileTypeNote;
    }
    
    value = [config valueForKey:kPreferenceOutputModeKey];
    if([value isEqualToString:@"ErrorOnly"])
        _outputMode = YGOutputModeErrorOnly;
    else if([value isEqualToString:@"LogAndError"])
        _outputMode = YGOutputModeLogAndError;
    else{
        [config setValue:@"ErrorOnly" forKey:kPreferenceOutputModeKey];
        _outputMode = YGOutputModeErrorOnly;
    }
    
    value = [config valueForKey:kPreferenceLaunchExternEditorKey];
    if([value isEqualToString:@"Yes"])
        _launchExternEditor = YGLaunchExternEditorYes;
    else if([value isEqualToString:@"No"])
        _launchExternEditor = YGLaunchExternEditorNo;
    else{
        [config setValue:@"Yes" forKey:kPreferenceLaunchExternEditorKey];
        _launchExternEditor = YGLaunchExternEditorYes;
    }
    
    value = [config valueForKey:kPreferenceLaunchExternViewerKey];
    if([value isEqualToString:@"Yes"])
        _launchExternViewer = YGLaunchExternViewerYes;
    else if([value isEqualToString:@"No"])
        _launchExternViewer = YGLaunchExternViewerNo;
    else{
        [config setValue:@"Yes" forKey:kPreferenceLaunchExternViewerKey];
        _launchExternViewer = YGLaunchExternViewerYes;
    }
    
    value = [config valueForKey:kPreferenceSourceOfTemplateKey];
    if([value isEqualToString:@"Code"])
        _sourceOfTemplate = YGSourceOfTemplateCode;
    else if([value isEqualToString:@"File"])
        _sourceOfTemplate = YGSourceOfTemplateFile;
    else{
        [config setValue:@"Code" forKey:kPreferenceSourceOfTemplateKey];
        _sourceOfTemplate = YGSourceOfTemplateCode;
    }
    
    _timeStamp = YGTimeStampNow;
    _printHelp = YGPrintHelpNo;
}


- (void)parsingArguments:(NSArray *)args{
    
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
            for(NSUInteger i = 1; i < [s length]; i++){
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
                else if(ch == 'f')
                    _sourceOfTemplate = YGSourceOfTemplateFile;
                else if(ch == 't')
                    _timeStamp = YGTimeStampCustom;
            }
            
            // strong preferences
            // keys reWrite previous values
            for(NSUInteger i = 1; i < [s length]; i++){
                unichar ch = [s characterAtIndex:i];
                
                if(ch == 'n')
                    _fileType = YGFileTypeNote;
                else if(ch == 'e')
                    _outputMode = YGOutputModeErrorOnly;
                else if(ch == 's'){
                    _launchExternEditor = YGLaunchExternEditorNo;
                    _launchExternViewer = YGLaunchExternViewerNo;
                }
                else if(ch == 'c'){
                    _sourceOfTemplate = YGSourceOfTemplateCode;
                }
            }
            
            // have custome timeStamp
            if (_timeStamp == YGTimeStampCustom) {
                
                NSInteger index = 0;
                for (NSUInteger i = 0; i < [s length]; i++){
                    unichar ch = [s characterAtIndex:i];
                    if (ch == 't')
                        index = i + 1;
                }
                
                _noteTimeStamp = [s substringFromIndex:index];
                
                if (![YGTool string:_noteTimeStamp confirmTo:@"([0-9]{4}-[0-9]{2}-[0-9]{2})"]) {
                    YGApplication *app = [YGApplication sharedInstance];
                    app.lastErrorNumber = kArgErrorTimeStampIsNotConfirmPatternN;
                    app.lastErrorMessage = kArgErrorTimeStampIsNotConfirmPatternMessage;
                    return;
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

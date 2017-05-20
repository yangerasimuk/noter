//
//  main.m
//  noter
//
//  Created by Ян on 17/05/2017.
//  Copyright © 2017 Yan Gerasimuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h> // NSWorkspace

#import <YGConfig.h>
#import "YGApplication.h"
#import "YGRunMode.h"
#import "YGNoteName.h"
#import "YGNoteTemplate.h"
#import "YGNoteBuilder.h"
#import "YGNoteStorage.h"
#import "define.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        YGApplication *app = [YGApplication sharedInstance];
        
        // parse argument of command line
        NSMutableArray<NSString *> *args = [[NSMutableArray alloc] init];
        for(int i = 1; i < argc; i++)
            [args addObject:[NSString stringWithUTF8String:argv[i]]];
        
        [app.runMode parsingArguments:[args copy]];
        
        // check arguments of command line
        if(app.lastErrorNumber != 0){
            printf("\nError! %s\n", [app.lastErrorMessage UTF8String]);
            [YGApplication printInfoAndHelp];
            printf("\n\n");
            return (int)app.lastErrorNumber;
        }
        
        if(app.runMode.printHelp == YGPrintHelpYes)
            [YGApplication printInfoAndHelp];
        
        if(app.runMode.outputMode == YGOutputModeLogAndError)
            printf("\n%s", [[app runModeInfo] UTF8String]);
        
        // get a filename
        YGNoteName *newName = [[YGNoteName alloc]
                               initWithFileType:app.runMode.fileType
                               rawName:app.runMode.noteName];
        
        // check is file exists
        if(![app isNoteNameFree:newName]){
            printf("\nError! %s.", [[app lastErrorMessage] UTF8String]);
            printf("\n\n");
            return (int)[app lastErrorNumber];
        }
        
        // get a template raw html
        YGNoteTemplate *template = [[YGNoteTemplate alloc] init];
        
        // modify html for the note
        YGNoteBuilder *builder = [[YGNoteBuilder alloc] initWithHtml:template.html];
        
        // save note on disk
        YGNoteStorage *storage = [[YGNoteStorage alloc]
                                  initWithName:newName
                                  forHTML:[builder makeNoteHtml]];
        [storage saveNote];
        
        if(![app isNewNoteSaved:newName]){
            printf("\nError! %s.", [[app lastErrorMessage] UTF8String]);
            printf("\n\n");
            return (int)[app lastErrorNumber];
        }
        else{
            if(app.runMode.outputMode == YGOutputModeLogAndError)
                printf("\nNote is successfully saved on disk.");
        }
        
        YGConfig *config = [[YGConfig alloc] initWithApplicationName:kNoterAppName];

        // open extern app to view
        if (app.runMode.launchExternViewer == YGLaunchExternViewerYes){
            NSString *viewer = [config valueForKey:kExternalViewerKey];
            if(!viewer){
                [config setValue:kExternalViewer forKey:kExternalViewerKey];
                viewer = kExternalViewer;
            }
            [[NSWorkspace sharedWorkspace] openFile:newName.fullName
                                    withApplication:[NSString stringWithFormat:@"/Applications/%@", viewer]];
        }
        
        // open extern app to edit
        if (app.runMode.launchExternEditor == YGLaunchExternEditorYes){
            NSString *editor = [config valueForKey:kExternalEditorKey];
            if(!editor){
                [config setValue:kExternalEditor forKey:kExternalEditorKey];
                editor = kExternalEditor;
            }
            [[NSWorkspace sharedWorkspace] openFile:newName.fullName
                                    withApplication:[NSString stringWithFormat:@"/Applications/%@", editor]];
        }
        
        if(app.runMode.outputMode == YGOutputModeLogAndError)
            printf("\n\n");
    }
    return 0;
}

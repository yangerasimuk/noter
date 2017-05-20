//
//  YGNoteTemplate.m
//  noter
//
//  Created by Ян on 18/05/2017.
//  Copyright © 2017 Yan Gerasimuk. All rights reserved.
//

#import "YGNoteTemplate.h"
#import "define.h"
#import <YGConfig.h>


@implementation YGNoteTemplate

- (instancetype)init{
    self = [super init];
    if(self){
        
        YGConfig *config = [[YGConfig alloc] initWithApplicationName:kNoterAppName];
        
        NSString *fileName = [config valueForKey:kNoteTemplateFileNameKey];
        if(!fileName)
            fileName = kNoteTemplateFileName;
        
        NSString *fileNameFull = [NSString stringWithFormat:@"%@/.%@/%@",
                                      NSHomeDirectory(),
                                      kNoterAppName,
                                      fileName];
        
        if(!fileNameFull || ([fileNameFull compare:@""] == NSOrderedSame)){
            @throw [NSException exceptionWithName:@"-[YGNoteTemplate init]" reason:@"Can not create html template name" userInfo:nil];
        }
        
        NSFileManager *fm = [NSFileManager defaultManager];
        NSData *htmlData = [fm contentsAtPath:fileNameFull];
        
        //_html = [NSString stringWithUTF8String:[dataHtml bytes]];
        _html = [[NSString alloc] initWithData:htmlData encoding:NSUTF8StringEncoding];
        
        if([_html length] == 0)
            @throw [NSException exceptionWithName:@"-[YGNoteTemplate init]" reason:@"Html template is empty" userInfo:nil];
    }
    return self;
}

@end

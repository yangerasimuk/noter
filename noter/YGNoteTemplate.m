//
//  YGNoteTemplate.m
//  noter
//
//  Created by Ян on 18/05/2017.
//  Copyright © 2017 Yan Gerasimuk. All rights reserved.
//

#import "YGApplication.h"
#import "YGNoteTemplate.h"
#import "define.h"
#import <YGConfig.h>


@implementation YGNoteTemplate

- (instancetype)init{
    self = [super init];
    if(self){
        
        YGApplication *app = [YGApplication sharedInstance];
        
        if(app.runMode.sourceOfTemplate == YGSourceOfTemplateFile) {
            
            YGConfig *config = [[YGConfig alloc] initWithApplicationName:kNoterAppName];
            
            NSString *fileName = [config valueForKey:kNoteTemplateFileNameKey];
            if(!fileName)
                fileName = kNoteTemplateFileName;
            
            NSString *fileNameFull = [NSString stringWithFormat:@"%@/.%@/%@",
                                      NSHomeDirectory(),
                                      kNoterAppName,
                                      fileName];
            
            if(!fileNameFull || ([fileNameFull compare:@""] == NSOrderedSame)){
                @throw [NSException exceptionWithName:@"-[YGNoteTemplate init]" reason:@"Can not create HTML template name" userInfo:nil];
            }
            
            NSFileManager *fm = [NSFileManager defaultManager];
            
            if([fm fileExistsAtPath:fileNameFull]){
                NSData *htmlData = [fm contentsAtPath:fileNameFull];
                
                _html = [[NSString alloc] initWithData:htmlData encoding:NSUTF8StringEncoding];
            }
            else {
                printf("\nCannot get HTML template from file: %s", [fileNameFull UTF8String]);
                printf("\nHTML template will be get from code");
                
                _html = [self getHTMLDefault];
            }
            
        }
        else if(app.runMode.sourceOfTemplate == YGSourceOfTemplateCode) {
            
            _html = [self getHTMLDefault];
        }
        else {
            @throw [NSException exceptionWithName:@"-[YGNoteTemplate init]" reason:@"Can not define source of html template" userInfo:nil];
        }
        
        if([_html length] == 0)
            @throw [NSException exceptionWithName:@"-[YGNoteTemplate init]" reason:@"Html template is empty" userInfo:nil];
    }
    return self;
}

- (NSString *)getHTMLDefault {
    
    return @"<!DOCTYPE html><html lang=\"en\"><head><meta charset=\"utf-8\"><meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\"><meta name=\"viewport\" content=\"width=device-width, initial-scale=1\"> \
<style>\n \
@media screen and (max-width: 480px) {html { -webkit-text-size-adjust: none;} body {font-size:90%; font-family: -apple-system, Helvetica, Arial, sans-serif; padding-left:1%; padding-right:1%;}}\n \
@media only screen  and (min-width: 1224px){ body {font-size:17px;line-height:1.6;font-family: -apple-system, Helvetica, Arial, sans-serif;padding-left:10%;padding-right:10%;}}\n \
a {border-bottom: 1px solid;text-decoration: none;color: #0066CC;border-color: #B2CCF0;} a:visited {color: purple;border-color: #E0B2E0;} a:hover {color: #FF4B33;border-color: #FF4B33 !important;}\n \
pre { background-color: #eff0f1; overflow: auto; padding: 5px; margin-bottom: 1em; } pre code { padding: 0; white-space: inherit;} code { padding: 1px 3px; background-color: #eff0f1; }\n \
table.withboard {cellpadding:0;cellspacing:0;border-collapse: collapse;} table.withboard td, th {border:1px solid black;}\n \
img.full-width {width:100%;max-width:1024px;} img.one-third-width {width:30%;}\n \
</style>\n \
<meta name=\"yg:uuid\" content=\"\" /><meta name=\"yg:created\" content=\"\" /><meta name=\"yg:author\" content=\"Ян Герасимук\" /><meta name=\"yg:type\" content=\"note\" />\n \
<meta property=\"yg:tags:0\" content=\"\" />\n \
<title>&fnof;&nbsp;</title>\n \
</head>\n \
<body>\n \
<p id=\"note-top-menu\"></p>\n \
<h1></h1>\n \
<p id=\"note-info\"><span id=\"note-date\" class=\"margin-right\"></span><a id=\"note-target-url\" class=\"note-info-url\" href=\"\"></a></p>\n \
\n \
\n \
</body>\n \
</html>";
}

@end

//
//  YGNoteStorage.m
//  noter
//
//  Created by Ян on 18/05/2017.
//  Copyright © 2017 Yan Gerasimuk. All rights reserved.
//

#import "YGNoteStorage.h"
#import "YGNoteName.h"
#import "YGApplication.h"
#import "define.h"

@interface YGNoteStorage(){
    YGNoteName *_name;
    NSString *_html;
}
@end

@implementation YGNoteStorage

- (instancetype) initWithName:(YGNoteName *)name forHTML:(NSString *)html{
    self = [super init];
    if(self){
        _name = name;
        _html = [html copy];
    }
    return self;
}

- (void) saveNote{
    
    YGApplication *app = [YGApplication sharedInstance];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSData *noteData = [[NSData alloc] initWithData:[_html dataUsingEncoding:NSUTF8StringEncoding]];
    
    @try{
        
        if(![fm createFileAtPath:_name.fullName contents:noteData attributes:nil]){
            app.lastErrorNumber = kNewNoterNotSavedErrorN;
            app.lastErrorMessage = kNewNoterNotSavedErrorMessage;
            
            printf("\nCan not save note on disk. Error in -[YGNoteStorage saveNote].");
        }
    }
    @catch(NSException *ex){
        app.lastErrorNumber = kNewNoterNotSavedErrorN;
        app.lastErrorMessage = kNewNoterNotSavedErrorMessage;
        
        printf("\nCan not save note on disk. Description: %s.", [[ex description] cStringUsingEncoding:NSUTF8StringEncoding]);
    }
}

@end

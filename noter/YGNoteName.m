//
//  YGNoteName.m
//  noter
//
//  Created by Ян on 18/05/2017.
//  Copyright © 2017 Yan Gerasimuk. All rights reserved.
//

#import "YGNoteName.h"
#import "YGApplication.h"

@interface YGNoteName(){
    NSString *_command;
    NSString *_path;
}

+ (NSString *) normalizeName:(NSString *)rawName;
+ (NSString *) timeStampWithName:(NSString *)rawName fileType:(YGFileType)type;

@end

@implementation YGNoteName

- (instancetype) initWithFileType:(YGFileType)fileType rawName:(NSString *)rawName atPath:(NSString *)path{

    self = [super init];
    if(self){
        _fileType = fileType;
        
        if(!rawName || ([rawName compare:@""] == NSOrderedSame)){
            if(fileType == YGFileTypeNote)
                rawName = @"Note";
            else
                rawName = @"Draft";
        }
        _rawName = [rawName copy];
        
        NSString *finalName = [YGNoteName timeStampWithName:rawName fileType:fileType];
        _fullName = [NSString stringWithFormat:@"%@/%@", path, finalName];
    }
    
    return self;
}

- (instancetype) initWithFileType:(YGFileType)fileType rawName:(NSString *)rawName {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *path = [NSString stringWithFormat:@"%@", [fm currentDirectoryPath]];
    
    return [self initWithFileType:fileType rawName:rawName atPath:path];
}

- (instancetype) initWithFileType:(YGFileType)fileType {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *path = [NSString stringWithFormat:@"%@", [fm currentDirectoryPath]];
    NSString *rawName = @"Note";
    
    return [self initWithFileType:fileType rawName:rawName atPath:path];
}

- (instancetype) init {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *path = [NSString stringWithFormat:@"%@", [fm currentDirectoryPath]];
    NSString *rawName = @"Note";
    YGFileType fileType = YGFileTypeNote;
    
    return [self initWithFileType:fileType rawName:rawName atPath:path];
}


+ (NSString *) timeStampWithName:(NSString *)rawName fileType:(YGFileType)fileType{
    
    NSString *resultName = @"";
    NSString *dateString = @"";
    
    YGApplication *app = [YGApplication sharedInstance];
    
    if (app.runMode.timeStamp == YGTimeStampCustom) {
        dateString = app.runMode.noteTimeStamp;
    }
    else {
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        dateString = [formatter stringFromDate:date];
    }
    
    if(fileType == YGFileTypeNote){
        // define type of filename: with space or with hyphen
        NSString *joinString = [[NSString alloc] init];
        if([rawName containsString:@" "])
            joinString = @", ";
        else if([rawName containsString:@"_"])
            joinString = @"_";
        else if([rawName containsString:@"-"])
            joinString = @"-";
        else
            joinString = @".";
        
        resultName = [NSString stringWithFormat:@"%@%@%@.html", dateString, joinString, [YGNoteName normalizeName:rawName]];
    }
    else if(fileType == YGFileTypeDraft){
        resultName = [NSString stringWithFormat:@"%@.%@.html", [YGNoteName normalizeName:rawName], dateString];
    }
    
    if(app.runMode.outputMode == YGOutputModeLogAndError)
        printf("\nName: %s", [resultName UTF8String]);
    
    //resultURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@", path, resultName]];
    return resultName;
}


+ (NSString *) normalizeName:(NSString *)rawName{
    
    NSString *safeName = [NSString stringWithFormat:@"%@", rawName];
    
    NSArray *problemSymbolsWithWhitespace = @[@"/ ", @": ", @"? "];
    for (NSString *s in problemSymbolsWithWhitespace){
        if([rawName containsString:s])
            safeName = [safeName stringByReplacingOccurrencesOfString:s withString:@"_ "];
    }
    
    NSArray *problemSymbolsWithNoWhitespace = @[@"\\", @"/", @":"];
    for (NSString *s in problemSymbolsWithNoWhitespace){
        if([rawName containsString:s])
            safeName = [safeName stringByReplacingOccurrencesOfString:s withString:@"-"];
    }
    
    NSArray *problemSymbolsForDelete = @[@"*", @"?"];
    for (NSString *s in problemSymbolsForDelete){
        if([rawName containsString:s])
            safeName = [safeName stringByReplacingOccurrencesOfString:s withString:@""];
    }
    
    safeName = [safeName stringByReplacingOccurrencesOfString:@"  " withString:@" "];
    safeName = [safeName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    return safeName;
}
@end


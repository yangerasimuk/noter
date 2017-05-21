//
//  YGNoteBuilder.m
//  noter
//
//  Created by Ян on 18/05/2017.
//  Copyright © 2017 Yan Gerasimuk. All rights reserved.
//

#import "YGNoteBuilder.h"
#import <YGConfig.h>
#import <YGHTMLRanged.h>
#import <YGFileSystem.h>
#import "YGApplication.h"
#import "define.h"


@interface YGNoteBuilder(){
    NSString *_htmlRaw;
}

- (void) setUuidWithHtmlBuilder:(YGHTMLBuilder *)htmlBuilder openOpenGraphPrefix:(NSString *)ogPrefix;
- (void) setCreatedWithHtmlBuilder:(YGHTMLBuilder *)htmlBuilder openOpenGraphPrefix:(NSString *)ogPrefix;
- (void) setTagsWithHtmlBuilder:(YGHTMLBuilder *)htmlBuilder openOpenGraphPrefix:(NSString *)ogPrefix;
- (void) setTitleWithHtmlBuilder:(YGHTMLBuilder *)htmlBuilder;
- (void) setH1WithHtmlBuilder:(YGHTMLBuilder *)htmlBuilder;
- (void) setNoteDateWithHtmlBuilder:(YGHTMLBuilder *)htmlBuilder;

- (NSArray *) getArrayFromOldStyleTagsString:(NSString *)tagsString;
+ (NSString *) getHumanDate;
@end

@implementation YGNoteBuilder

-(instancetype)initWithHtml:(NSString *)htmlRaw{
    self = [super init];
    if(self){
        _htmlRaw = [htmlRaw copy];
    }
    return self;
}


-(NSString *)makeNoteHtml{
    
    YGHTMLBuilder *htmlBuilder = [[YGHTMLBuilder alloc] initWithHTMLString:_htmlRaw];
    
    // app config
    YGConfig *config = [[YGConfig alloc] initWithApplicationName:kNoterAppName];
    
    NSString *ogPrefix = [config valueForKey:kMetaPrefix];
    if(!ogPrefix || [ogPrefix compare:@""] == NSOrderedSame){
        [config setValue:@"yg" forKey:kMetaPrefix];
        ogPrefix = @"yg";
    }
    
    // UUID
    // <meta name="yg:uuid" content="" />
    [self setUuidWithHtmlBuilder:htmlBuilder openOpenGraphPrefix:ogPrefix];
    
    // created
    // <meta name="yg:created" content="" />
    [self setCreatedWithHtmlBuilder:htmlBuilder openOpenGraphPrefix:ogPrefix];
    
    // tags
    // <meta name="yg:tags:0" content="" />
    [self setTagsWithHtmlBuilder:htmlBuilder openOpenGraphPrefix:ogPrefix];
    
    // title
    [self setTitleWithHtmlBuilder:htmlBuilder];
    
    // h1
    [self setH1WithHtmlBuilder:htmlBuilder];
    
    // note human date
    // <span id="note-date" class="margin-right"></span>
    [self setNoteDateWithHtmlBuilder:htmlBuilder];
    
    return [[htmlBuilder html] copy];
}


- (void) setUuidWithHtmlBuilder:(YGHTMLBuilder *)htmlBuilder openOpenGraphPrefix:(NSString *)ogPrefix{
    
    // search tag
    YGHTMLAttribute *attrNameS = [[YGHTMLAttribute alloc]
                                 initWithName:@"name"
                                 value:[NSString stringWithFormat:@"%@:uuid", ogPrefix]];
    YGHTMLAttribute *attrContentS = [[YGHTMLAttribute alloc] initWithName:@"content" value:@""];
    NSArray *attrArrayS = [NSArray arrayWithObjects:attrNameS, attrContentS, nil];
    YGHTMLTag *tagS = [[YGHTMLTag alloc] initWithName:@"meta" attributes:attrArrayS isOpenOnly:YES];
    YGHTMLElement *elSearched = [[YGHTMLElement alloc] initWithOpenTag:tagS];
    
    // replace el
    YGHTMLAttribute *attrName = [[YGHTMLAttribute alloc]
                                  initWithName:@"name"
                                 value:[NSString stringWithFormat:@"%@:uuid", ogPrefix]];
    YGHTMLAttribute *attrContent = [[YGHTMLAttribute alloc]
                                     initWithName:@"content"
                                     value:[NSString stringWithFormat:@"%@", [NSUUID UUID]]];
    NSArray *attrArray = [NSArray arrayWithObjects:attrName, attrContent, nil];
    YGHTMLTag *tagUUID = [[YGHTMLTag alloc] initWithName:@"meta" attributes:attrArray isOpenOnly:YES];
    YGHTMLElement *elUUID = [[YGHTMLElement alloc] initWithOpenTag:tagUUID];
    
    if([htmlBuilder isExistElementWithType:elSearched]){
        [htmlBuilder replaceElementWithType:elSearched byElement:elUUID];
    }

}

- (void) setCreatedWithHtmlBuilder:(YGHTMLBuilder *)htmlBuilder openOpenGraphPrefix:(NSString *)ogPrefix{
    
    YGHTMLAttribute *attrCreatedName = [[YGHTMLAttribute alloc] initWithName:@"name" value:[NSString stringWithFormat:@"%@:%@", ogPrefix, @"created"]];
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:kMetaDateTimeFormat];
    NSString *dateForMeta = [formatter stringFromDate:date];
    
    YGHTMLAttribute *attrCreatedContent = [[YGHTMLAttribute alloc] initWithName:@"content" value:dateForMeta];
    NSArray <YGHTMLAttribute *> *attrArrCreated = [NSArray arrayWithObjects:attrCreatedName, attrCreatedContent, nil];
    YGHTMLTag *tagCreated = [[YGHTMLTag alloc]
                             initWithName:@"meta"
                             attributes:attrArrCreated
                             isOpenOnly:YES];
    YGHTMLElement *elCreated = [[YGHTMLElement alloc] initWithOpenTag:tagCreated];
    
    if([htmlBuilder isExistElementWithType:elCreated])
        [htmlBuilder setElementByType:elCreated];
}

- (void) setTagsWithHtmlBuilder:(YGHTMLBuilder *)htmlBuilder openOpenGraphPrefix:(NSString *)ogPrefix{
    
    YGConfig *project = [[YGConfig alloc] init];
    
    // NoteFileTagsBasicForProject
    NSString *tagsString = [project valueForKey:@"NoteFileTagsBasicForProject"];
    
    NSArray *tags = nil;
    
    if(tagsString && [tagsString compare:@""] != NSOrderedSame){
        tags = [self getArrayFromOldStyleTagsString:tagsString];
        
        [project setValue:tags forKey:@"ProjectTags"];
    }
    
    tags = [project valueForKey:@"ProjectTags"];
    
    NSMutableArray *metaEls = [[NSMutableArray alloc] init];
    
    
    if([tags count] > 0){
        for(int i = 0; i < [tags count]; i++){
            YGHTMLAttribute *prop = [[YGHTMLAttribute alloc]
                                     initWithName:@"property"
                                     value:[NSString stringWithFormat:@"%@:tags:%d", ogPrefix, i]];
            YGHTMLAttribute *content = [[YGHTMLAttribute alloc]
                                        initWithName:@"content"
                                        value:tags[i]];
            NSArray *attrArray = [NSArray arrayWithObjects:prop, content, nil];
            YGHTMLTag *meta = [[YGHTMLTag alloc] initWithName:@"meta"
                                                    attributes:attrArray
                                                    isOpenOnly:YES];
            
            YGHTMLElement *el = [[YGHTMLElement alloc] initWithOpenTag:meta];
            [metaEls addObject:el];
        }
        
        
        YGHTMLAttribute *prop = [[YGHTMLAttribute alloc]
                                 initWithName:@"property"
                                 value:[NSString stringWithFormat:@"%@:tags:%lu", ogPrefix, [tags count]]];
        YGHTMLAttribute *content = [[YGHTMLAttribute alloc] initWithName:@"content" value:@""];
        NSArray *attrArray = [NSArray arrayWithObjects:prop, content, nil];
        YGHTMLTag *meta = [[YGHTMLTag alloc] initWithName:@"meta" attributes:attrArray isOpenOnly:YES];
        YGHTMLElement *el = [[YGHTMLElement alloc] initWithOpenTag:meta];
        
        [metaEls addObject:el];
        
        YGHTMLAttribute *propSearched = [[YGHTMLAttribute alloc] initWithName:@"property" value:@"yg:tags:0"];
        YGHTMLAttribute *contentSearched = [[YGHTMLAttribute alloc] initWithName:@"content" value:@""];
        NSArray *attrSearched = [NSArray arrayWithObjects:propSearched, contentSearched, nil];
        YGHTMLTag *tagSearched = [[YGHTMLTag alloc] initWithName:@"meta" attributes:attrSearched isOpenOnly:YES];
        YGHTMLElement *elSearched = [[YGHTMLElement alloc] initWithOpenTag:tagSearched];
        
        if([htmlBuilder isExistElementWithType:elSearched]){
            [htmlBuilder replaceElementWithType:elSearched byElements:metaEls];
        }
    }
}

- (void) setTitleWithHtmlBuilder:(YGHTMLBuilder *)htmlBuilder{
    
    YGApplication *app = [YGApplication sharedInstance];
    YGConfig *project = [[YGConfig alloc] init];
    
    YGHTMLTag *openTitle = [[YGHTMLTag alloc] initWithName:@"title"];
    YGHTMLTag *closeTitle = [[YGHTMLTag alloc] initWithName:@"title" isOpen:NO];
    
    NSString *titlePrefix = [project valueForKey:@"TitlePrefix"];
    
    // if title not defined, try to get prefix from old key
    if(!titlePrefix
       && ([titlePrefix compare:@""] != NSOrderedSame)
       && ([titlePrefix compare:@"(null)"] != NSOrderedSame)){
        
        titlePrefix = [project valueForKey:@"ListFileTitlePrefix"];
        if(titlePrefix){
            [project setValue:titlePrefix forKey:@"TitlePrefix"];
            [project removeValueForKey:@"ListFileTitlePrefix"];
        }
    }
    
    YGHTMLElement *elTitle = nil;
    if(!titlePrefix
       && ([titlePrefix compare:@""] != NSOrderedSame)
       && ([titlePrefix compare:@"(null)"] != NSOrderedSame)){

        elTitle = [[YGHTMLElement alloc]
                   initWithOpenTag:openTitle
                   closeTag:closeTitle
                   content:app.runMode.noteName];
    }
    else{
        elTitle = [[YGHTMLElement alloc]
                   initWithOpenTag:openTitle
                   closeTag:closeTitle
                   content:[NSString stringWithFormat:@"%@ %@", titlePrefix, app.runMode.noteName]];
    }
    
    
    if([htmlBuilder isExistElementWithName:elTitle.name]){
        [htmlBuilder setElementByName:elTitle];
    }
}



- (void) setH1WithHtmlBuilder:(YGHTMLBuilder *)htmlBuilder{
    
    YGApplication *app = [YGApplication sharedInstance];
    
    YGHTMLTag *openH1 = [[YGHTMLTag alloc] initWithName:@"h1"];
    YGHTMLTag *closeH1 = [[YGHTMLTag alloc] initWithName:@"h1" isOpen:NO];
    
    YGHTMLElement *elH1 = [[YGHTMLElement alloc] initWithOpenTag:openH1 closeTag:closeH1 content:app.runMode.noteName];
    
    if([htmlBuilder isExistElementWithName:elH1.name]){
        [htmlBuilder setElementByName:elH1];
    }
}

// <span id="note-date" class="margin-right"></span>
- (void) setNoteDateWithHtmlBuilder:(YGHTMLBuilder *)htmlBuilder{
    
    YGHTMLAttribute *spanId = [[YGHTMLAttribute alloc] initWithName:@"id" value:@"note-date"];
    YGHTMLAttribute *spanClass = [[YGHTMLAttribute alloc] initWithName:@"class" value:@"margin-right"];
    NSArray *attrArr = [NSArray arrayWithObjects:spanId, spanClass, nil];
    YGHTMLTag *openTag = [[YGHTMLTag alloc] initWithName:@"span" attributes:attrArr isOpenOnly:NO];
    YGHTMLTag *closeTag = [[YGHTMLTag alloc] initWithName:@"span" isOpen:NO];
    
    NSString *tagValue = [YGNoteBuilder getHumanDate];
    
    YGHTMLElement *el = [[YGHTMLElement alloc] initWithOpenTag:openTag closeTag:closeTag content:tagValue];
    
    if([htmlBuilder isExistElementWithType:el]){
        [htmlBuilder setElementByType:el];
    }
}

/*
 Function: get string from XML configuration file and split it to array of string.
 String divide by newline '\n'
 */
- (NSArray *) getArrayFromOldStyleTagsString:(NSString *)tagsString{
#ifdef FUNC_DEBUG
#undef FUNC_DEBUG
#endif
    
#ifdef FUNC_DEBUG
    printf("\n\t-[YGConfig getArrParamOfKey:]...");
#endif
    
    
    // Crutch! After getting string from XML-file all escape chars have doubled slashes for safe
    // and enumerator can not split newline-string
    tagsString = [tagsString stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    
#ifdef FUNC_DEBUG
    printf("\n\t\tstring for array: %s", [tagsString cStringUsingEncoding:NSUTF8StringEncoding]);
#endif
    
    if([tagsString compare:@""] == NSOrderedSame || (tagsString == nil)){
#ifdef FUNC_DEBUG
        printf("\n\t\ttagsString == nil. Return func.");
#endif
        return nil;
    }
    
    NSMutableArray *retArray = [[NSMutableArray alloc] init];
    [tagsString enumerateSubstringsInRange:NSMakeRange(0, tagsString.length) //[tagsString length])
                                   options:NSStringEnumerationByLines
                                usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                    
                                    [retArray addObject:substring];
                                }];
    
    return retArray;
}

+ (NSString *) getHumanDate{
#ifdef FUNC_DEBUG
#undef FUNC_DEBUG
#endif
    
#ifdef FUNC_DEBUG
    printf("\n\t+[YGTools getHumanDate:]...");
#endif
    /*
    NSDateFormatter *formatterFromString = [[NSDateFormatter alloc] init];
    // this is imporant - we set our input date format to match our input string
    // if format doesn't match you'll get nil from your string, so be careful
    [formatterFromString setDateFormat:@"yyyy-MM-dd"];
    NSDate *dateFromString = [[NSDate alloc] init];
    // voila!
    dateFromString = [formatterFromString dateFromString:dateString];
     */
    NSDate *date = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ru_RU"]];
    [formatter setDateStyle:NSDateFormatterLongStyle];
    
    NSString *resultString = [formatter stringFromDate:date];
    
#ifdef FUNC_DEBUG
    printf("\n\t\tHuman date: %s", [resultString cStringUsingEncoding:NSUTF8StringEncoding]);
#endif
    
    return resultString;
}

@end

//
//  YGTool.m
//  noter
//
//  Created by Ян on 02.01.18.
//  Copyright © 2018 Yan Gerasimuk. All rights reserved.
//

#import "YGTool.h"

@implementation YGTool

+ (BOOL)string:(NSString *)string confirmTo:(NSString *)pattern {
    
    // Поиск вне зависимости от регистра
    NSRegularExpressionOptions regexOptions = NSRegularExpressionCaseInsensitive;
    
    NSError *error = NULL;
    
    // Само создание регулярного выражения
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                           options:regexOptions
                                                                             error:&error];
    if (error){
        // Если в pattern были внесены корректные данные, тогда это сообщение не появиться
        NSLog(@"Ошибка при создании Regular Expression");
    }
    
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:string
                                                        options:0
                                                          range:NSMakeRange(0, [string length])];
    
    if (numberOfMatches > 0)
        return YES;
    else
        return NO;
}

@end

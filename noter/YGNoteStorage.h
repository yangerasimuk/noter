//
//  YGNoteStorage.h
//  noter
//
//  Created by Ян on 18/05/2017.
//  Copyright © 2017 Yan Gerasimuk. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YGNoteName;

@interface YGNoteStorage : NSObject

- (instancetype) initWithName:(YGNoteName *)name forHTML:(NSString *)html;
- (void) saveNote;

@end

//
//  YGApplication.h
//  noter
//
//  Created by Ян on 17/05/2017.
//  Copyright © 2017 Yan Gerasimuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YGRunMode.h"
#import "YGNoteName.h"

@interface YGApplication : NSObject

- (BOOL) isNoteNameFree:(YGNoteName *)name;
- (BOOL) isNewNoteSaved:(YGNoteName *)name;

+ (void) printInfoAndHelp;
- (NSString *) runModeInfo;

+ (YGApplication *) sharedInstance;

@property (readonly) YGRunMode *runMode;
@property NSUInteger lastErrorNumber;
@property NSString *lastErrorMessage;

@end

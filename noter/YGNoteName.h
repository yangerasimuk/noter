//
//  YGNoteName.h
//  noter
//
//  Created by Ян on 18/05/2017.
//  Copyright © 2017 Yan Gerasimuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YGRunMode.h"

@interface YGNoteName : NSObject

- (instancetype) initWithFileType:(YGFileType)fileType rawName:(NSString *)rawName atPath:(NSString *)path;
- (instancetype) initWithFileType:(YGFileType)fileType rawName:(NSString *)rawName;
- (instancetype) initWithFileType:(YGFileType)fileType;
- (instancetype) init;

@property (readonly, nonatomic) NSString *rawName;
@property (readonly, nonatomic) NSString *fullName;
@property (readonly, nonatomic) YGFileType fileType;

@end

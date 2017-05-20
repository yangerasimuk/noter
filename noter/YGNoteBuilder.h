//
//  YGNoteBuilder.h
//  noter
//
//  Created by Ян on 18/05/2017.
//  Copyright © 2017 Yan Gerasimuk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YGNoteBuilder : NSObject

-(instancetype)initWithHtml:(NSString *)htmlRaw;

-(NSString *)makeNoteHtml;

@end

//
//  FormDataManager.h
//  TestForm
//
//  Created by caoyusheng on 6/9/15.
//  Copyright (c) 2015年 caoyusheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FormTag.h"



#define STRING_OBJECT(x,y) [x objectForKey:y] ? [x objectForKey:y] : @""
#define NUMBER_OBJECT(x,y) [x objectForKey:y] ? [x objectForKey:y] : @0

@interface FormDataManager : NSObject

+ (BOOL) checkRegexWithString:(NSString*)string reg:(NSString*)regex;

@end

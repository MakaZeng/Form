//
//  FormDataManager.m
//  TestForm
//
//  Created by caoyusheng on 6/9/15.
//  Copyright (c) 2015年 caoyusheng. All rights reserved.
//

#import "FormDataManager.h"

@implementation FormDataManager

+ (BOOL) checkRegexWithString:(NSString *)string reg:(NSString *)regex
{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:string];
}

@end

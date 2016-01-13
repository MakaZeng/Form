//
//  ErrorCell.m
//  TestForm
//
//  Created by caoyusheng on 24/9/15.
//  Copyright (c) 2015年 caoyusheng. All rights reserved.
//

#import "ErrorCell.h"

@implementation ErrorCell

+(instancetype)instanceFromNib
{
    return [[[NSBundle mainBundle] loadNibNamed:@"ErrorCell" owner:self options:nil] firstObject];
}

@end

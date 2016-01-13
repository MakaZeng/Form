//
//  ErrorCell.h
//  TestForm
//
//  Created by caoyusheng on 24/9/15.
//  Copyright (c) 2015年 caoyusheng. All rights reserved.
//

#import "BaseFormCell.h"

@interface ErrorCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *errorLabel;

+(instancetype)instanceFromNib;

@end

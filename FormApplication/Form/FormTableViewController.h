//
//  FormTableViewController.h
//  TestForm
//
//  Created by caoyusheng on 28/8/15.
//  Copyright (c) 2015年 caoyusheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FormTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic,strong,readonly) NSDictionary* formDictionary;


//核对是否可以提交

- (BOOL)check;

- (void)sumit;

@end

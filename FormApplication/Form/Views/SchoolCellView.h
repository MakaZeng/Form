//
//  SchoolCellView.h
//  FormApplication
//
//  Created by Maka on 15/11/13.
//  Copyright © 2015年 maka. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^schoolChooseCellViewBlock)(id selectedItem);

@interface SchoolCellView : UIView

@property (nonatomic,strong) NSDictionary* info;

@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

+(instancetype)showSchoolChooseCellViewWithBlock:(schoolChooseCellViewBlock)block withInfo:(NSDictionary*)info;

@end

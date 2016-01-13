//
//  ActionSheetCellView.h
//  wolaidai
//
//  Created by Maka on 15/11/11.
//  Copyright © 2015年 welab. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^showActionSheetBlock)(BOOL isCancel, id selectedValue);

@interface ActionSheetCellView : UIView<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *topBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic,copy) showActionSheetBlock showBlock;

+(instancetype)showActionSheetWithInfo:(id)info title:(NSString*)titleString selectedBlock:(showActionSheetBlock)showBlock;

-(void)hide;

@end

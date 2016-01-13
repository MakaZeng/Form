//
//  BaseFormCell.h
//  TestForm
//
//  Created by caoyusheng on 31/8/15.
//  Copyright (c) 2015年 caoyusheng. All rights reserved.
//

#import "FormTag.h"
#import "FormProtocols.h"
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "FormDataManager.h"

@class BaseFormCell;

@protocol BaseFormCellDelegate <NSObject>

-(void)baseFormCellNextStep:(BaseFormCell*)cell;

@end


@interface BaseFormCell : UITableViewCell

@property (nonatomic,strong,readonly) NSIndexPath* indexPath;

@property (nonatomic,strong) NSDictionary* dictionary;

@property (nonatomic,weak,readonly) id<BaseFormCellDelegate> delegate;

@property (nonatomic,weak,readonly) UITableView* tableView;


@property (nonatomic,strong) NSMutableDictionary* targetDictionary;

-(void)shake;

//核对数据是否正确 需要复写
-(BOOL)check;

+(instancetype)instanceForDictionary:(NSDictionary*)dic withTableView:(UITableView*)tableView forIndexPath:(NSIndexPath*)indexPath withDelegate:(id<BaseFormCellDelegate>)delegate withTargetDic:(NSMutableDictionary*)mDic;


+(CGFloat)heightForDictionary:(NSDictionary*)dic;

@end

//
//  BaseFormCell.m
//  TestForm
//
//  Created by caoyusheng on 31/8/15.
//  Copyright (c) 2015年 caoyusheng. All rights reserved.
//

#import "BaseFormCell.h"
#import "FormDataManager.h"
#import <objc/runtime.h>

@interface BaseFormCell ()

@property (nonatomic,strong) NSIndexPath* indexPath;

@property (nonatomic,weak) id<BaseFormCellDelegate> delegate;

@property (nonatomic,weak) UITableView* tableView;

@end

@implementation BaseFormCell

-(void)awakeFromNib
{
    self.contentView.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [self addGestureRecognizer:tap];
}

-(BOOL)canBecomeFirstResponder
{
    return YES;
}

-(BOOL)becomeFirstResponder
{
    return YES;
}

-(BOOL)resignFirstResponder
{
    return YES;
}

-(void)tapAction
{
    UIResponder* res = self.nextResponder;
    NSInteger count = 0 ;
    while (![res isKindOfClass:[UIViewController class]]) {
        res = res.nextResponder;
        if (count > 20) {
            break;
        }
        count++;
    }
    if ([res isKindOfClass:[UIViewController class]]) {
        [[(UIViewController*)res view] endEditing:YES];
    }
    [self becomeFirstResponder];
}

+(instancetype)instanceForDictionary:(NSDictionary *)dic withTableView:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath withDelegate:(id<BaseFormCellDelegate>)delegate withTargetDic:(NSMutableDictionary *)mDic
{
    NSString *identifier = dic[form_cell_name];
    if (!identifier)
    {
        identifier = @"EditTextCell";
    }
    BaseFormCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if(!cell)
    {
        
        UINib *nib=[UINib nibWithNibName:identifier bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:identifier];
        
        NSArray *views = [nib instantiateWithOwner:tableView options:nil];
        cell = [views firstObject];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.indexPath = indexPath;
    cell.targetDictionary = mDic;
    cell.dictionary = dic;
    cell.delegate = delegate;
    return cell;
}

-(void)shake
{
    [BaseFormCell shakeView:self withDuration:.5];
}

#define kShakeViewAnimationKey @"kShakeViewAnimationKey"

+ (void)shakeView:(UIView*)view withDuration:(NSTimeInterval)duration {
    if (!view) return;
    [view.layer removeAnimationForKey:kShakeViewAnimationKey];
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    CGFloat currentTx = view.transform.tx;
    animation.delegate = nil;
    animation.duration = duration;
    animation.values = @[@(currentTx), @(currentTx + 10), @(currentTx - 8), @(currentTx + 8), @(currentTx - 5), @(currentTx + 5), @(currentTx)];
    animation.keyTimes = @[ @(0), @(0.225), @(0.425), @(0.6), @(0.75), @(0.875), @(1)];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [view.layer addAnimation:animation forKey:kShakeViewAnimationKey];
}


-(BOOL)check
{
    return YES;
}

+(CGFloat)heightForDictionary:(NSDictionary *)dic
{
    NSString* cellName = [dic objectForKey:form_cell_name];
    if ([cellName isEqualToString:@"LocationCell"]) {
        return 125;
    }
    return 44;
}

@end

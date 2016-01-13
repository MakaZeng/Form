//
//  FormTimeCellView.m
//  FormApplication
//
//  Created by Maka on 15/11/16.
//  Copyright © 2015年 maka. All rights reserved.
//

#import "FormTimeCellView.h"

@interface FormTimeCellView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIView *pickerContainer;

@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@property (strong, nonatomic) UIDatePicker *datePicker;

@property (nonatomic,weak) UIView* rootContainerView;

@property (nonatomic,strong) UIView* backView;

@end

@implementation FormTimeCellView

+(instancetype)showFormTimeCellViewWithBlock:(FormTimeCellViewBlock)block info:(id)info title:(NSString *)title
{
    UIView* container = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    container.backgroundColor = [UIColor clearColor];
    UIView* backView = [[UIView alloc]initWithFrame:container.bounds];
    backView.alpha = 0;
    backView.backgroundColor = [UIColor blackColor];
    [container addSubview:backView];
    
    FormTimeCellView* v = [FormTimeCellView instanceFromNib];
    v.center = CGPointMake(backView.bounds.size.width/2, backView.bounds.size.height/2);
    
    v.transform = CGAffineTransformMakeScale(.1, .1);
    v.backView = backView;
    v.rootContainerView = container;
    [container addSubview:v];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:v action:@selector(hide)];
    [backView addGestureRecognizer:tap];
    [[UIApplication sharedApplication].keyWindow addSubview:container];
    
    [UIView animateWithDuration:.25 animations:^{
        backView.alpha = .5;
        v.transform = CGAffineTransformIdentity;
    }];
    v.titleLabel.text= title;
    v.block = block;
    return v;
}

-(void)hide
{
    [UIView animateWithDuration:.25 animations:^{
        self.backView.alpha = 0;
        self.transform = CGAffineTransformMakeScale(.1, .1);
    } completion:^(BOOL finished) {
        [self.rootContainerView removeFromSuperview];
        self.rootContainerView = nil;
        self.backView = nil;
    }];
}

+(instancetype)instanceFromNib
{
    return [[[NSBundle mainBundle] loadNibNamed:@"FormTimeCellView" owner:self options:nil] firstObject];
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.layer.cornerRadius = 5;
    self.clipsToBounds = YES;
    
    self.datePicker = [[UIDatePicker alloc]initWithFrame:self.pickerContainer.bounds];
    [self.pickerContainer addSubview:self.datePicker];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    self.datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [self.datePicker setTimeZone:[NSTimeZone localTimeZone]];
    
    self.confirmButton.layer.cornerRadius = 5;
}

- (IBAction)confirmAction:(id)sender {
    if (self.block) {
        self.block(self.datePicker.date);
    }
    [self hide];
}

@end

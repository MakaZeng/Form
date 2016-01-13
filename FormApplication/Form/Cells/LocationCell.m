//
//  LocationCell.m
//  FormApplication
//
//  Created by Maka on 15/11/13.
//  Copyright © 2015年 maka. All rights reserved.
//

#import "LocationCell.h"
#import "LocationCellView.h"

@interface LocationCell ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *firstNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *secondNameLabel;

@property (weak, nonatomic) IBOutlet UITextField *firstTextField;

@property (weak, nonatomic) IBOutlet UITextField *secondTextField;

@property (weak, nonatomic) IBOutlet UIView *singleLine;

@end

@implementation LocationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    CGRect rect = self.singleLine.frame;
    rect.size.height = 1.0/[UIScreen mainScreen].scale;
    UIView* view = [[UIView alloc]initWithFrame:rect];
    view.backgroundColor = [UIColor lightGrayColor];
    [self.singleLine.superview addSubview:view];
    self.secondTextField.delegate = self;
}


- (IBAction)locationAction:(id)sender {
    
    [[LocationUtil shareInstance] requireCurrentLocationWithBlock:^(BOOL success, CLPlacemark *placeMark) {
        if (success) {
            self.firstTextField.text = [NSString stringWithFormat:@"%@ %@",STRING_OBJECT(placeMark.addressDictionary, @"City"),STRING_OBJECT(placeMark.addressDictionary, @"SubLocality")];
            self.secondTextField.text = STRING_OBJECT(placeMark.addressDictionary, @"Street");
        }
    }];
}

- (IBAction)chooseCity:(id)sender {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    NSString* moreInfo = [self.dictionary objectForKey:form_datasource];
    if (moreInfo) {
        NSString* path = [[NSBundle mainBundle] pathForResource:moreInfo ofType:@"plist"];
        if (path) {
            NSDictionary* dictionar = [NSDictionary dictionaryWithContentsOfFile:path];
            [LocationCellView showLocationCellViewWithInfo:dictionar callBack:^(NSArray *areas) {
                NSMutableString* mString = [NSMutableString string];
                for (NSDictionary* dic in areas) {
                    [mString appendFormat:@"%@",STRING_OBJECT(dic, @"name")];
                    if (![dic isEqualToDictionary:areas.lastObject]) {
                        [mString appendString:@" "];
                    }
                }
                self.firstTextField.text = mString;
            } title:@"选择省市区"];
        }
    }
    
}

-(void)setDictionary:(NSDictionary *)dictionary
{
    if (dictionary == self.dictionary) {
        return;
    }
    [super setDictionary:dictionary];
    
    self.titleLabel.text = STRING_OBJECT(dictionary, form_server_key_name);
    self.firstNameLabel.text = self.titleLabel.text;
    self.firstTextField.placeholder = STRING_OBJECT(dictionary, form_placeholder);
    self.secondTextField.placeholder = self.firstTextField.placeholder;
}

- (BOOL)becomeFirstResponder
{
    return YES;
}

-(BOOL)resignFirstResponder
{
    [self endEditing:YES];
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (![self check]) {
        [self shake];
        return NO;
    }
    if (self.delegate) {
        [self.delegate baseFormCellNextStep:self];
    }
    return YES;
}

-(BOOL)check
{
    return self.firstTextField.text.length > 0 ? YES :NO;
}

@end

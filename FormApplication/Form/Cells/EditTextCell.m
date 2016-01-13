//
//  EditTextCell.m
//  TestForm
//
//  Created by caoyusheng on 31/8/15.
//  Copyright (c) 2015年 caoyusheng. All rights reserved.
//

#import "EditTextCell.h"

@interface EditTextCell()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation EditTextCell

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.textField.delegate = self;
}

-(void)setDictionary:(NSDictionary *)dictionary
{
    if (dictionary == self.dictionary) {
        return;
    }
    [super setDictionary:dictionary];

    self.nameLabel.text = STRING_OBJECT(dictionary, form_server_key_name);
    self.textField.placeholder = STRING_OBJECT(dictionary, form_placeholder);
    self.textField.text = STRING_OBJECT(self.targetDictionary, STRING_OBJECT(self.dictionary, form_server_key));
}

- (BOOL)becomeFirstResponder
{
    [self.textField becomeFirstResponder];
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
    return [FormDataManager checkRegexWithString:self.textField.text reg:STRING_OBJECT(self.dictionary, form_check_regexp)];
}

@end

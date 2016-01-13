//
//  ActionSheetCell.m
//  TestForm
//
//  Created by caoyusheng on 1/9/15.
//  Copyright (c) 2015年 caoyusheng. All rights reserved.
//

#import "ActionSheetCell.h"
#import "ActionSheetCellView.h"

@interface ActionSheetCell()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation ActionSheetCell

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.textField.delegate = self;
    self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
}

-(void)setDictionary:(NSDictionary *)dictionary
{
    if (dictionary == self.dictionary) {
        return;
    }
    [super setDictionary:dictionary];
    
    self.nameLabel.text = STRING_OBJECT(dictionary, form_server_key_name);
    self.textField.placeholder = STRING_OBJECT(dictionary, form_placeholder);
    
    
    NSNumber* number = NUMBER_OBJECT(self.targetDictionary, STRING_OBJECT(self.dictionary, form_server_key));
    
    NSString* moreInfo = [self.dictionary objectForKey:form_datasource];
    if (moreInfo) {
        NSString* path = [[NSBundle mainBundle] pathForResource:moreInfo ofType:@"plist"];
        if (path) {
            NSDictionary* dictionar = [NSDictionary dictionaryWithContentsOfFile:path];
            NSArray* array = [dictionar objectForKey:@"data"];
            
            if ([array isKindOfClass:[NSArray class]]) {
                for (NSDictionary* dic in array) {
                    if ([[dic objectForKey:@"id"] isEqualToNumber:number]) {
                        self.textField.text = [dic objectForKey:@"name"];
                        break;
                    }
                }
            }
        }
    }
}

- (BOOL)becomeFirstResponder
{
    NSString* moreInfo = [self.dictionary objectForKey:form_datasource];
    if (moreInfo) {
        NSString* path = [[NSBundle mainBundle] pathForResource:moreInfo ofType:@"plist"];
        if (path) {
            NSDictionary* dictionar = [NSDictionary dictionaryWithContentsOfFile:path];
            if ([dictionar isKindOfClass:[NSDictionary class]]) {
                [ActionSheetCellView showActionSheetWithInfo:dictionar title:self.nameLabel.text selectedBlock:^(BOOL isCancel, id selectedValue) {
                    if (!isCancel) {
                        NSDictionary* dic = selectedValue;
                        self.textField.text = [dic objectForKey:@"name"];
                        if (self.delegate) {
                            [self.delegate baseFormCellNextStep:self];
                        }
                    }
                }];
            }
        }
    }
    
    return YES;
}

-(BOOL)resignFirstResponder
{
    [self endEditing:YES];
    return YES;
}

-(BOOL)check
{
    return self.textField.text.length > 0 ? YES : NO;
}

@end

//
//  FormTimeCell.m
//  FormApplication
//
//  Created by Maka on 15/11/16.
//  Copyright © 2015年 maka. All rights reserved.
//

#import "FormTimeCell.h"
#import "FormTimeCellView.h"

@interface FormTimeCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation FormTimeCell

-(void)setDictionary:(NSDictionary *)dictionary
{
    if (dictionary == self.dictionary) {
        return;
    }
    [super setDictionary:dictionary];
    
    self.titleLabel.text = STRING_OBJECT(dictionary, form_server_key_name);
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
    [FormTimeCellView showFormTimeCellViewWithBlock:^(id selectedItem) {
        if ([selectedItem isKindOfClass:[NSDate class]]) {
            NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"YYYY-mm-dd"];
            formatter.timeZone = [NSTimeZone systemTimeZone];
            self.textField.text = [formatter stringFromDate:selectedItem];
            if (self.delegate) {
                [self.delegate baseFormCellNextStep:self];
            }
        }
    } info:nil title:self.titleLabel.text];
    
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

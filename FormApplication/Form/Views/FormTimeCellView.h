//
//  FormTimeCellView.h
//  FormApplication
//
//  Created by Maka on 15/11/16.
//  Copyright © 2015年 maka. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^FormTimeCellViewBlock)(id selectedItem);

@interface FormTimeCellView : UIView

@property (nonatomic,copy) FormTimeCellViewBlock block;

+(instancetype)showFormTimeCellViewWithBlock:(FormTimeCellViewBlock)block info:(id)info title:(NSString*)title;

-(void)hide;

@end

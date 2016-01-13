//
//  LocationCellView.h
//  FormApplication
//
//  Created by Maka on 15/11/16.
//  Copyright © 2015年 maka. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LocationCellViewBlock)(NSArray* areas);

@interface LocationCellView : UIView

+(instancetype)showLocationCellViewWithInfo:(id)info callBack:(LocationCellViewBlock)block title:(NSString*)title;

@end

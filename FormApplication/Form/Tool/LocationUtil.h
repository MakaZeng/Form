//
//  LocationUtil.h
//  wolaidai
//
//  Created by Seven on 4/17/15.
//  Copyright (c) 2015 welab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

typedef void(^LocationBlock)(BOOL success,CLPlacemark* placeMark);

@interface LocationUtil : NSObject<CLLocationManagerDelegate, UIAlertViewDelegate>

+(instancetype)shareInstance;

-(void)requireCurrentLocationWithBlock:(LocationBlock)block;

@end

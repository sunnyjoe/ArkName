//
//  ANMemberEventJoinRateViewController.h
//  ArkNameSystem
//
//  Created by Jiao on 11/8/15.
//  Copyright (c) 2015 ArkName. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ANBasicViewController.h"

@interface ANMemberEventJoinRateViewController : ANBasicViewController
@property(strong, nonatomic) NSMutableDictionary *memberJoinDic;
@property(assign, nonatomic) NSInteger eventTotalTime;
@property(strong, nonatomic) NSString *fromDateStr;
@property(strong, nonatomic) NSString *toDateStr;
@end

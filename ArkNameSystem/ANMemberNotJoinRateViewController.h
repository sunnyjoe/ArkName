//
//  ANMemberNotJoinRateViewController.h
//  ArkNameSystem
//
//  Created by Sunny XiaoQing on 12/8/15.
//  Copyright (c) 2015 ArkName. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ANBasicViewController.h"

#define kArkNameMinDate @"1000-01-01"

@interface ANMemberNotJoinRateViewController : ANBasicViewController
@property(strong, nonatomic) NSMutableDictionary *memberJoinDate;
@property(strong, nonatomic) NSMutableDictionary *memberJoinCnt;

@property(assign, nonatomic) NSInteger eventTotalTime;
@property(strong, nonatomic) NSString *fromDateStr;
@property(strong, nonatomic) NSString *toDateStr;
@end

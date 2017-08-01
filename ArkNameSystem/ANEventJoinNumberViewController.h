//
//  ANEventJoinNumberViewController.h
//  ArkNameSystem
//
//  Created by Sunny XiaoQing on 12/8/15.
//  Copyright (c) 2015 ArkName. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ANEventJoinNumberViewController : UIViewController
@property(strong, nonatomic) NSString *fromDateStr;
@property(strong, nonatomic) NSString *toDateStr;
@property(strong, nonatomic) NSString *eventName;
@property(strong, nonatomic) NSArray *orderedDate;
@property(strong, nonatomic) NSMutableDictionary *eventJoin;
@end

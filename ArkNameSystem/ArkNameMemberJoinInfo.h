//
//  ArkNameMemberJoinInfo.h
//  ArkNameSystem
//
//  Created by Sunny XiaoQing on 30/7/15.
//  Copyright (c) 2015 ArkName. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ArkNameMemberJoinInfo : NSManagedObject

@property (nonatomic, retain) NSString * date;
@property (nonatomic, retain) NSString * eventName;
@property (nonatomic, retain) NSString * name;

@end

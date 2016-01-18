//
//  ANStatis.h
//  ArkNameSystem
//
//  Created by Jiao on 22/8/15.
//  Copyright (c) 2015 ArkName. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ANStatis : NSObject
@property (strong, nonatomic, readonly)  NSDateFormatter *dateFormatter;

+ (instancetype)instance;
- (NSMutableDictionary *)getMemberJoinCount:(NSArray *)eventJoinedArray;
- (NSArray *)sortMemberByJoinTime:(BOOL)ascending memJoinDic:(NSDictionary *)memJoin;
- (NSMutableArray *)extractEventDateStr:(NSArray *)eventJoinedArray;
- (NSArray *)extractEventDate:(NSArray *)eventJoinedArray;
- (NSString *)extractDateJoinNumber:(NSArray *)eventJoinedArray;

@end

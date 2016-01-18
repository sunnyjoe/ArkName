//
//  ANStatis.m
//  ArkNameSystem
//
//  Created by Jiao on 22/8/15.
//  Copyright (c) 2015 ArkName. All rights reserved.
//

#import "ANStatis.h"
#import "ArkNameMemberJoinInfo.h"
#import "NSDate+WQCalendarLogic.h"

@interface ANStatis()
@property (strong, nonatomic)  NSDateFormatter *dateFormatter;
@end

@implementation ANStatis

static ANStatis *sharedInstance;
+ (instancetype)instance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [self new];
    });
    return sharedInstance;
}

-(id)init
{
    NSAssert(!sharedInstance, @"This should be a singleton class.");
    self = [super init];
    if(self) {
    }
    
    return self;
}

-(NSDateFormatter *)dateFormatter{
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"yyyy-MM-dd"];
    }
    return _dateFormatter;
}


-(NSMutableDictionary *)getMemberJoinCount:(NSArray *)eventJoinedArray{
    NSMutableArray *memberList = [NSMutableArray new];
    
    for (ArkNameMemberJoinInfo *join in eventJoinedArray) {
        BOOL exist = NO;
        for (NSString *item in memberList) {
            if ([item isEqualToString:join.name]) {
                exist = YES;
                break;
            }
        }
        if (!exist) {
            [memberList addObject:join.name];
        }
    }
    NSMutableDictionary *memJoin = [NSMutableDictionary new];
    for (NSString *oneMember in memberList) {
        for (ArkNameMemberJoinInfo *join in eventJoinedArray) {
            if ([join.name isEqualToString:oneMember]) {
                NSNumber *time = memJoin[join.name];
                NSInteger count = time.integerValue;
                count ++;
                memJoin[join.name] = @(count);
            }
        }
    }
    
    return memJoin;
}

-(NSArray *)sortMemberByJoinTime:(BOOL)ascending memJoinDic:(NSDictionary *)memJoin{
    NSArray *sortedName;
    if (!ascending) {
        
        sortedName = [memJoin keysSortedByValueUsingComparator: ^(id obj1, id obj2) {
            if ([obj1 integerValue] < [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            if ([obj1 integerValue] > [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
    }else{
        sortedName = [memJoin keysSortedByValueUsingComparator: ^(id obj1, id obj2) {
            if ([obj1 integerValue] > [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            if ([obj1 integerValue] < [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
    }
    return sortedName;
}

-(NSMutableArray *)extractEventDateStr:(NSArray *)eventJoinedArray{
    NSMutableArray *dateStrList = [NSMutableArray new];
    
    for (ArkNameMemberJoinInfo *join in eventJoinedArray) {
        BOOL exist = NO;
        for (NSString *item in dateStrList) {
            if ([item isEqualToString:join.date]) {
                exist = YES;
                break;
            }
        }
        if (!exist) {
            [dateStrList addObject:join.date];
        }
    }
    
    return dateStrList;
}

- (NSArray *)extractEventDate:(NSArray *)eventJoinedArray{
    NSMutableArray *dateStrList = [[ANStatis instance] extractEventDateStr:eventJoinedArray];
    
    NSMutableArray *dateList = [NSMutableArray new];
    for (NSString *dateStr in dateStrList) {
        [dateList addObject:[self.dateFormatter dateFromString:dateStr]];
    }
    
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"self"
                                                               ascending:NO];
    NSArray *descriptors = [NSArray arrayWithObject:descriptor];
    NSArray *orderedDates = [dateList sortedArrayUsingDescriptors:descriptors];
    
    return orderedDates;
}

- (NSString *)extractDateJoinNumber:(NSArray *)eventJoinedArray{
    NSArray *orderedDates = [self extractEventDate:eventJoinedArray];
    
    NSString *content = @"";
    for (NSDate *oneDay in orderedDates) {
        content = [NSString stringWithFormat:@"%@%@, 参加人员, ", content, [oneDay stringFromDate:oneDay]];
        NSInteger cnt = 0;
        for (ArkNameMemberJoinInfo *join in eventJoinedArray) {
            if ([join.date isEqualToString:[oneDay stringFromDate:oneDay]]) {
                if (cnt == 0) {
                    content = [NSString stringWithFormat:@"%@ %@", content, join.name];
                }else{
                    content = [NSString stringWithFormat:@"%@, %@", content, join.name];
                }
                cnt ++;
            }
        }
        content = [NSString stringWithFormat:@"%@\n", content];
    }
    return content;
}
@end

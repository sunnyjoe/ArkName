//
//  ArkNameDataContainer.h
//  ArkNameSystem
//
//  Created by Sunny XiaoQing on 27/7/15.
//  Copyright (c) 2015 ArkName. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NSPersistentStoreCoordinator;

@interface ArkNameDataContainer : NSObject
+ (instancetype)instance;
- (void)setupWithCoordinator:(NSPersistentStoreCoordinator *)coordinator;
- (BOOL)save;

-(NSArray *)fetchMember:(NSString *)name;
-(BOOL)insertMember:(NSString *)name;
-(BOOL)removeMember:(NSString *)name;

-(NSArray *)fetchEvents:(NSString *)name;
-(BOOL)insertEvent:(NSString *)name;
-(BOOL)removeEvent:(NSString *)name;

-(NSArray *)fetchMemberJoinInfo:(NSString *)eventName from:(NSDate *)fromDate to:(NSDate *)toDate;
-(NSArray *)fetchMemberJoinInfo:(NSString *)eventName inDate:(NSString *)date;
-(void)updateMemberJoinInfo:(NSArray *)members inEvent:(NSString *)eventName inDate:(NSString *)date;

-(void)eventAsFirstChoice:(NSString *)eventName;
-(NSString *)fetchFirstChoose;

-(BOOL)replaceMember:(NSString *)oldName newName:(NSString *)name;
@end

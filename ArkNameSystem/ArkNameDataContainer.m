//
//  ArkNameDataContainer.m
//  ArkNameSystem
//
//  Created by Sunny XiaoQing on 27/7/15.
//  Copyright (c) 2015 ArkName. All rights reserved.
//

#import "ArkNameDataContainer.h"
#import <CoreData/CoreData.h>
#import "ArkNameMembers.h"
#import <Foundation/Foundation.h>
#import "ArkNameMemberJoinInfo.h"

#define kArkNameDataStoreMembersEntityName @"ArkNameMembers"
#define kArkNameDataStoreEventsEntityName @"ArkNameEvents"
#define kArkNameDataStoreEventsJoinEntityName @"ArkNameMemberJoinInfo"
#define kANFirstChoiceEvent @"kANFirstChoiceEvent"

@interface ArkNameDataContainer ()

@property (nonatomic, strong) NSManagedObjectContext *context;

@end

@implementation ArkNameDataContainer
static ArkNameDataContainer *sharedInstance;
+ (instancetype)instance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [self new];
    });
    return sharedInstance;
}


- (void)setupWithCoordinator:(NSPersistentStoreCoordinator *)coordinator
{
    NSAssert(coordinator, @"'coordinator' should not be nil");
    self.context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    self.context.persistentStoreCoordinator = coordinator;
}

- (BOOL)save
{
    if (![self.context hasChanges]) {
        return YES;
    }
    NSError *error;
    if (![self.context save:&error]) {
        return NO;
    }
    return YES;
}

-(NSArray *)fetchMember:(NSString *)name{
    NSString *predicate = nil;
    if (name.length) {
       predicate = [NSString stringWithFormat:@"name==\"%@\"",name];
    }
    
    NSArray *rs = [self getObjectsForName:kArkNameDataStoreMembersEntityName withPredicate:predicate isIdOnly:NO];
    return rs;
}

-(BOOL)insertMember:(NSString *)name{
    NSString *predicate = [NSString stringWithFormat:@"name==\"%@\"",name];
    NSArray *rs = [self getObjectsForName:kArkNameDataStoreMembersEntityName withPredicate:predicate isIdOnly:YES];
    ArkNameMembers *oneMember = nil;
    if (!rs.count) {
        oneMember = [self insertObjectForName:kArkNameDataStoreMembersEntityName];
        oneMember.name = name;
        return YES;
    }
    return NO;
}

-(BOOL)replaceMember:(NSString *)oldName newName:(NSString *)name{
    NSString *predicate = [NSString stringWithFormat:@"name==\"%@\"",oldName];
    NSArray *rs = [self getObjectsForName:kArkNameDataStoreMembersEntityName withPredicate:predicate isIdOnly:YES];
    if (!rs.count) {
        return YES;
    }
    for (ArkNameMembers *member in rs) {
        member.name = name;
    }
 
    predicate =  [NSString stringWithFormat:@"name==\"%@\"", oldName];
    rs = [self getObjectsForName:kArkNameDataStoreEventsJoinEntityName withPredicate:predicate isIdOnly:YES];
    if (!rs.count) {
        return YES;
    }
    for (ArkNameMemberJoinInfo *ej in rs) {
        ej.name = name;
    }
    return YES;
}

-(BOOL)removeMember:(NSString *)name{
    NSString *predicate = [NSString stringWithFormat:@"name==\"%@\"",name];
    NSArray *rs = [self getObjectsForName:kArkNameDataStoreMembersEntityName withPredicate:predicate isIdOnly:YES];
    if (!rs.count) {
        return NO;
    }
    for (ArkNameMembers *member in rs) {
        [self.context deleteObject:member];
    }
    return YES;
}

/*************/
-(NSArray *)fetchEvents:(NSString *)name{
    NSString *predicate = nil;
    if (name.length) {
        predicate = [NSString stringWithFormat:@"name==\"%@\"",name];
    }
    
    NSArray *rs = [self getObjectsForName:kArkNameDataStoreEventsEntityName withPredicate:predicate isIdOnly:NO];
    return rs;
}

-(BOOL)insertEvent:(NSString *)name{
    NSString *predicate = [NSString stringWithFormat:@"name==\"%@\"",name];
    NSArray *rs = [self getObjectsForName:kArkNameDataStoreEventsEntityName withPredicate:predicate isIdOnly:YES];
    ArkNameMembers *oneMember = nil;
    if (!rs.count) {
        oneMember = [self insertObjectForName:kArkNameDataStoreEventsEntityName];
        oneMember.name = name;
        return YES;
    }else{
      return NO;
    }
}

-(BOOL)removeEvent:(NSString *)name{
    NSString *predicate = [NSString stringWithFormat:@"name==\"%@\"",name];
    NSArray *rs = [self getObjectsForName:kArkNameDataStoreEventsEntityName withPredicate:predicate isIdOnly:YES];
    
    if (!rs.count) {
        return NO;
    }
    for (ArkNameMembers *member in rs) {
        [self.context deleteObject:member];
    }
    return YES;
}
/*************/
-(NSArray *)fetchMemberJoinInfo:(NSString *)eventName from:(NSDate *)fromDate to:(NSDate *)toDate{
    NSString *predicate =  [NSString stringWithFormat:@"eventName==\"%@\"", eventName];
    NSArray *rs = [self getObjectsForName:kArkNameDataStoreEventsJoinEntityName withPredicate:predicate isIdOnly:YES];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSMutableArray *joined = [NSMutableArray new];
    for (ArkNameMemberJoinInfo *item in rs) {
        NSDate *itemDate = [dateFormatter dateFromString:item.date];
         if( [itemDate timeIntervalSinceDate:fromDate] >= 0  && [itemDate timeIntervalSinceDate:toDate] <= 0){
             [joined addObject:item];
         }
    }
    return joined;
}

-(NSArray *)fetchMemberJoinInfo:(NSString *)eventName inDate:(NSString *)date{
    NSString *predicate =  [NSString stringWithFormat:@"eventName==\"%@\" AND date==\"%@\"", eventName, date];
    NSArray *rs = [self getObjectsForName:kArkNameDataStoreEventsJoinEntityName withPredicate:predicate isIdOnly:YES];
    return rs;
}

-(void)updateMemberJoinInfo:(NSArray *)members inEvent:(NSString *)eventName inDate:(NSString *)date{
    NSString *predicate =  [NSString stringWithFormat:@"eventName==\"%@\" AND date==\"%@\"", eventName, date];
    NSArray *rs = [self getObjectsForName:kArkNameDataStoreEventsJoinEntityName withPredicate:predicate isIdOnly:YES];
    
    for (ArkNameMemberJoinInfo *memberJoin in rs) {
        [self.context deleteObject:memberJoin];
    }
    
    for (NSString *member in members) {
        ArkNameMemberJoinInfo *info = [self insertObjectForName:kArkNameDataStoreEventsJoinEntityName];
        info.name = member;
        info.date = date;
        info.eventName = eventName;
    }
}

/*************/
-(NSArray *)getObjectsForName:(NSString *)entityName withPredicate:(NSString *)predicate isIdOnly:(BOOL)idOnly{
    NSFetchRequest *fetchRequest = [self fetchRequestForName:entityName idOnly:idOnly predicate:predicate];
    
    NSError *error;
    NSArray *objects = [self.context executeFetchRequest:fetchRequest error:&error];
    if (error) {
        return nil;
    }
    return objects;
}

- (NSFetchRequest *)fetchRequestForName:(NSString *)name idOnly:(BOOL)idOnly predicate:(NSString *)predicate
{
    NSFetchRequest *fetchRequest = [NSFetchRequest new];
    fetchRequest.entity = [NSEntityDescription entityForName:name inManagedObjectContext:self.context];
    fetchRequest.includesPropertyValues = !idOnly;
    if (predicate) {
        fetchRequest.predicate = [NSPredicate predicateWithFormat:predicate];
    }
    return fetchRequest;
}

- (id)insertObjectForName:(NSString *)name
{
    return [NSEntityDescription insertNewObjectForEntityForName:name inManagedObjectContext:self.context];
}

/**************/
-(void)eventAsFirstChoice:(NSString *)eventName{
    [[NSUserDefaults standardUserDefaults] setObject:eventName forKey:kANFirstChoiceEvent];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSString *)fetchFirstChoose{
     return [[NSUserDefaults standardUserDefaults] stringForKey:kANFirstChoiceEvent];
}

@end

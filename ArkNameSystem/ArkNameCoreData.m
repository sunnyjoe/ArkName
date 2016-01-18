//
//  ArkNameCoreData.m
//  ArkNameSystem
//
//  Created by Sunny XiaoQing on 27/7/15.
//  Copyright (c) 2015 ArkName. All rights reserved.
//

#import "ArkNameCoreData.h"
#import "ArkNameDataContainer.h"
#import <CoreData/CoreData.h>

@implementation ArkNameCoreData
+(void)initData{
    [[ArkNameDataContainer instance] setupWithCoordinator:[self persistentStoreCoordinatorWithModelName:@"ArkNameDataStore"]];
}

+ (NSManagedObjectModel *)managedObjectModelWithName:(NSString *)name
{
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"momd"];
    return [[NSManagedObjectModel alloc] initWithContentsOfURL:[NSURL URLWithString:path]];
}

+ (NSURL *)storeURLWithName:(NSString *)name
{
    NSURL *dirUrl = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *storeURL = [dirUrl URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", name]];
    return storeURL;
}

+ (NSPersistentStoreCoordinator *)persistentStoreCoordinatorWithModelName:(NSString *)modelName
{
    NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModelWithName:modelName]];
    NSError *error = nil;
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                  configuration:nil
                                                            URL:[self storeURLWithName:modelName]
                                                        options:@{ NSMigratePersistentStoresAutomaticallyOption: @(YES),
                                                                   NSInferMappingModelAutomaticallyOption: @(YES) }
                                                          error:&error]) {
//        [DJLog error:DJ_DATABASE content:[error description]];
        return nil;
    }
    return persistentStoreCoordinator;
}
@end

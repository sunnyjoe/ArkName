//
//  NSObject+Dataconvert.h
//  ArkNameSystem
//
//  Created by Qing Jiao on 31/7/17.
//  Copyright © 2017 ArkName. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>
#import "ArkNameEvents.h"

@interface Dataconvert: NSObject
+(NSString *)convertNameEvent:(NSManagedObject *)object;

@end

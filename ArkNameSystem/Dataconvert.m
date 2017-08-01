//
//  NSObject+Dataconvert.m
//  ArkNameSystem
//
//  Created by Qing Jiao on 31/7/17.
//  Copyright © 2017 ArkName. All rights reserved.
//

#import "Dataconvert.h"

@implementation Dataconvert: NSObject

+(NSString *)convertNameEvent:(NSManagedObject *)object {
  ArkNameEvents *event = (ArkNameEvents *)object;
  return event.name;
}

@end

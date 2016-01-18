//
//  ANEventEditorViewController.h
//  ArkNameSystem
//
//  Created by Sunny XiaoQing on 27/7/15.
//  Copyright (c) 2015 ArkName. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ANBasicViewController.h"

@class ArkNameEvents;

@interface ANEventEditorViewController : ANBasicViewController
@property (strong, nonatomic) ArkNameEvents *startEvent;
@end

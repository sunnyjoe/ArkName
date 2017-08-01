//
//  ANEventJoinViewController.h
//  ArkNameSystem
//
//  Created by Sunny XiaoQing on 27/7/15.
//  Copyright (c) 2015 ArkName. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ArkNameEvents;

@interface ANEventJoinViewController : UIViewController
@property (strong, nonatomic) NSString *eventName;

@property (strong, nonatomic) UICollectionView *notJoinedCollectionView;
@property (strong, nonatomic) UICollectionView *joinedCollectionView;
@property (strong, nonatomic) UIButton *editorBtn;
@property (strong, nonatomic) UIButton *saveBtn;
@property (strong, nonatomic) UIButton *selectDateBtn;
@property (strong, nonatomic) UILabel *joinedLabel;
@property (strong, nonatomic) UILabel *notJoinedLabel;
@property (strong, nonatomic) UIView *dateBGView;
@property (assign, nonatomic) BOOL didEdit;
@property (strong, nonatomic) NSArray *sortedNumber;
@property (strong, nonatomic) UIView *editorView;
@property (strong, nonatomic) NSMutableArray *joinedArray;
@property (strong, nonatomic) NSMutableArray *notJoinedArray;
@property (strong, nonatomic) NSArray *eventJoinedArray;
@property (strong, nonatomic) NSString *selectDateStr;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) UILabel *joinNumberLb;
@property (strong, nonatomic) UITextField *searchNameTF;

@property (strong, nonatomic) NSMutableArray *searchArray;
@property (strong, nonatomic) NSString *selectedSearchName;
@property (assign, nonatomic) BOOL inSearch;

-(void)refreshJoinedMember:(NSMutableArray *)members;
-(void)refreshNotJoinedMember:(NSMutableArray *)members;
- (void)saveBtnDidClick;
@end

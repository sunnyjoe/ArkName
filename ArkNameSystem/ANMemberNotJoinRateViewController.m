//
//  ArkNameMemberNotJoinRateViewController.m
//  ArkNameSystem
//
//  Created by Sunny XiaoQing on 12/8/15.
//  Copyright (c) 2015 ArkName. All rights reserved.
//

#import "ANMemberNotJoinRateViewController.h"
#import "Color.h"

@interface ANMemberNotJoinRateViewController ()
@property (strong, nonatomic) UIScrollView *contentScrollView;
@end

@implementation ANMemberNotJoinRateViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor whiteColor];
  self.title = [NSString stringWithFormat:@"%@ 至 %@", self.fromDateStr, self.toDateStr];
  
  self.edgesForExtendedLayout = UIRectEdgeNone;
  [self buildUI];
}

-(void)buildUI{
  self.contentScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
  [self.view addSubview:self.contentScrollView];
  
  UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.contentScrollView.frame.size.width, 50)];
  [self.contentScrollView addSubview:countLabel];
  countLabel.textAlignment = NSTextAlignmentCenter;
  countLabel.textColor = [UIColor blackColor];
  countLabel.text = [NSString stringWithFormat:@"一共%ld次活动", (long)self.eventTotalTime];
  [countLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:22]];
  
  float yHeight = 50;
  NSArray *sortedName;
  sortedName = [self.memberJoinCnt keysSortedByValueUsingComparator: ^(id obj1, id obj2) {
    if ([obj1 integerValue] < [obj2 integerValue]) {
      return (NSComparisonResult)NSOrderedDescending;
    }
    if ([obj1 integerValue] > [obj2 integerValue]) {
      return (NSComparisonResult)NSOrderedAscending;
    }
    return (NSComparisonResult)NSOrderedSame;
  }];
  
  for (NSString *member in sortedName) {
    NSInteger time = ((NSNumber *)self.memberJoinCnt[member]).integerValue;
    if (time == 0) {
      continue;
    }
    
    UILabel *bgLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, yHeight, self.contentScrollView.frame.size.width - 20, 40)];
    [self.contentScrollView addSubview:bgLabel];
    bgLabel.layer.borderWidth = 1;
    bgLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    bgLabel.textAlignment = NSTextAlignmentLeft;
    bgLabel.textColor = [UIColor blackColor];
    if ([self.memberJoinDate[member] isEqualToString:kArkNameMinDate]) {
      bgLabel.text = [NSString stringWithFormat:@"%@ 最近%ld次没有参加", member, (long)time];
    }else{
      bgLabel.text = [NSString stringWithFormat:@"%@ 最近%ld次没有参加 最后参加日期%@", member, (long)time, self.memberJoinDate[member]];
    }
    [bgLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18]];
    
    yHeight += bgLabel.frame.size.height + 15;
  }
  
  self.contentScrollView.contentSize = CGSizeMake(self.view.frame.size.width, yHeight + 50);
  
}

-(void)viewWillLayoutSubviews{
  [super viewWillLayoutSubviews];
  
  NSArray *subviews = [NSArray arrayWithArray:self.view.subviews];
  for (UIView *one in subviews) {
    [one removeFromSuperview];
  }
  self.edgesForExtendedLayout = UIRectEdgeNone;
  [self buildUI];
}

@end

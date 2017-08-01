//
//  ANEventJoinNumberViewController.m
//  ArkNameSystem
//
//  Created by Sunny XiaoQing on 12/8/15.
//  Copyright (c) 2015 ArkName. All rights reserved.
//

#import "ANEventJoinNumberViewController.h"
#import "NSDate+WQCalendarLogic.h"
#import "ANEventJoinMemberViewInfoController.h"

@interface ANEventJoinNumberViewController ()
@property (strong, nonatomic) UIScrollView *contentScrollView;
@end

@implementation ANEventJoinNumberViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = [NSString stringWithFormat:@"%@ 至 %@", self.fromDateStr, self.toDateStr];
  self.view.backgroundColor = [UIColor whiteColor];
  
  self.edgesForExtendedLayout = UIRectEdgeNone;
  [self buildUI];
}

-(void)buildUI{
  self.contentScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
  [self.view addSubview:self.contentScrollView];
  
  float yHeight = 20;
  
  NSInteger cnt = 0;
  for (NSDate *date in self.orderedDate) {
    NSString *day = [date stringFromDate:date];
    
    NSInteger time = ((NSNumber *)self.eventJoin[day]).integerValue;
    
    UIButton *bgLabel = [[UIButton alloc] initWithFrame:CGRectMake(10, yHeight, self.contentScrollView.frame.size.width - 20, 40)];
    [self.contentScrollView addSubview:bgLabel];
    bgLabel.layer.borderWidth = 1;
    bgLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    bgLabel.tag = cnt;
    cnt ++;
    bgLabel.titleLabel.textAlignment = NSTextAlignmentLeft;
    [bgLabel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [bgLabel setTitle:[NSString stringWithFormat:@"%@ 参加人数: %ld", day, (long)time] forState:UIControlStateNormal];
    [bgLabel.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:24]];
    
    [bgLabel addTarget:self action:@selector(eventLableDidTap:) forControlEvents:UIControlEventTouchUpInside];
    yHeight += bgLabel.frame.size.height + 15;
  }
  
  self.contentScrollView.contentSize = CGSizeMake(self.view.frame.size.width, yHeight + 50);
  
}

-(IBAction)eventLableDidTap:(id)sender{
  UIButton *label = (UIButton *)sender;
  if (label.tag < self.orderedDate.count) {
    ANEventJoinMemberViewInfoController *vc = [ANEventJoinMemberViewInfoController new];
    vc.eventName = self.eventName;
    vc.dateStr = [self.orderedDate[label.tag] stringFromDate:self.orderedDate[label.tag]];
    [self.navigationController pushViewController:vc animated:YES];
  }
}

-(void)viewWillLayoutSubviews{
  [super viewWillLayoutSubviews];
  NSArray *subviews = [NSArray arrayWithArray:self.view.subviews];
  for (UIView *one in subviews) {
    [one removeFromSuperview];
  }
  
  [self buildUI];
}


@end

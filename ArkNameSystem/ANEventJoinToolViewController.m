//
//  ANEventJoinToolViewController.m
//  ArkNameSystem
//
//  Created by Sunny XiaoQing on 27/7/15.
//  Copyright (c) 2015 ArkName. All rights reserved.
//

#import "ANEventJoinToolViewController.h"
#import <MessageUI/MFMailComposeViewController.h>
#import "Color.h"
#import "CalendarViewController.h"
#import "ArkNameDataContainer.h"
#import "ArkNameEvents.h"
#import "ArkNameMemberJoinInfo.h"
#import "ANMemberEventJoinRateViewController.h"
#import "ANMemberNotJoinRateViewController.h"
#import "ArkNameMembers.h"
#import "ANEventJoinNumberViewController.h"
#import "ANStatis.h"

@interface ANEventJoinToolViewController ()<MFMailComposeViewControllerDelegate>
@property (strong, nonatomic) CalendarViewController *calenderVC;
@property (strong, nonatomic) UIButton *fromDateBtn;
@property (strong, nonatomic) UIButton *toDateBtn;
@property (strong, nonatomic) NSArray *eventJoinedArray;
@property (strong, nonatomic) UILabel *countLabel;
@property (strong, nonatomic)  NSDateFormatter *dateFormatter;
@end

@implementation ANEventJoinToolViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor whiteColor];
  
  self.title = @"数据备份和统计";
  
  self.calenderVC = [[CalendarViewController alloc]init];
  self.dateFormatter = [ANStatis instance].dateFormatter;
}

- (void)buildUI {
  
  float YHeight = 64;
  {
    UIView *dataBackUpView = [[UIView alloc] initWithFrame:CGRectMake(0, YHeight, self.view.frame.size.width, 100)];
    [self.view addSubview:dataBackUpView];
    
    UILabel *info1 = [[UILabel alloc] initWithFrame:CGRectMake(dataBackUpView.frame.size.width / 2 - 170, 0, 30, dataBackUpView.frame.size.height)];
    [dataBackUpView addSubview:info1];
    info1.text = @"从";
    [info1 setFont:[UIFont fontWithName:@"HelveticaNeue" size:24]];
    
    if (!self.fromDateBtn) {
      self.fromDateBtn = [UIButton new];
      self.fromDateBtn.tag = 0;
      [self.fromDateBtn addTarget:self action:@selector(selectDateBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
      [self.fromDateBtn.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:22]];
      self.fromDateBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
      [self.fromDateBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
      [self.fromDateBtn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
      [self.fromDateBtn setTitle:[NSDate getDateString:[NSDate date]] forState:UIControlStateNormal];
      [self.fromDateBtn sizeToFit];
    }
    [dataBackUpView addSubview:self.fromDateBtn];
    self.fromDateBtn.frame = CGRectMake(0, 0, 120, dataBackUpView.frame.size.height);
    
    UILabel *info2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 3, 30, dataBackUpView.frame.size.height)];
    [dataBackUpView addSubview:info2];
    info2.text = @"到";
    [info2 setFont:[UIFont fontWithName:@"HelveticaNeue" size:24]];
    [info2 sizeToFit];
    info2.frame = CGRectMake(self.view.frame.size.width / 2 - info2.frame.size.width / 2, 0, info2.frame.size.width, dataBackUpView.frame.size.height);
    self.fromDateBtn.frame = CGRectMake(info2.frame.origin.x - 10 - self.fromDateBtn.frame.size.width, 0, self.fromDateBtn.frame.size.width, dataBackUpView.frame.size.height);
    
    if (!self.toDateBtn) {
      self.toDateBtn = [UIButton new];
      self.toDateBtn.tag = 1;
      [self.toDateBtn addTarget:self action:@selector(selectDateBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
      [self.toDateBtn.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:22]];
      self.toDateBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
      [self.toDateBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
      [self.toDateBtn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
      [self.toDateBtn setTitle:[NSDate getDateString:[NSDate date]] forState:UIControlStateNormal];
    }
    [dataBackUpView addSubview:self.toDateBtn];
    self.toDateBtn.frame = CGRectMake(CGRectGetMaxX(info2.frame) + 10, info2.frame.origin.y, 120, dataBackUpView.frame.size.height);
    
    YHeight += dataBackUpView.frame.size.height - 10;
  }
  {
    if (!self.countLabel) {
      self.countLabel = [UILabel new];
      self.countLabel.textAlignment = NSTextAlignmentCenter;
      self.countLabel.textColor = [UIColor blackColor];
      [self checkDateRange:NO];
      self.countLabel.text = [NSString stringWithFormat:@"一共%lu次活动", (unsigned long)[[ANStatis instance] extractEventDateStr:self.eventJoinedArray].count];
      [self.countLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:22]];
    }
    self.countLabel.frame = CGRectMake(0, YHeight, self.view.frame.size.width, 30);
    [self.view addSubview:self.countLabel];
    YHeight += self.countLabel.frame.size.height + 45;
  }
  float btnWidth = 200;
  float btnHeight = 50;
  float spacing = 30;
  CGRect btnRect = CGRectMake(self.view.frame.size.width / 2 - btnWidth / 2, YHeight, btnWidth, btnHeight);
  {
    UIButton *emailBtn = [[UIButton alloc] initWithFrame:btnRect];
    [self.view addSubview:emailBtn];
    [emailBtn.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:20]];
    emailBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [emailBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [emailBtn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [emailBtn setTitle:@"活动数据备份" forState:UIControlStateNormal];
    emailBtn.backgroundColor = COLOR_THEME2;
    [emailBtn addTarget:self action:@selector(sendDataToEmail) forControlEvents:UIControlEventTouchUpInside];
    YHeight += emailBtn.frame.size.height + spacing;
  }
  {
    btnRect = CGRectMake(self.view.frame.size.width / 2 - btnWidth / 2, YHeight, btnWidth, btnHeight);
    UIButton *joinNumberBtn = [[UIButton alloc] initWithFrame:btnRect];
    [self.view addSubview:joinNumberBtn];
    [joinNumberBtn.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:20]];
    joinNumberBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [joinNumberBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [joinNumberBtn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [joinNumberBtn setTitle:@"活动人数统计" forState:UIControlStateNormal];
    joinNumberBtn.backgroundColor = COLOR_THEME2;
    [joinNumberBtn addTarget:self action:@selector(joinNumberBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    YHeight += joinNumberBtn.frame.size.height + spacing;
  }
  {
    btnRect = CGRectMake(self.view.frame.size.width / 2 - btnWidth / 2, YHeight, btnWidth, btnHeight);
    UIButton *joinRateBtn = [[UIButton alloc] initWithFrame:btnRect];
    [self.view addSubview:joinRateBtn];
    [joinRateBtn.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:20]];
    joinRateBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [joinRateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [joinRateBtn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [joinRateBtn setTitle:@"人员出席率统计" forState:UIControlStateNormal];
    joinRateBtn.backgroundColor = COLOR_THEME2;
    [joinRateBtn addTarget:self action:@selector(joinRateBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    YHeight += joinRateBtn.frame.size.height + spacing;
  }
  {
    btnRect = CGRectMake(self.view.frame.size.width / 2 - btnWidth / 2, YHeight, btnWidth, btnHeight);
    UIButton *notJoinRateBtn = [[UIButton alloc] initWithFrame:btnRect];
    [self.view addSubview:notJoinRateBtn];
    [notJoinRateBtn.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:20]];
    notJoinRateBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [notJoinRateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [notJoinRateBtn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [notJoinRateBtn setTitle:@"人员缺席情况" forState:UIControlStateNormal];
    notJoinRateBtn.backgroundColor = COLOR_THEME2;
    [notJoinRateBtn addTarget:self action:@selector(notJoinRateBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    YHeight += notJoinRateBtn.frame.size.height + spacing;
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

- (BOOL)checkDateRange:(BOOL)showAlert{
  NSDate *fromDate = [[NSDate alloc] init];
  fromDate = [self.dateFormatter dateFromString:self.fromDateBtn.titleLabel.text];
  NSDate *toDate = [[NSDate alloc] init];
  toDate = [self.dateFormatter dateFromString:self.toDateBtn.titleLabel.text];
  if( [toDate timeIntervalSinceDate:fromDate] < 0){
    if (showAlert) {
      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                      message:@"请选择合理的日期范围"
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
      [alert show];
    }
    return NO;
  }
  
  self.eventJoinedArray = [[ArkNameDataContainer instance] fetchMemberJoinInfo:self.eventName from:fromDate to:toDate];
  if (self.eventJoinedArray.count == 0) {
    if (showAlert) {
      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                      message:@"此日期范围内没有人参加活动"
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
      [alert show];
    }
    return NO;
  }
  return YES;
}

- (IBAction)selectDateBtnDidClick:(id)sender {
  __weak ANEventJoinToolViewController *weakSelf = self;
  self.calenderVC.calendarblock = ^(CalendarDayModel *model){
    if (((UIButton *)sender).tag == 0) {
      [weakSelf.fromDateBtn setTitle:[model toString] forState:UIControlStateNormal];
    }else{
      [weakSelf.toDateBtn setTitle:[model toString] forState:UIControlStateNormal];
    }
    
    [weakSelf checkDateRange:NO];
    weakSelf.countLabel.text = [NSString stringWithFormat:@"一共%lu次活动", (unsigned long)[[ANStatis instance] extractEventDateStr:weakSelf.eventJoinedArray].count];
  };
  
  [self.navigationController pushViewController:self.calenderVC animated:YES];
}

- (void)notJoinRateBtnDidClick{
  if (![self checkDateRange:YES]) {
    return;
  }
  
  NSMutableArray *totalMember = [NSMutableArray arrayWithArray:[[ArkNameDataContainer instance] fetchMember:nil]];
  
  NSMutableDictionary *memJoin = [NSMutableDictionary new];
  for (ArkNameMembers *member in totalMember) {
    NSString *minDate = kArkNameMinDate;
    for (ArkNameMemberJoinInfo *join in self.eventJoinedArray) {
      if ([member.name isEqualToString:join.name]) {
        if ([[self.dateFormatter dateFromString:join.date] compare:[self.dateFormatter dateFromString:minDate]] == NSOrderedDescending) {
          minDate = join.date;
        }
      }
    }
    memJoin[member.name] = minDate;
  }
  
  NSMutableDictionary *memNotJoinCnt = [NSMutableDictionary new];
  NSArray *orderedDates = [[ANStatis instance] extractEventDate:self.eventJoinedArray];
  for (NSString *member in [memJoin allKeys]) {
    NSDate *latest = [self.dateFormatter dateFromString:memJoin[member]];
    NSInteger count = 0;
    for (NSDate *day in orderedDates) {
      if ([latest compare:day] == NSOrderedAscending) {
        count ++;
      }
    }
    memNotJoinCnt[member] = @(count);
  }
  
  ANMemberNotJoinRateViewController *notJoinVC = [ANMemberNotJoinRateViewController new];
  notJoinVC.memberJoinCnt = memNotJoinCnt;
  notJoinVC.memberJoinDate = memJoin;
  notJoinVC.eventTotalTime = [[ANStatis instance] extractEventDateStr:self.eventJoinedArray].count;
  notJoinVC.fromDateStr = self.fromDateBtn.titleLabel.text;
  notJoinVC.toDateStr = self.toDateBtn.titleLabel.text;
  [self.navigationController pushViewController:notJoinVC animated:YES];
}

- (void)joinNumberBtnDidClick{
  if (![self checkDateRange:YES]) {
    return;
  }
  
  NSArray *dateList = [[ANStatis instance] extractEventDate:self.eventJoinedArray];
  NSMutableDictionary *eventJoin = [NSMutableDictionary new];
  
  for (NSDate *day in dateList) {
    for (ArkNameMemberJoinInfo *join in self.eventJoinedArray) {
      if ([join.date isEqualToString:[day stringFromDate:day]]) {
        NSNumber *time = eventJoin[join.date];
        NSInteger count = time.integerValue;
        count ++;
        eventJoin[join.date] = @(count);
      }
    }
  }
  
  ANEventJoinNumberViewController *notJoinVC = [ANEventJoinNumberViewController new];
  notJoinVC.eventJoin = eventJoin;
  notJoinVC.eventName = self.eventName;
  notJoinVC.orderedDate = [[ANStatis instance] extractEventDate:self.eventJoinedArray];
  notJoinVC.fromDateStr = self.fromDateBtn.titleLabel.text;
  notJoinVC.toDateStr = self.toDateBtn.titleLabel.text;
  [self.navigationController pushViewController:notJoinVC animated:YES];
}

- (void)joinRateBtnDidClick{
  if (![self checkDateRange:YES]) {
    return;
  }
  ANMemberEventJoinRateViewController *joinVC = [ANMemberEventJoinRateViewController new];
  joinVC.memberJoinDic = [[ANStatis instance] getMemberJoinCount:self.eventJoinedArray];
  joinVC.eventTotalTime = [[ANStatis instance] extractEventDateStr:self.eventJoinedArray].count;
  joinVC.fromDateStr = self.fromDateBtn.titleLabel.text;
  joinVC.toDateStr = self.toDateBtn.titleLabel.text;
  [self.navigationController pushViewController:joinVC animated:YES];
}

- (void)sendDataToEmail{
  if (![MFMailComposeViewController canSendMail]){
    return;
  }
  if (![self checkDateRange:YES]) {
    return;
  }
  
  NSString *content = [[ANStatis instance] extractDateJoinNumber:self.eventJoinedArray];
  
  MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
  controller.mailComposeDelegate = self;
  NSString *subject = [NSString stringWithFormat:@"%@ %@至%@ 活动数据",self.eventName, self.fromDateBtn.titleLabel.text, self.toDateBtn.titleLabel.text];
  [controller setToRecipients:@[@"yaucheming@gmail.com"]];
  [controller setSubject:subject];
  [controller setMessageBody:content isHTML:NO];
  [self.navigationController presentViewController:controller animated:YES completion:nil];
}

#pragma MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
  if (result == MFMailComposeResultSent) {
    NSLog(@"Sent!");
  }
  [self.navigationController.presentedViewController dismissViewControllerAnimated:YES completion:nil];
}

@end

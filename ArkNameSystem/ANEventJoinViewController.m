//
//  ANEventJoinViewController.m
//  ArkNameSystem
//
//  Created by Sunny XiaoQing on 27/7/15.
//  Copyright (c) 2015 ArkName. All rights reserved.
//

#import "ANEventJoinViewController.h"
#import "ArkNameEvents.h"
#import "ArkNameMembers.h"
#import "ANEventJoinToolViewController.h"
#import "ArkNameDataContainer.h"
#import "ANMumberCollectionViewCell.h"
#import "ArkNameMemberJoinInfo.h"
#import "CalendarViewController.h"
#import "Color.h"
#import "ANStatis.h"

@interface ANEventJoinViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UIAlertViewDelegate, UITextFieldDelegate>
@property (strong, nonatomic) CalendarViewController *calenderVC;
@property (strong, nonatomic) ANEventJoinToolViewController *toolVC;
@end

@implementation ANEventJoinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.eventName;
    self.view.backgroundColor = [UIColor whiteColor];
    {
        UIButton *dismissBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [dismissBtn setFrame:CGRectMake(0, 0, 22, 22)];
        [dismissBtn setImage:[UIImage imageNamed:@"CloseIcon"] forState:UIControlStateNormal];
        [dismissBtn setImage:[UIImage imageNamed:@"CloseIconPressed"] forState:UIControlStateHighlighted];
        [dismissBtn addTarget:self action:@selector(dismissBtnDidTap) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:dismissBtn];
        
        UIButton *settingButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [settingButton setFrame:CGRectMake(0, 0, 84, 44)];
        [settingButton addTarget:self action:@selector(settingsBtnDidTap) forControlEvents:UIControlEventTouchUpInside];
        [settingButton setTitle:@"数据处理" forState:UIControlStateNormal];
        [settingButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:settingButton];
    }
    {
        self.dateBGView = [UIView new];
        [self.view addSubview:self.dateBGView];
        self.calenderVC = [[CalendarViewController alloc]init];
        self.selectDateStr = [NSDate getDateString:[NSDate date]];
        
        self.selectDateBtn = [UIButton new];
        [self.selectDateBtn addTarget:self action:@selector(selectDateBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
        [self.selectDateBtn.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:24]];
        self.selectDateBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        [self.selectDateBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [self.selectDateBtn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        [self.selectDateBtn setTitle:self.selectDateStr forState:UIControlStateNormal];
        [self.dateBGView addSubview:self.selectDateBtn];
    }

    {

//        self.searchNameTF = [UITextField new];
//        [self.searchNameTF setFont:[UIFont fontWithName:@"HelveticaNeue" size:22]];
//        self.searchNameTF.placeholder = @"搜索";
//        self.searchNameTF.textColor = COLOR_THEME3;
//        [self.searchNameTF setReturnKeyType:UIReturnKeyDone];
//        self.searchNameTF.delegate = self;
//        [self.editorView addSubview:self.searchNameTF];
//        
//        self.notJoinedLabel = [UILabel new];
//        self.notJoinedLabel.userInteractionEnabled = true;
//        [self.notJoinedLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(notJoinedLabelDidTapped)]];
//        [self.notJoinedLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:22]];
//        self.notJoinedLabel.text = @"可选成员";
//        self.notJoinedLabel.textColor = COLOR_THEME3;
//        self.notJoinedLabel.textAlignment = NSTextAlignmentCenter;
//        [self.editorView addSubview:self.notJoinedLabel];
//        
//        UICollectionViewFlowLayout *collectionViewLayout = [UICollectionViewFlowLayout new];
//        collectionViewLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
//        collectionViewLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
//        self.notJoinedCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:collectionViewLayout];
//        [self.editorView addSubview:self.notJoinedCollectionView];
//        self.notJoinedCollectionView.layer.borderColor = [UIColor darkGrayColor].CGColor;
//        self.notJoinedCollectionView.layer.borderWidth = 1;
//        self.notJoinedCollectionView.dataSource = self;
//        self.notJoinedCollectionView.delegate = self;
//        self.notJoinedCollectionView.backgroundColor = [UIColor whiteColor];
//        [self.notJoinedCollectionView registerClass:[ANMumberCollectionViewCell class] forCellWithReuseIdentifier:kArkNameEventJoinMumberCollectionCell];
//        [self.editorView addSubview:self.notJoinedCollectionView];
//        
//        self.saveBtn = [UIButton new];
//        [self.saveBtn setTitle:@"保存修改" forState:UIControlStateNormal];
//        [self.saveBtn addTarget:self action:@selector(saveBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
//        self.saveBtn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:20];
//        [self.saveBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//        [self.saveBtn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
//        [self.editorView addSubview:self.saveBtn];
    }
    
    [self getOrderedTotalNumber];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self refreshData:self.selectDateStr];
}


- (void)getOrderedTotalNumber{
    self.dateFormatter = [ANStatis instance].dateFormatter;
    NSArray *eventJoinedStatisArray = [[ArkNameDataContainer instance] fetchMemberJoinInfo:self.eventName from:[self.dateFormatter dateFromString:@"1000-10-01"] to:[NSDate date]];
    
    NSMutableDictionary *numberJoinCntDic = [[ANStatis instance] getMemberJoinCount:eventJoinedStatisArray];
    
    NSMutableArray *totalMember = [NSMutableArray arrayWithArray:[[ArkNameDataContainer instance] fetchMember:nil]];
    for (ArkNameMembers *member in totalMember) {
        if (![numberJoinCntDic objectForKey:member.name]) {
            numberJoinCntDic[member.name] = @(0);
        }
    }
    
    self.sortedNumber = [[ANStatis instance] sortMemberByJoinTime:NO memJoinDic:numberJoinCntDic];
}

- (void)dismissBtnDidTap {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (alertView.tag != 1000 && alertView.tag != 2000) {
        return;
    }
    
    if (buttonIndex == 1 && alertView.tag == 1000) {
        [self openDateViewController];
    }
}

- (void)selectDateBtnDidClick {
    if (self.didEdit){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒！"
                                                        message:@"选择日期前记得保存修改"
                                                       delegate:self
                                              cancelButtonTitle:@"取消选择日期"
                                              otherButtonTitles:@"继续", nil];
        alert.tag = 1000;
        [alert show];
    }else{
        [self openDateViewController];
    }
}

- (void)openDateViewController{
    __weak ANEventJoinViewController *weakSelf = self;
    self.calenderVC.calendarblock = ^(CalendarDayModel *model){
        [weakSelf.selectDateBtn setTitle:[NSString stringWithFormat:@"%@ %@",[model toString],[model getWeek]] forState:UIControlStateNormal];
        if (![weakSelf.selectDateStr isEqualToString:[model toString]]) {
            weakSelf.selectDateStr = [model toString];
            [weakSelf refreshData:weakSelf.selectDateStr];
        }
    };
    
    [self.navigationController pushViewController:self.calenderVC animated:YES];
    self.didEdit = NO;
}

- (void)settingsBtnDidTap{
    if (!self.toolVC) {
        self.toolVC = [ANEventJoinToolViewController new];
        self.toolVC.eventName = self.eventName;
    }
    [self.navigationController pushViewController:self.toolVC animated:YES];
}

-(void)refreshData:(NSString *)certainDateStr{
    self.eventJoinedArray = [[ArkNameDataContainer instance] fetchMemberJoinInfo:self.eventName inDate:certainDateStr];
    self.joinedArray = [NSMutableArray new];
    self.notJoinedArray = [NSMutableArray new];
    NSMutableArray *tmpNotJoinArray = [NSMutableArray new];
    
    NSMutableArray *totalMember = [NSMutableArray arrayWithArray:[[ArkNameDataContainer instance] fetchMember:nil]];
    for (ArkNameMembers *member in totalMember) {
        [tmpNotJoinArray addObject:member.name];
    }
    
    for (ArkNameMemberJoinInfo *join in self.eventJoinedArray) {
        [self.joinedArray addObject:join.name];
        [tmpNotJoinArray removeObject:join.name];
    }
    
    for (NSString *member in self.sortedNumber) {
        for (NSString *notMember in tmpNotJoinArray) {
            if ([member isEqualToString: notMember]) {
                [self.notJoinedArray insertObject:member atIndex:self.notJoinedArray.count];
            }
        }
    }
  
  [self refreshJoinedMember:self.joinedArray];
  [self refreshNotJoinedMember:self.notJoinedArray];
}

-(void)refreshJoinedMember:(NSMutableArray *)members {
}

-(void)refreshNotJoinedMember:(NSMutableArray *)members {
}

- (void)saveBtnDidClick{
    self.didEdit = NO;

    [[ArkNameDataContainer instance] updateMemberJoinInfo:self.joinedArray inEvent:self.eventName inDate:self.selectDateStr];
    [[ArkNameDataContainer instance] save];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:@"保存成功"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

@end

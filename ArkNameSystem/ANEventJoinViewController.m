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
@property (strong, nonatomic) CalendarViewController *calenderVC;
@property (strong, nonatomic) NSString *selectDateStr;
@property (strong, nonatomic) ANEventJoinToolViewController *toolVC;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) UILabel *joinNumberLb;
@property (strong, nonatomic) UITextField *searchNameTF;

@property (strong, nonatomic) NSMutableArray *searchArray;
@property (strong, nonatomic) NSString *selectedSearchName;
@property (assign, nonatomic) BOOL inSearch;
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
        self.joinedLabel = [UILabel new];
        [self.view addSubview:self.joinedLabel];
        self.joinedLabel.text = @"参加的人员";
        self.joinedLabel.textColor = COLOR_THEME3;
        [self.joinedLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:22]];
        self.joinedLabel.textAlignment = NSTextAlignmentCenter;
        
        self.joinNumberLb = [UILabel new];
        [self.view addSubview:self.joinNumberLb];
        self.joinNumberLb.text = @"(0)";
        self.joinNumberLb.textAlignment = NSTextAlignmentLeft;
        self.joinNumberLb.textColor = COLOR_THEME3;
        [self.joinNumberLb setFont:[UIFont fontWithName:@"HelveticaNeue" size:22]];
        self.joinNumberLb.textAlignment = NSTextAlignmentCenter;
        
        UICollectionViewFlowLayout *collectionViewLayout = [UICollectionViewFlowLayout new];
        collectionViewLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        collectionViewLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.joinedCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:collectionViewLayout];
        self.joinedCollectionView.layer.borderColor = [UIColor darkGrayColor].CGColor;
        self.joinedCollectionView.layer.borderWidth = 1;
        self.joinedCollectionView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:self.joinedCollectionView];
        self.joinedCollectionView.dataSource = self;
        self.joinedCollectionView.delegate = self;
        [self.joinedCollectionView registerClass:[ANMumberCollectionViewCell class] forCellWithReuseIdentifier:kArkNameEventJoinMumberCollectionCell];
        
        self.editorBtn = [UIButton new];
        [self.view addSubview:self.editorBtn];
        [self.editorBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [self.editorBtn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        [self.editorBtn addTarget:self action:@selector(editorBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
        self.editorBtn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:20];
        [self.editorBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    }
    {
        self.editorView = [UIView new];
        [self.view addSubview:self.editorView];
        
        self.searchNameTF = [UITextField new];
        [self.searchNameTF setFont:[UIFont fontWithName:@"HelveticaNeue" size:22]];
        self.searchNameTF.placeholder = @"搜索";
        self.searchNameTF.textColor = COLOR_THEME3;
        [self.searchNameTF setReturnKeyType:UIReturnKeyDone];
        self.searchNameTF.delegate = self;
        [self.editorView addSubview:self.searchNameTF];
        
        self.notJoinedLabel = [UILabel new];
        self.notJoinedLabel.userInteractionEnabled = true;
        [self.notJoinedLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(notJoinedLabelDidTapped)]];
        [self.notJoinedLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:22]];
        self.notJoinedLabel.text = @"可选成员";
        self.notJoinedLabel.textColor = COLOR_THEME3;
        self.notJoinedLabel.textAlignment = NSTextAlignmentCenter;
        [self.editorView addSubview:self.notJoinedLabel];
        
        UICollectionViewFlowLayout *collectionViewLayout = [UICollectionViewFlowLayout new];
        collectionViewLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        collectionViewLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        self.notJoinedCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:collectionViewLayout];
        [self.editorView addSubview:self.notJoinedCollectionView];
        self.notJoinedCollectionView.layer.borderColor = [UIColor darkGrayColor].CGColor;
        self.notJoinedCollectionView.layer.borderWidth = 1;
        self.notJoinedCollectionView.dataSource = self;
        self.notJoinedCollectionView.delegate = self;
        self.notJoinedCollectionView.backgroundColor = [UIColor whiteColor];
        [self.notJoinedCollectionView registerClass:[ANMumberCollectionViewCell class] forCellWithReuseIdentifier:kArkNameEventJoinMumberCollectionCell];
        [self.editorView addSubview:self.notJoinedCollectionView];
        
        self.saveBtn = [UIButton new];
        [self.saveBtn setTitle:@"保存修改" forState:UIControlStateNormal];
        [self.saveBtn addTarget:self action:@selector(saveBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
        self.saveBtn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:20];
        [self.saveBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [self.saveBtn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        [self.editorView addSubview:self.saveBtn];
    }
    
    [self getOrderedTotalNumber];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self refreshData:self.selectDateStr];
}

-(void)adjustSubviewLayout{
    float viewHeight = self.navigationController.view.frame.size.height - 64;
    self.dateBGView.frame = CGRectMake(0, 0, self.view.frame.size.width, 20 + 25 + 25);
    self.selectDateBtn.frame = CGRectMake(0, 25, self.view.frame.size.width, 20);
    self.joinedLabel.frame = CGRectMake(self.view.frame.size.width / 2 - 60, 75, 120, 20);
    self.joinNumberLb.frame = CGRectMake(self.view.frame.size.width / 2 + 40, 75, 120, 20);
    if (self.editorView.hidden) {
        self.joinedCollectionView.frame = CGRectMake(10, 100, self.view.frame.size.width - 20, viewHeight - 120);
    }else{
        self.joinedCollectionView.frame = CGRectMake(10, 100, self.view.frame.size.width - 20, viewHeight / 2 - 100);
    }
    self.editorBtn.frame = CGRectMake(self.view.frame.size.width - 100, self.joinedLabel.frame.origin.y, 100, 20);
    self.editorView.frame = CGRectMake(0, CGRectGetMaxY(self.joinedCollectionView.frame), self.view.frame.size.width, viewHeight - CGRectGetMaxY(self.joinedCollectionView.frame) - 10);
    self.searchNameTF.frame = CGRectMake(10, 50, self.editorView.frame.size.width / 2 - 80, 20);
    self.notJoinedLabel.frame = CGRectMake(self.editorView.frame.size.width / 2 - 60, 50, 120, 20);
    self.notJoinedCollectionView.frame = CGRectMake(10, CGRectGetMaxY(self.notJoinedLabel.frame) + 10, self.view.frame.size.width - 20, self.editorView.frame.size.height - CGRectGetMaxY(self.notJoinedLabel.frame) - 10);
    self.saveBtn.frame = CGRectMake(self.editorView.frame.size.width - 100, self.notJoinedLabel.frame.origin.y, 100, 20);
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

- (void)hiddenEditorView:(BOOL)toHide{
    self.editorView.hidden = toHide;
    
    [self adjustSubviewLayout];
    [self.joinedCollectionView reloadData];
    [self.notJoinedCollectionView reloadData];
}

- (void)dismissBtnDidTap {
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)notJoinedLabelDidTapped{
    self.inSearch = false;
}

-(void)setInSearch:(BOOL)inSearch{
    _inSearch = inSearch;
    
    if (!_inSearch) {
        self.searchNameTF.text = nil;
    }
    [self.notJoinedCollectionView reloadData];
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self showSearchResult:textField.text];
    return YES;
}

- (void)showSearchResult:(NSString *)keyStr{
    if (keyStr == nil || keyStr.length == 0){
        self.inSearch = false;
        return;
    }
    
    self.searchArray = [NSMutableArray new];
    for (NSString *member in self.notJoinedArray) {
        if ([member rangeOfString:keyStr].location != NSNotFound) {
            [self.searchArray addObject:member];
        }
    }
    self.inSearch = true;
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (alertView.tag != 1000 && alertView.tag != 2000) {
        return;
    }
    
    if (buttonIndex == 1 && alertView.tag == 1000) {
        [self openDateViewController];
    }else if (buttonIndex == 1 && alertView.tag == 2000){
        [self hiddenEditorView:NO];
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
            if (![[NSDate getDateString:[NSDate date]] isEqualToString:[model toString]]){
                [weakSelf hiddenEditorView:YES];
            }else{
                [weakSelf hiddenEditorView:NO];
            }
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

- (void)editorBtnDidClick {
    if (self.editorView.hidden) {
        if (![[NSDate getDateString:[NSDate date]] isEqualToString:self.selectDateStr]){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒！"
                                                            message:@"这是历史数据，您确定要修改吗"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消编辑"
                                                  otherButtonTitles:@"继续", nil];
            alert.tag = 2000;
            [alert show];
        }else{
            [self hiddenEditorView:NO];
        }
    }else{
        [self hiddenEditorView:YES];
    }
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
    
    
    [self.joinedCollectionView reloadData];
    [self.notJoinedCollectionView reloadData];
}

- (void)saveBtnDidClick{
    [[ArkNameDataContainer instance] updateMemberJoinInfo:self.joinedArray inEvent:self.eventName inDate:self.selectDateStr];
    [[ArkNameDataContainer instance] save];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:@"保存成功"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}


#pragma UICollectionViewDataSource & UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == self.joinedCollectionView) {
        self.joinNumberLb.text = [NSString stringWithFormat:@"(%lu)", (unsigned long)self.joinedArray.count];
        return self.joinedArray.count;
    }else{
        if (self.inSearch) {
            return self.searchArray.count;
        }else{
            return self.notJoinedArray.count;
        }
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    ANMumberCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kArkNameEventJoinMumberCollectionCell forIndexPath:indexPath];
    NSString *memberName = nil;
    if (collectionView == self.joinedCollectionView) {
        memberName = self.joinedArray[indexPath.row];
    }else{
        if (self.inSearch) {
            memberName = self.searchArray[indexPath.row];
        }else{
            memberName = self.notJoinedArray[indexPath.row];
        }
    }
    cell.nameLabel.text = memberName;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.didEdit = YES;
    
    NSString *theMovedMember = nil;
    NSMutableArray *theMovedArray;
    if (collectionView == self.joinedCollectionView) {
        theMovedMember = self.joinedArray[indexPath.row];
        theMovedArray= self.joinedArray;
    }else{
        if (self.inSearch) {
            theMovedMember = self.searchArray[indexPath.row];
        }else{
            theMovedMember = self.notJoinedArray[indexPath.row];
        }
        
        theMovedArray = self.notJoinedArray;
    }
    
    NSString *tmpMember = nil;
    for (NSString *member in theMovedArray) {
        if ([member isEqualToString: theMovedMember]) {
            tmpMember = member;
            break;
        }
    }
    if (tmpMember) {
        [theMovedArray removeObject:tmpMember];
        
        if (collectionView == self.joinedCollectionView) {
            [self.notJoinedArray addObject:tmpMember];
        }else{
            [self.joinedArray addObject:tmpMember];
        }
    }
    self.inSearch = false;
    [self.joinedCollectionView reloadData];
    [self.notJoinedCollectionView reloadData];
}


- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *name = @"";
    if (collectionView == self.joinedCollectionView) {
        name = self.joinedArray[indexPath.row];
    }else{
        name = self.notJoinedArray[indexPath.row];
    }
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
    nameLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:19];
    nameLabel.text = name;
    [nameLabel sizeToFit];
    
    return CGSizeMake(MAX(nameLabel.frame.size.width + 12, 100), 40);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}


@end

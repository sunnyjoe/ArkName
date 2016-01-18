//
//  ANSettingMainViewController.m
//  ArkNameSystem
//
//  Created by Sunny XiaoQing on 27/7/15.
//  Copyright (c) 2015 ArkName. All rights reserved.
//

#import "ANSettingMainViewController.h"
#import "ANEventEditorViewController.h"
#import "ANEditorMemberViewController.h"
#import "ArkNameDataContainer.h"
#import "ArkNameEvents.h"
#import "Color.h"

@interface ANSettingMainViewController ()
@property (strong, nonatomic) UISegmentedControl *segmentedControl;
@property (strong, nonatomic) UIScrollView *eventView;
@property (strong, nonatomic) NSArray *eventsArray;
@property (strong, nonatomic) NSMutableArray *subEventViewsArray;
@property (strong, nonatomic) UIScrollView *memberView;
@property (strong, nonatomic) NSArray *memberArray;
@property (strong, nonatomic) NSMutableArray *subMemberViewsArray;

@end

@implementation ANSettingMainViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"设置";
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSArray *itemArray = [NSArray arrayWithObjects:@"管理活动",@"管理人员" , nil];
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
    [self.segmentedControl addTarget:self action:@selector(segmentControlAction:) forControlEvents: UIControlEventValueChanged];
    self.segmentedControl.selectedSegmentIndex = 0;
    self.segmentedControl.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.segmentedControl];
    
    self.eventView = [UIScrollView new];
    self.eventView.contentInset = UIEdgeInsetsMake(10, 0, 200, 0);
    [self.view addSubview:self.eventView];
    [self buildEventView];
    
    self.memberView = [UIScrollView new];
    self.memberView.contentInset = UIEdgeInsetsMake(10, 0, 200, 0);
    [self.view addSubview:self.memberView];
    self.memberView.hidden = YES;
    [self buildMemberView];
    
    self.eventsArray = [[ArkNameDataContainer instance] fetchEvents:nil];
    self.memberArray = [[ArkNameDataContainer instance] fetchMember:nil];
    
    [self.view addSubview:self.bgView];
}

-(void)viewWillAppear:(BOOL)animated{
    for (UIView *view in self.eventView.subviews) {
        [view removeFromSuperview];
    }
    for (UIView *view in self.memberView.subviews) {
        [view removeFromSuperview];
    }
    
    [super viewWillAppear:animated];
}

- (void)adjustSubviewLayout{
    self.segmentedControl.frame = CGRectMake(13, 14, self.view.frame.size.width - 26, 40);
    self.eventView.frame = CGRectMake(0, CGRectGetMaxY(self.segmentedControl.frame), self.view.frame.size.width, self.view.frame.size.height - CGRectGetMaxY(self.segmentedControl.frame) - 20);
     self.memberView.frame = CGRectMake(0, CGRectGetMaxY(self.segmentedControl.frame), self.view.frame.size.width, self.view.frame.size.height - CGRectGetMaxY(self.segmentedControl.frame) - 20);
    
    [self buildEventView];
    [self buildMemberView];
}

- (void)segmentControlAction:(UISegmentedControl *)segment
{
    NSInteger selectedSegmentIndex = segment.selectedSegmentIndex;
    
    if(selectedSegmentIndex == 0)
    {
        self.eventView.hidden = NO;
        self.memberView.hidden = YES;
        
    }else {
        self.eventView.hidden = YES;
        self.memberView.hidden = NO;
    }
}

-(void)buildEventView{
    self.eventsArray = [[ArkNameDataContainer instance] fetchEvents:nil];
    NSArray *subviews = [NSArray arrayWithArray:self.eventView.subviews];
    for (UIView *one in subviews) {
        [one removeFromSuperview];
    }
    
    NSInteger btnWidht = 180;
    NSInteger btnHeight = 160;
    NSInteger btnSpacing = 10;
    NSInteger numberOfColumn = (self.view.frame.size.width - 16) / (btnWidht + btnSpacing);
    NSInteger spacingX = (self.view.frame.size.width - numberOfColumn * btnWidht - (numberOfColumn - 1) * btnSpacing) / 2;
    NSInteger spacingY = 20;
    
    NSString *firstEvent = [[ArkNameDataContainer instance] fetchFirstChoose];
    self.subEventViewsArray = [NSMutableArray new];
    for (NSInteger index = 0; index < self.eventsArray.count; index ++) {
        NSInteger originalY = spacingY + (index / numberOfColumn) * (btnHeight + 20);
        NSInteger originalX = spacingX + (index % numberOfColumn) * (btnWidht + btnSpacing);
        
        ArkNameEvents *event = self.eventsArray[index];
        
        UIButton *eventBtn = [[UIButton alloc] initWithFrame:CGRectMake(originalX, originalY, btnWidht, btnHeight)];
        eventBtn.tag = index;
        eventBtn.backgroundColor = COLOR_THEME3;
        [eventBtn setTitle:event.name forState:UIControlStateNormal];
        [eventBtn addTarget:self action:@selector(eventBtnDidTap:) forControlEvents:UIControlEventTouchUpInside];
        [self.eventView addSubview:eventBtn];
        [self.subEventViewsArray addObject:eventBtn];
        

        if ([firstEvent isEqualToString:event.name]) {
            UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(btnWidht - 50, 5, 45, 45)];;
            [eventBtn addSubview:iconView];
            iconView.image = [UIImage imageNamed:@"FirstChoice"];
        }
    }
    
    NSInteger originalY = spacingY + (self.eventsArray.count / numberOfColumn) * (btnHeight + 20);
    NSInteger originalX = spacingX + (self.eventsArray.count % numberOfColumn) * (btnWidht + btnSpacing);
    
    UIButton *addBtn = [[UIButton alloc] initWithFrame:CGRectMake(originalX, originalY, btnWidht, btnHeight)];
    addBtn.backgroundColor = COLOR_THEME2;
    addBtn.tag = self.eventsArray.count;
    [addBtn setTitle:@"添加活动" forState:UIControlStateNormal];
    
    [self.eventView addSubview:addBtn];
    self.eventView.contentSize = CGSizeMake(self.eventView.frame.size.width, CGRectGetMaxY(addBtn.frame) + 64);
    [addBtn addTarget:self action:@selector(eventBtnDidTap:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)buildMemberView{
    self.memberArray = [[ArkNameDataContainer instance] fetchMember:nil];
    
    NSArray *subviews = [NSArray arrayWithArray:self.memberView.subviews];
    for (UIView *one in subviews) {
        [one removeFromSuperview];
    }
    
    
    NSInteger btnWidht = 130;
    NSInteger btnHeight = 55;
    NSInteger btnSpacing = 10;
    NSInteger numberOfColumn = (self.view.frame.size.width - 16) / (btnWidht + btnSpacing);
    NSInteger spacingX = (self.view.frame.size.width - numberOfColumn * btnWidht - (numberOfColumn - 1) * btnSpacing) / 2;
    NSInteger spacingY = 15;
    
    self.subMemberViewsArray = [NSMutableArray new];
    for (NSInteger index = 0; index < self.memberArray.count; index ++) {
        NSInteger originalY = spacingY + (index / numberOfColumn) * (btnHeight + 20);
        NSInteger originalX = spacingX + (index % numberOfColumn) * (btnWidht + btnSpacing);
        
        ArkNameEvents *member = self.memberArray[index];
        
        UIButton *eventBtn = [[UIButton alloc] initWithFrame:CGRectMake(originalX, originalY, btnWidht, btnHeight)];
        eventBtn.tag = index;
        eventBtn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:20];
        eventBtn.titleLabel.numberOfLines = 0;
        eventBtn.backgroundColor = COLOR_THEME3;
        [eventBtn setTitle:member.name forState:UIControlStateNormal];
        [eventBtn addTarget:self action:@selector(memberBtnDidTap:) forControlEvents:UIControlEventTouchUpInside];
        eventBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        [self.memberView addSubview:eventBtn];
        [self.subMemberViewsArray addObject:eventBtn];
    }
    
    NSInteger originalY = spacingY + (self.memberArray.count / numberOfColumn) * (btnHeight + 20);
    NSInteger originalX = spacingX + (self.memberArray.count % numberOfColumn) * (btnWidht + btnSpacing);
    
    UIButton *addBtn = [[UIButton alloc] initWithFrame:CGRectMake(originalX, originalY, btnWidht, btnHeight)];
    addBtn.backgroundColor = COLOR_THEME2;
    addBtn.tag = self.memberArray.count;
    [addBtn setTitle:@"添加弟兄姊妹" forState:UIControlStateNormal];
    [self.memberView addSubview:addBtn];
    self.memberView.contentSize = CGSizeMake(self.eventView.frame.size.width, CGRectGetMaxY(addBtn.frame) + 64);
    
    [addBtn addTarget:self action:@selector(memberBtnDidTap:) forControlEvents:UIControlEventTouchUpInside];
}

-(IBAction)eventBtnDidTap:(id)sender{
    UIButton *addBtn = (UIButton *)sender;
    if (addBtn.tag > self.eventsArray.count || addBtn.tag < 0) {
        return;
    }
    ANEventEditorViewController *eventVC = [ANEventEditorViewController new];
    if (addBtn.tag != self.eventsArray.count) {
        eventVC.startEvent = self.eventsArray[addBtn.tag];
    }
    [self.navigationController pushViewController:eventVC animated:YES];
}

-(IBAction)memberBtnDidTap:(id)sender{
    UIButton *addBtn = (UIButton *)sender;
    if (addBtn.tag > self.memberArray.count || addBtn.tag < 0) {
        return;
    }
    
    ANEditorMemberViewController *memberVC = [ANEditorMemberViewController new];
    if (addBtn.tag != self.memberArray.count) {
        memberVC.startMember = self.memberArray[addBtn.tag];
    }
    [self.navigationController pushViewController:memberVC animated:YES];
}
@end

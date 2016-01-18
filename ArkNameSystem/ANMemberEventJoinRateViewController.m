//
//  ANMemberEventJoinRateViewController.m
//  ArkNameSystem
//
//  Created by Jiao on 11/8/15.
//  Copyright (c) 2015 ArkName. All rights reserved.
//

#import "ANMemberEventJoinRateViewController.h"
#import "Color.h"
@interface ANMemberEventJoinRateViewController ()
@property (strong, nonatomic) UIScrollView *contentScrollView;
@end

@implementation ANMemberEventJoinRateViewController

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
    [countLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:26]];
    
    float yHeight = 50;
    NSArray *sortedName;
    sortedName = [self.memberJoinDic keysSortedByValueUsingComparator: ^(id obj1, id obj2) {
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];

    for (NSString *member in sortedName) {
        UILabel *bgLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, yHeight, self.contentScrollView.frame.size.width - 20, 40)];
        [self.contentScrollView addSubview:bgLabel];
        bgLabel.layer.borderWidth = 1;
        bgLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
        float time = ((NSNumber *)self.memberJoinDic[member]).floatValue;
        float width = bgLabel.frame.size.width * time / (float)self.eventTotalTime;
        UILabel *colorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, bgLabel.frame.size.height)];
        colorLabel.backgroundColor = COLOR_THEME2;
        [bgLabel addSubview:colorLabel];
        
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, bgLabel.frame.size.width, bgLabel.frame.size.height)];
        textLabel.backgroundColor = [UIColor clearColor];
        [bgLabel addSubview:textLabel];
        textLabel.textAlignment = NSTextAlignmentLeft;
        textLabel.textColor = [UIColor blackColor];
        textLabel.text = [NSString stringWithFormat:@"%@ (%.0f)", member, time];
        [textLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:24]];
        
        yHeight += bgLabel.frame.size.height + 15;
    }
    
    self.contentScrollView.contentSize = CGSizeMake(self.view.frame.size.width, MAX(yHeight + 50, self.view.frame.size.height));
    
}

-(void)adjustSubviewLayout{
    NSArray *subviews = [NSArray arrayWithArray:self.view.subviews];
    for (UIView *one in subviews) {
        [one removeFromSuperview];
    }
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self buildUI];
}

@end

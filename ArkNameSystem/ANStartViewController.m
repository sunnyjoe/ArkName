//
//  ViewController.m
//  ArkNameSystem
//
//  Created by Sunny XiaoQing on 27/7/15.
//  Copyright (c) 2015 ArkName. All rights reserved.
//

#import "ANStartViewController.h"
#import "ArkNameDataContainer.h"
#import "ArkNameEvents.h"
#import "ANSettingMainViewController.h"
#import "Color.h"
#import "ANEventJoinViewController.h"

#define kArkNameTableViewDefaultCell @"kArkNameTableViewDefaultCell"

@interface ANStartViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) UITableView *eventTableView;
@property (strong, nonatomic) NSMutableArray *eventsArray;
@end

@implementation ANStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"方舟活动统计系统";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.eventTableView = [UITableView new];
    self.eventTableView.contentInset = UIEdgeInsetsMake(50, 0, 50, 0);
    self.eventTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.eventTableView];
    self.eventTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.eventTableView.dataSource = self;
    self.eventTableView.delegate = self;
    [self.eventTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kArkNameTableViewDefaultCell];
    
    UIButton *settingButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [settingButton setFrame:CGRectMake(0, 0, 30, 30)];
    [settingButton addTarget:self action:@selector(settingsBtnDidTap) forControlEvents:UIControlEventTouchUpInside];
    [settingButton setImage:[UIImage imageNamed:@"SettingIcon"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:settingButton];
    
    [self.view addSubview:self.bgView];
}

- (void)adjustSubviewLayout{
    self.eventTableView.frame = CGRectMake(0, 10, self.view.frame.size.width, self.view.frame.size.height - 50);
    [self.eventTableView reloadData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSString *firstEvent = [[ArkNameDataContainer instance] fetchFirstChoose];
    self.eventsArray = [NSMutableArray arrayWithArray:[[ArkNameDataContainer instance] fetchEvents:nil]];
    
    if (firstEvent && self.eventsArray.count) {
        for (ArkNameEvents *item in self.eventsArray) {
            if ([item.name isEqualToString:firstEvent]) {
                [self.eventsArray removeObject:item];
                break;
            }
        }
    }
    [self.eventTableView reloadData];
    
    if (!self.eventsArray.count && !firstEvent) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"暂无活动"
                                                        message:@"请点击右上角设置添加活动"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)settingsBtnDidTap {
    [self.navigationController pushViewController:[ANSettingMainViewController new] animated:YES];
}

#pragma UITableViewDataSource & UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSString *firstEvent = [[ArkNameDataContainer instance] fetchFirstChoose];
    if (firstEvent) {
        return self.eventsArray.count + 1;
    }
    return self.eventsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *itemName = [[ArkNameDataContainer instance] fetchFirstChoose];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kArkNameTableViewDefaultCell];
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:34];
    
    if (indexPath.row == 0 && itemName) {
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:40];
    }else{
        if (!itemName) {
            ArkNameEvents *item = self.eventsArray[indexPath.row];
            itemName = item.name;
        }else if (indexPath.row - 1 < self.eventsArray.count){
            ArkNameEvents *item = self.eventsArray[indexPath.row - 1];
            itemName = item.name;
        }
    }
    
    cell.textLabel.text = itemName;
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.textColor = COLOR_THEME3;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     NSString *itemName = [[ArkNameDataContainer instance] fetchFirstChoose];
    if (indexPath.row == 0 && itemName) {
    }else{
        if (!itemName) {
            ArkNameEvents *item = self.eventsArray[indexPath.row];
            itemName = item.name;
        }else if (indexPath.row - 1 < self.eventsArray.count){
            ArkNameEvents *item = self.eventsArray[indexPath.row - 1];
            itemName = item.name;
        }
    }
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"ViewControllers" bundle:nil];
    ANEventJoinViewController *eventJoinVC = [sb instantiateViewControllerWithIdentifier:@"ANEventJoinViewController"];
    eventJoinVC.eventName = itemName;
    
    [self.navigationController presentViewController:[[UINavigationController alloc] initWithRootViewController:eventJoinVC] animated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}



@end

//
//  ANEventEditorViewController.m
//  ArkNameSystem
//
//  Created by Sunny XiaoQing on 27/7/15.
//  Copyright (c) 2015 ArkName. All rights reserved.
//

#import "ANEventEditorViewController.h"
#import "ArkNameDataContainer.h"
#import "ArkNameEvents.h"
#import "Color.h"

@interface ANEventEditorViewController ()
@property (strong, nonatomic) UIView *memberView;
@property (strong, nonatomic) UITextField *nameF;
@property (strong, nonatomic) UILabel *info;
@property (strong, nonatomic) UILabel *asFirst;
@property (strong, nonatomic) UIButton *deleteBtn;
@property (strong, nonatomic) UISwitch *firstSwitch;
@end

@implementation ANEventEditorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    if (!self.startEvent){
        self.title = @"添加活动";
    }else{
        self.title = self.startEvent.name;
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    if (!self.startEvent) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存"
                                                                                  style:UIBarButtonItemStylePlain
                                                                                 target:self
                                                                                 action:@selector(saveBtnDidTap)];
    }
    if (!self.startEvent){
        self.info = [UILabel new];
        [self.view addSubview:self.info];
        self.info.textColor = COLOR_THEME3;
        self.info.text = @"活动名称";
        self.info.textAlignment = NSTextAlignmentCenter;
        [self.info setFont:[UIFont fontWithName:@"HelveticaNeue" size:22]];
        
        self.nameF = [UITextField new];
        self.nameF.font = [UIFont fontWithName:@"HelveticaNeue" size:24];
        self.nameF.backgroundColor = [UIColor whiteColor];
        self.nameF.layer.borderColor = [UIColor grayColor].CGColor;
        self.nameF.layer.borderWidth = 1;
        [self.view addSubview:self.nameF];
    }
    
    NSArray *rs = [[ArkNameDataContainer instance] fetchEvents:self.startEvent.name];
    if (rs.count && self.startEvent) {
        self.deleteBtn = [UIButton new];
        [self.view addSubview:self.deleteBtn];
        self.deleteBtn.backgroundColor = [UIColor whiteColor];
        [self.deleteBtn setTitle:@"删除活动" forState:UIControlStateNormal];
        [self.deleteBtn addTarget:self action:@selector(deleteBtnDidTap) forControlEvents:UIControlEventTouchUpInside];
        self.deleteBtn.layer.borderColor = [UIColor darkGrayColor].CGColor;
        self.deleteBtn.layer.borderWidth = 1;
        self.deleteBtn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:24];
        [self.deleteBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
    
    __weak ANEventEditorViewController *weakSelf = self;
    self.firstSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(100, 0, 0, 0)];
    [self.view addSubview:self.firstSwitch];
    [self.firstSwitch addTarget:weakSelf
                         action:@selector(firstSwitchValueDidChange:)
               forControlEvents:UIControlEventValueChanged];
    
    self.asFirst = [UILabel new];
    [self.view addSubview:self.asFirst];
    self.asFirst.textColor = COLOR_THEME3;
    self.asFirst.text = @"作为首选项";
    self.asFirst.textAlignment = NSTextAlignmentCenter;
    [self.asFirst setFont:[UIFont fontWithName:@"HelveticaNeue" size:22]];
    
    NSString *firstEvent = [[ArkNameDataContainer instance] fetchFirstChoose];
    if ([self.startEvent.name isEqualToString:firstEvent]) {
        self.firstSwitch.on = YES;
    }else{
        self.firstSwitch.on = NO;
    }
    
    [self.view addSubview:self.bgView];
    [self adjustSubviewLayout];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.nameF becomeFirstResponder];
}

- (void)firstSwitchValueDidChange:(UISwitch *)firstSwitch
{
    if (firstSwitch.on && self.startEvent.name){
        [[ArkNameDataContainer instance] eventAsFirstChoice:self.startEvent.name];
    }
}

-(void)adjustSubviewLayout{
    self.info.frame = CGRectMake(self.view.frame.size.width / 2 - 100, 50, 200, 20);
    self.nameF.frame = CGRectMake(self.view.frame.size.width / 2 - 160, 90, 320, 50);
    self.deleteBtn.frame = CGRectMake(self.view.frame.size.width / 2 - 100, 70, 200, 50);
    
    self.asFirst.frame = CGRectMake(self.view.frame.size.width / 2 - 160, 170, 320, 50);
    self.firstSwitch.frame = CGRectMake(self.view.frame.size.width / 2 - self.firstSwitch.frame.size.width / 2, 220, 0, 0);
}

-(void)deleteBtnDidTap{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒！"
                                                    message:@"你确定要删除该活动? 请做好数据备份!"
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"删除", nil];
    alert.tag = 1000;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (alertView.tag != 1000) {
        return;
    }
    
    if (buttonIndex == 1) {
        [[ArkNameDataContainer instance] removeEvent:self.startEvent.name];
        [[ArkNameDataContainer instance] save];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"删除成功"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)saveBtnDidTap {
    NSString *trimmedStr = [self.nameF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    trimmedStr = [trimmedStr stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    if (!trimmedStr.length){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Opps"
                                                        message:@"活动名字不能为空"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    NSRange range = [trimmedStr rangeOfString:@","];
    if (range.location != NSNotFound)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Opps"
                                                        message:@"活动名字不能包含逗号"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if (![[ArkNameDataContainer instance] insertEvent:trimmedStr]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Opps"
                                                        message:@"活动名字已存在"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }else{
        [[ArkNameDataContainer instance] save];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"活动保存成功."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end

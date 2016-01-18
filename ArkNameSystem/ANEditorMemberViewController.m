//
//  ANEditorMemberViewController.m
//  ArkNameSystem
//
//  Created by Sunny XiaoQing on 27/7/15.
//  Copyright (c) 2015 ArkName. All rights reserved.
//

#import "ANEditorMemberViewController.h"
#import "ArkNameDataContainer.h"
#import "ArkNameMembers.h"
#import "Color.h"

@interface ANEditorMemberViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) UIView *memberView;
@property (strong, nonatomic) UITextField *nameF;
@property (strong, nonatomic) UILabel *info;
@property (strong, nonatomic) UIButton *deleteBtn;

@property (strong, nonatomic) UILabel *rpInfo;
@property (strong, nonatomic) UITextField *rpNameF;
@end

@implementation ANEditorMemberViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    if (!self.startMember){
        self.title = @"添加弟兄姊妹";
    }else{
        self.title = self.startMember.name;
    }
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(saveBtnDidTap)];
    if (!self.startMember){
        self.info = [UILabel new];
        [self.view addSubview:self.info];
        self.info.textColor = COLOR_THEME3;
        self.info.text = @"姓名";
        self.info.textAlignment = NSTextAlignmentCenter;
        [self.info setFont:[UIFont fontWithName:@"HelveticaNeue" size:22]];
        
        self.nameF = [UITextField new];
        self.nameF.font = [UIFont fontWithName:@"HelveticaNeue" size:24];
        self.nameF.backgroundColor = [UIColor whiteColor];
        self.nameF.layer.borderColor = [UIColor grayColor].CGColor;
        self.nameF.layer.borderWidth = 1;
        [self.view addSubview:self.nameF];
    }
    
    NSArray *rs = [[ArkNameDataContainer instance] fetchMember:self.startMember.name];
    if (rs.count && self.startMember) {
        self.navigationItem.rightBarButtonItem = nil;
        
        self.deleteBtn = [UIButton new];
        [self.view addSubview:self.deleteBtn];
        self.deleteBtn.backgroundColor = [UIColor whiteColor];
        [self.deleteBtn setTitle:@"删除该人员" forState:UIControlStateNormal];
        [self.deleteBtn addTarget:self action:@selector(deleteBtnDidTap) forControlEvents:UIControlEventTouchUpInside];
        self.deleteBtn.layer.borderColor = [UIColor darkGrayColor].CGColor;
        self.deleteBtn.layer.borderWidth = 1;
        self.deleteBtn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:24];
        [self.deleteBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [self.deleteBtn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        
        
        self.rpInfo = [UILabel new];
        [self.view addSubview:self.rpInfo];
        self.rpInfo.textColor = COLOR_THEME3;
        self.rpInfo.text = @"更改姓名为: ";
        self.rpInfo.textAlignment = NSTextAlignmentCenter;
        [self.rpInfo setFont:[UIFont fontWithName:@"HelveticaNeue" size:22]];
        
        self.rpNameF = [UITextField new];
        [self.rpNameF setReturnKeyType:UIReturnKeyDone];
        self.rpNameF.font = [UIFont fontWithName:@"HelveticaNeue" size:24];
        self.rpNameF.backgroundColor = [UIColor whiteColor];
        self.rpNameF.layer.borderColor = [UIColor grayColor].CGColor;
        self.rpNameF.layer.borderWidth = 1;
        self.rpNameF.delegate = self;
        [self.view addSubview:self.rpNameF];
    }
    [self.view addSubview:self.bgView];
    [self adjustSubviewLayout];
}


-(void)adjustSubviewLayout{
    self.info.frame = CGRectMake(self.view.frame.size.width / 2 - 100, 50, 200, 20);
    self.nameF.frame = CGRectMake(self.view.frame.size.width / 2 - 160, 90, 320, 50);
    
     self.rpInfo.frame = CGRectMake(self.view.frame.size.width / 2 - 100, 50, 200, 50);
     self.rpNameF.frame = CGRectMake(self.view.frame.size.width / 2 - 100, 100, 200, 50);
    self.deleteBtn.frame = CGRectMake(self.view.frame.size.width / 2 - 100, 660, 200, 50);
}

-(void)deleteBtnDidTap{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒！"
                                                    message:@"你确定要删除该成员?"
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
        [[ArkNameDataContainer instance] removeMember:self.startMember.name];
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
                                                        message:@"弟兄姐妹名字不能为空"
                                                       delegate:self
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
    
    if (![[ArkNameDataContainer instance] insertMember:trimmedStr]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Opps"
                                                        message:@"弟兄姐妹名字已存在"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }else{
        [[ArkNameDataContainer instance] save];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Opps"
                                                        message:@"弟兄姐妹添加成功."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [[ArkNameDataContainer instance] replaceMember:self.startMember.name newName:textField.text];
    [[ArkNameDataContainer instance] save];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:@"修改成功"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];

    return YES;
}
@end

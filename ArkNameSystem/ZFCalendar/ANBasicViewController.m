//
//  ANBasicViewController.m
//  ArkNameSystem
//
//  Created by Sunny XiaoQing on 24/8/15.
//  Copyright (c) 2015 ArkName. All rights reserved.
//

#import "ANBasicViewController.h"

@interface ANBasicViewController ()

@property (assign, nonatomic) CGRect bgViewRect;

@end


@implementation ANBasicViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(deviceOrientationDidChangeNotification:)
     name:UIDeviceOrientationDidChangeNotification
     object:nil];
    
    self.bgView = [UIImageView new];
    self.bgView.contentMode = UIViewContentModeScaleAspectFit;
    self.bgView.image = [UIImage imageNamed:@"CrossImage"];
    self.bgViewRect = CGRectMake(self.navigationController.view.frame.size.width - 150, self.navigationController.view.frame.size.height - 300, 150, 300);
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.bgView.frame = self.bgViewRect;
    [self adjustSubviewLayout];
    
}

- (void)deviceOrientationDidChangeNotification:(NSNotification*)note
{
    self.bgView.frame = self.bgViewRect;
    [self adjustSubviewLayout];
}

- (void)adjustSubviewLayout{
    
}

@end

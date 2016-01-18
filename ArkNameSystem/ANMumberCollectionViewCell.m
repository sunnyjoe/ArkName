//
//  ANMumberCollectionViewCell.m
//  ArkNameSystem
//
//  Created by Sunny XiaoQing on 30/7/15.
//  Copyright (c) 2015 ArkName. All rights reserved.
//

#import "ANMumberCollectionViewCell.h"
#import "Color.h"

@interface ANMumberCollectionViewCell ()

@end

@implementation ANMumberCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self buildUI];
    }
    return self;
}

-(void)buildUI{
    self.nameLabel = [UILabel new];
    self.nameLabel.backgroundColor = COLOR_THEME3;
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    self.nameLabel.textColor = [UIColor whiteColor];
    self.nameLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:19];
    [self addSubview:self.nameLabel];
}

-(void)layoutSubviews{
     self.nameLabel.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

@end

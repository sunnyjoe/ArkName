//
//  ETIMonthHeaderView.m
//  CalendarIOS7
//
//  Created by Jerome Morissard on 3/3/14.
//  Copyright (c) 2014 Jerome Morissard. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import "CalendarMonthHeaderView.h"
#import "Color.h"

@interface CalendarMonthHeaderView ()
@end


#define CATDayLabelWidth  40.0f
#define CATDayLabelHeight 20.0f

@implementation CalendarMonthHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

- (void)setup
{
    
    self.clipsToBounds = YES;
    
    //月份
    UILabel *masterLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.f, 20.0f, self.frame.size.width - 20, 30.f)];
    [masterLabel setBackgroundColor:[UIColor clearColor]];
    [masterLabel setTextAlignment:NSTextAlignmentCenter];
    [masterLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:21.0f]];
    self.masterLabel = masterLabel;
    self.masterLabel.textColor = COLOR_THEME;
    [self addSubview:self.masterLabel];
    
//    CGFloat xOffset = 5.0f;
//    CGFloat yOffset = 45.0f;
//    NSArray *nameDay = [NSArray arrayWithObjects:@"日", @"一", @"二", @"三", @"四", @"五", @"六",nil];
//    NSInteger counter = 0;
//    NSInteger maxRepeate = (self.frame.size.width - xOffset) / ((xOffset + CATDayLabelWidth) * 7);
//    while (xOffset < self.frame.size.width && counter < maxRepeate * 7) {
//        UILabel *dayLabel = [[UILabel alloc]initWithFrame:CGRectMake(xOffset,yOffset, CATDayLabelWidth, CATDayLabelHeight)];
//        [dayLabel setBackgroundColor:[UIColor clearColor]];
//        [dayLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15.0f]];
//        dayLabel.textAlignment = NSTextAlignmentCenter;
//        dayLabel.textColor = COLOR_THEME1;
//        dayLabel.text = nameDay[counter % 7];
//        [self addSubview:dayLabel];
//        xOffset += CATDayLabelWidth + 5.0f;
//        counter ++;
//    }

}



@end

//
//  CalendarLogic1.m
//  Calendar
//
//  Created by 张凡 on 14-7-3.
//  Copyright (c) 2014年 张凡. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import "CalendarLogic.h"

@interface CalendarLogic ()
{
    NSDate *today;//今天的日期
    NSDate *select;//选择的日期
    CalendarDayModel *selectcalendarDay;
}

@end


@implementation CalendarLogic

//计算当前日期之前几天或者是之后的几天（负数是之前几天，正数是之后的几天）
- (NSMutableArray *)getInitCalendarViewMonthWithStartDate:(NSDate *)selectdate
{
    if (selectdate == nil) {
        selectdate = [NSDate date];
    }
    
    today = selectdate;//起始日期
    select = selectdate;//选择的日期
    

    NSDateComponents *pastDC= [[selectdate dayInTheFollowingDay:(-365 * 5)] YMDComponents];
    NSDateComponents *futureDC= [[selectdate dayInTheFollowingDay:(365 * 5)] YMDComponents];

    NSInteger months = (futureDC.year - pastDC.year) * 12 + (futureDC.month - pastDC.month);
    NSMutableArray *calendarMonth = [[NSMutableArray alloc]init];//每个月的dayModel数组
    
    NSDate *pastStartDate = [selectdate dayInTheFollowingDay:(-365 * 5)];
    for (int i = 0; i <= months; i++) {
        NSDate *month = [pastStartDate dayInTheFollowingMonth:i];
        NSMutableArray *calendarDays = [[NSMutableArray alloc]init];
        [self calculateDaysInPreviousMonthWithDate:month andArray:calendarDays];
        [self calculateDaysInCurrentMonthWithDate:month andArray:calendarDays];
        [self calculateDaysInFollowingMonthWithDate:month andArray:calendarDays];//计算下月份的天数
        [calendarMonth insertObject:calendarDays atIndex:i];
    }
    
    return calendarMonth;
}



#pragma mark - 日历上+当前+下月份的天数

//计算上月份的天数
- (NSMutableArray *)calculateDaysInPreviousMonthWithDate:(NSDate *)date andArray:(NSMutableArray *)array
{
    NSUInteger weeklyOrdinality = [[date firstDayOfCurrentMonth] weeklyOrdinality];//计算这个的第一天是礼拜几,并转为int型
    NSDate *dayInThePreviousMonth = [date dayInThePreviousMonth];//上一个月的NSDate对象
    NSUInteger daysCount = [dayInThePreviousMonth numberOfDaysInCurrentMonth];//计算上个月有多少天
    NSUInteger partialDaysCount = weeklyOrdinality - 1;//获取上月在这个月的日历上显示的天数
    NSDateComponents *components = [dayInThePreviousMonth YMDComponents];//获取年月日对象
    
    for (int i = daysCount - partialDaysCount + 1; i < daysCount + 1; ++i) {
        
        CalendarDayModel *calendarDay = [CalendarDayModel calendarDayWithYear:components.year month:components.month day:i];
        calendarDay.style = CellDayTypeEmpty;//不显示
        [array addObject:calendarDay];
    }
    
    return NULL;
}



//计算下月份的天数

- (void)calculateDaysInFollowingMonthWithDate:(NSDate *)date andArray:(NSMutableArray *)array
{
    NSUInteger weeklyOrdinality = [[date lastDayOfCurrentMonth] weeklyOrdinality];
    if (weeklyOrdinality == 7) return ;
    
    NSUInteger partialDaysCount = 7 - weeklyOrdinality;
    NSDateComponents *components = [[date dayInTheFollowingMonth] YMDComponents];
    
    for (int i = 1; i < partialDaysCount + 1; ++i) {
        CalendarDayModel *calendarDay = [CalendarDayModel calendarDayWithYear:components.year month:components.month day:i];
        calendarDay.style = CellDayTypeEmpty;
        [array addObject:calendarDay];
    }
}


//计算当月的天数
- (void)calculateDaysInCurrentMonthWithDate:(NSDate *)date andArray:(NSMutableArray *)array
{
    
    NSUInteger daysCount = [date numberOfDaysInCurrentMonth];//计算这个月有多少天
    NSDateComponents *components = [date YMDComponents];//今天日期的年月日
    
    for (int i = 1; i < daysCount + 1; ++i) {
        CalendarDayModel *calendarDay = [CalendarDayModel calendarDayWithYear:components.year month:components.month day:i];
        calendarDay.week = [[calendarDay date]getWeekIntValueWithDate];
        [self changStyle:calendarDay];
        [array addObject:calendarDay];
    }
}


- (void)changStyle:(CalendarDayModel *)calendarDay
{
    
    NSDateComponents *calendarToDay  = [today YMDComponents];//今天
    NSDateComponents *calendarSelect = [select YMDComponents];//默认选择的那一天
    
    
    //被点击选中
    if(calendarSelect.year == calendarDay.year &
       calendarSelect.month == calendarDay.month &
       calendarSelect.day == calendarDay.day){
        
        calendarDay.style = CellDayTypeClick;
        selectcalendarDay = calendarDay;
    }else if (calendarDay.week != 1 && calendarDay.week != 7){
        if (calendarToDay.year > calendarDay.year || (calendarToDay.year == calendarDay.year && calendarToDay.month > calendarDay.month) ||
            (calendarToDay.year == calendarDay.year && calendarToDay.month == calendarDay.month && calendarToDay.day > calendarDay.day)) {
            calendarDay.style = CellDayTypePast;
        }else{
            calendarDay.style = CellDayTypeFutur;
        }
    }else{
        calendarDay.style = CellDayTypeWeek;
    }
    
    //今天
    if (calendarToDay.year == calendarDay.year &&
        calendarToDay.month == calendarDay.month &&
        calendarToDay.day == calendarDay.day) {
        calendarDay.holiday = @"今天";
    }
}


- (void)selectLogic:(CalendarDayModel *)day
{
    
    if (day.style == CellDayTypeClick) {
        return;
    }
    
    day.style = CellDayTypeClick;
    //周末
    if (selectcalendarDay.week == 1 || selectcalendarDay.week == 7){
        selectcalendarDay.style = CellDayTypeWeek;
        //工作日
    }else{
        selectcalendarDay.style = CellDayTypeFutur;
    }
    selectcalendarDay = day;
}


@end

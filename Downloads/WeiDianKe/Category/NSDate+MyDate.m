//
//  NSDate+MyDate.m
//  ttdoctor
//
//  Created by zichenfang on 16/3/15.
//  Copyright © 2016年 zichenfang. All rights reserved.
//

#import "NSDate+MyDate.h"

@implementation NSDate (MyDate)


- (NSString *)formatTimeInyyyyMMddHHmmss
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    formatter.timeZone = [NSTimeZone systemTimeZone];
    NSString * str = [formatter stringFromDate:self];
    return str;
}
//转化成yyyy-MM-dd 格式的时间
- (NSString *)formatTimeInyyyyMMdd
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    formatter.timeZone = [NSTimeZone systemTimeZone];
    NSString * str = [formatter stringFromDate:self];
    return str;
}
- (NSString *)roughTimeDes
{
    long long timeValue = [[NSDate date] timeIntervalSince1970] -[self timeIntervalSince1970];
    NSString *tailDes = @"前";
    if (timeValue<0) {
        tailDes = @"后";
    }
    NSString *headDes;
    timeValue = llabs(timeValue);
    if (timeValue<60)//一分钟之内
    {
        headDes = [NSString stringWithFormat:@"%lld秒",timeValue];
    }
    else if (timeValue<60*60)//一个小时之内
    {
        headDes = [NSString stringWithFormat:@"%lld分钟",timeValue/60];
    }
    else if (timeValue<60*60*24)//一天之内
    {
        headDes = [NSString stringWithFormat:@"%lld小时",timeValue/60/60];
    }
    else if (timeValue<60*60*24*3)//3天之内
    {
        headDes = [NSString stringWithFormat:@"%lld天",timeValue/60/60/24];
    }
    else
    {
        return [self formatTimeInyyyyMMdd];
    }
    return [NSString stringWithFormat:@"%@之%@",headDes,tailDes];
}

@end

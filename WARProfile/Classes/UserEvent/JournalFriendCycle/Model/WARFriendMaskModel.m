//
//  WARFriendMaskModel.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/5/25.
//

#import "WARFriendMaskModel.h"

@implementation WARFriendMaskModel
//
//- (NSString *)getBirthdayString {
//    NSString *birthday = nil;
//    if (self.year && self.month && self.day) {
//        birthday =  [NSString stringWithFormat:@"%@-%@-%@",self.year,self.month,self.day];
//    }else {
//        birthday = nil;
//    }
//    return birthday;
//}
//
//- (NSString *)age {
//    if (self.year.length && self.month.length && self.day.length && [self.year intValue] > 0 && [self.month intValue] > 0 && [self.day intValue] > 0) {
//        
//        NSString *birthDate = [NSString stringWithFormat:@"%@-%@-%@",self.year,self.month,self.day];
//        
//        //首先把string类型的birth转为nsdate
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//        //出生日期
//        NSDate *birth = [dateFormatter dateFromString:birthDate];
//        //现在的日期
//        NSString *currenDateStr = [dateFormatter stringFromDate:[NSDate date]];
//        NSDate *today = [dateFormatter dateFromString:currenDateStr];
//        
//        //从出生到现在过去了多久
//        NSTimeInterval time = [today timeIntervalSinceDate:birth];
//        int age = ((long)time)/(3600*24*365);
//        
//        return [NSString stringWithFormat:@"%d",age];
//        
//    }else {
//        return nil;
//    }
//}

//
//- (NSString *)showAffectiveString{
//    if ([self.affectiveState isEqualToString:@"SECRECY"]) {
//        return @"保密";
//    }else if ([self.affectiveState isEqualToString:@"SINGLE"]){
//        return @"单身";
//    }else if ([self.affectiveState isEqualToString:@"IN_LOVE"]){
//        return @"恋爱中";
//    }else{
//        return @"已婚";
//    }
//}

@end

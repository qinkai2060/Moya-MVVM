//
//  MyUncaughtExceptionHandler.m
//  HeMeiHui
//
//  Created by 任为 on 2018/1/4.
//  Copyright © 2018年 hefa. All rights reserved.
//

#import "MyUncaughtExceptionHandler.h"

// 沙盒的地址
NSString * applicationDocumentsDirectory() {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}
// 崩溃时的回调函数
/*
 slc.setExceptionType(req.getParameter("expType"));// 异常类型：字符串app-crash
 slc.setExceptionLevel(req.getParameter("expLevel"));// 级别 默认crash是：3
 slc.setExceptionInfo(req.getParameter("expMsg"));// 异常内容
 slc.setExceptionTime(req.getParameter("expTime"));// 发生时间 yyyy-MM-dd HH:mm:ss
 slc.setExceptionUserId(req.getParameter("expUserId"));// 发生userId 本地存储userId
 */
void UncaughtExceptionHandler(NSException * exception) {
    NSArray * arr = [exception callStackSymbols];
    NSString * reason = [exception reason]; // // 崩溃的原因  可以有崩溃的原因(数组越界,字典nil,调用未知方法...) 崩溃的控制器以及方法
    NSString * name = [exception name];
    NSDictionary *userInfo = [exception userInfo];
    NSDictionary *dic = [VersionTools InfoDic];
    
    NSMutableDictionary *crashDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    if (reason) {
        [crashDic setObject:@"ios-crash" forKey:@"expType"];
    }
    if ([arr componentsJoinedByString:@"\n"].length) {
        
        NSString *str = [NSString stringWithFormat:@"%@\n%@",reason,[arr componentsJoinedByString:@"\n"]];
        [crashDic setObject:str forKey:@"expMsg"];
    }
    [crashDic setObject:@"3" forKey:@"expLevel"];

    NSString *uid = [[NSUserDefaults standardUserDefaults]objectForKey:@"uid"];

    if (uid) {
        [crashDic setObject:uid forKey:@"expUserId"];
    }
  
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        //现在时间,你可以输出来看下是什么格式
    NSDate *datenow = [NSDate date];
        //----------将nsdate按formatter格式转成nsstring
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    NSLog(@"currentTimeString =  %@",currentTimeString);
    [crashDic setObject:currentTimeString forKey:@"expTime"];
    NSString * path = [applicationDocumentsDirectory() stringByAppendingPathComponent:@"Exception.txt"];
    NSString * url = [NSString stringWithFormat:@"========异常错误报告========\n========设备信息========\n%@\n异常name:%@\nreason:\n%@\ncallStackSymbols:\n%@",dic,name,reason,[arr componentsJoinedByString:@"\n"]];
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:crashDic options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *crashInfoStr =  [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    // 将一个txt文件写入沙盒
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path]) {
        [crashInfoStr writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }else{
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:path];
        [fileHandle seekToEndOfFile];//将节点跳到文件的末尾
        NSData *data = [url dataUsingEncoding:NSUTF8StringEncoding];
        [fileHandle writeData:data];
    }
}

@implementation MyUncaughtExceptionHandler

// 沙盒地址
- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}
+ (void)setDefaultHandler {
    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
}

+ (NSUncaughtExceptionHandler *)getHandler {
    return NSGetUncaughtExceptionHandler();
}
- (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}
+ (void)TakeException:(NSException *)exception {
    NSArray * arr = [exception callStackSymbols];
    NSString * reason = [exception reason];
    NSString * name = [exception name];
    NSString * url = [NSString stringWithFormat:@"========异常错误报告========\nname:%@\nreason:\n%@\ncallStackSymbols:\n%@",name,reason,[arr componentsJoinedByString:@"\n"]];
    NSString * path = [applicationDocumentsDirectory() stringByAppendingPathComponent:@"Exception.txt"];
    [url writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
}
@end

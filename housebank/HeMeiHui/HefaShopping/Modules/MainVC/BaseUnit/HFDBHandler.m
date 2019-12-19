//
//  HFDBHandler.m
//  HeMeiHui
//
//  Created by usermac on 2019/3/28.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFDBHandler.h"
#import "HFDBManger.h"
@implementation HFDBHandler
+ (void)cacheData:(NSDictionary*)dict {
    if (dict == nil) {
        return;
    }

    [[HFDBManger sharedDBManager].queue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        NSString *homeID = [[dict valueForKey:@"result"] valueForKey:@"id"];
        NSString *jsonContent = [[dict valueForKey:@"result"] valueForKey:@"jsonContent"];
        if ( [db executeUpdate:@"INSERT OR REPLACE INTO T_Status (homeID,jsonContent) VALUES (?,?)",homeID,jsonContent]) {
            NSLog(@"存储成功");
        }else {
            NSLog(@"存储失败");
        }
    }];
}
+ (void)cacheLoginData:(NSDictionary*)dict {
    if (dict == nil) {
        return;
    }
    
    [[HFDBManger sharedDBManager].queue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        NSString *sid = [dict valueForKey:@"sid"];
        NSError *parseError = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&parseError];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        if ( [db executeUpdate:@"INSERT OR REPLACE INTO T_LoginInfo (sid,jsonContent) VALUES (1,?)",jsonString]) {
            NSLog(@"login存储成功");
        }else {
            NSLog(@"login存储失败");
        }
    }];
}
+ (NSDictionary*)selectData {
    NSString *sql = @"SELECT * FROM T_Status";
   __block NSDictionary *dict;
    [[HFDBManger sharedDBManager].queue inDatabase:^(FMDatabase * _Nonnull db) {
      FMResultSet *result = [db executeQuery:sql];
        while (result.next) {
        NSData *data =  [result dataForColumn:@"jsonContent"];
        NSDictionary * dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            dict = dataDic;
           
        }
        
    }];
    return dict;
}
+ (NSDictionary*)selectLoginData {
    NSString *sql = @"SELECT * FROM T_loginInfo";
    __block NSDictionary *dict;
    [[HFDBManger sharedDBManager].queue inDatabase:^(FMDatabase * _Nonnull db) {
        FMResultSet *result = [db executeQuery:sql];
        while (result.next) {
            NSData *data =  [result dataForColumn:@"jsonContent"];
            NSDictionary * dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            dict = dataDic;
            
            NSLog(@"");
        }
        
    }];
    return dict;
}
@end

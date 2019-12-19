//
//  HFDBManger.m
//  HeMeiHui
//
//  Created by usermac on 2019/3/22.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFDBManger.h"


@implementation HFDBManger
+ (HFDBManger *)sharedDBManager
{
    static HFDBManger *sharedDBManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        sharedDBManager = [[HFDBManger alloc] init];
        
    });
    
    return sharedDBManager;
}
- (instancetype)init {
    if (self = [super init]) {
           NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES).lastObject stringByAppendingFormat:@"my.db"];
        _queue = [FMDatabaseQueue  databaseQueueWithPath:path];
        [self creatTable];
        [self creatTableLogin];
    }
    return self;
}
- (void)creatTable {
    NSString *sql = @"CREATE TABLE IF NOT EXISTS T_Status (homeID INTEGER NOT NULL,jsonContent TEXT,PRIMARY KEY(homeID));";
    [_queue inDatabase:^(FMDatabase * _Nonnull db) {
        if ( [db executeStatements:sql]) {
            NSLog(@"数据表创建成功");
        }else {
            NSLog(@"数据表创建失败");
        }
    }];

}
- (void)creatTableLogin {
    NSString *sql = @"CREATE TABLE IF NOT EXISTS T_LoginInfo (sid INTEGER NOT NULL,jsonContent TEXT,PRIMARY KEY(sid));";
    [_queue inDatabase:^(FMDatabase * _Nonnull db) {
        if ( [db executeStatements:sql]) {
            NSLog(@"数据表登录创建成功");
        }else {
            NSLog(@"数据表登录创建失败");
        }
    }];
    
}
@end

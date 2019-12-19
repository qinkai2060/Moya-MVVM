//
//  ContractDataSave.h
//  HeMeiHui
//
//  Created by 莫荣 on 2018/7/24.
//  Copyright © 2018年 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContractDataSave : NSObject
+(NSString*)contractWriteToFilePlistPath;
+(NSString*)contractWriteToFilePath;
+(void)contractWriteToFileImage:(NSString*) imgUrl:(NSData*) data;
+(NSString*)contractWriteToFileImagePath:(NSString*) imgUrl;
//清除所有协议
+(void)cleanAllContract;
//获取所有协议
+(NSArray*)getAllContract;

@end

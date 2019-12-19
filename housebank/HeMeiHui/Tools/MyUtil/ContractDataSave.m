//
//  ContractDataSave.m
//  HeMeiHui
//
//  Created by 莫荣 on 2018/7/24.
//  Copyright © 2018年 hefa. All rights reserved.
//

#import "ContractDataSave.h"

@implementation ContractDataSave

+(NSString*)contractWriteToFilePath{
    //获取Document文件
    NSString * docsdir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString * rarFilePath = [docsdir stringByAppendingPathComponent:@"contract"];//将需要创建的串拼接到后面
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    // fileExistsAtPath 判断一个文件或目录是否有效，isDirectory判断是否一个目录
    BOOL existed = [fileManager fileExistsAtPath:rarFilePath isDirectory:&isDir];
    if ( !(isDir == YES && existed == YES) ) {//如果文件夹不存在
        [fileManager createDirectoryAtPath:rarFilePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return rarFilePath;
    
}
+(NSString*)contractWriteToFilePlistPath{
    
    
    NSString *plistPath = [[ContractDataSave contractWriteToFilePath] stringByAppendingPathComponent:@"contractpList.plist"];
    return plistPath;
}
+(void)contractWriteToFileImage:(NSString*) imgUrl :(NSData*) data{
    NSString *name = [[NSFileManager defaultManager] displayNameAtPath:imgUrl];
    [data writeToFile:[[ContractDataSave contractWriteToFilePath]stringByAppendingPathComponent:name] atomically:true];
}

+(NSString*)contractWriteToFileImagePath:(NSString*) imgUrl{
    NSString *name = [[NSFileManager defaultManager] displayNameAtPath:imgUrl];
    return [[ContractDataSave contractWriteToFilePath]stringByAppendingPathComponent:name];
}
+(void)cleanAllContract{
    NSString *contractPath = [ContractDataSave contractWriteToFilePath];
    NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtPath:contractPath];
    for (NSString *fileName in enumerator) {
        [[NSFileManager defaultManager] removeItemAtPath:[contractPath stringByAppendingPathComponent:fileName] error:nil];
    }
}

+(NSArray*)getAllContract{
    NSArray *allContract = [NSArray arrayWithContentsOfFile:[ContractDataSave contractWriteToFilePlistPath]];
    return allContract;
}




//BOOL sssss = [resultDict writeToFile:[ContractDataSave contractWriteToFilePlistPath] atomically:YES];
//
//NSDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:[ContractDataSave contractWriteToFilePlistPath]];
//
//
////                    [[BaseViewController contractWriteToFilePath]stringByAppendingPathComponent: resultDict["1"]]
//NSFileManager *fileManager = [NSFileManager defaultManager];
//BOOL isDir = NO;
//
////                    NSString *sdsf =  [resultDict objectForKey:@'1'] ;
////                    BOOL existed = [fileManager fileExistsAtPath:[[BaseViewController contractWriteToFilePath] stringByAppendingPathComponent:sdsf] isDirectory:&isDir];

@end

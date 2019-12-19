//
//  TopContactsModel.m
//  HeMeiHui
//
//  Created by 张磊 on 2019/4/29.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "TopContactsModel.h"

@implementation TopContactsModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"topContactsId":@"id"
      };
    //从 json 过来的key 可以是id，ID，book_id。例子中 key 为 id。
}
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
@end

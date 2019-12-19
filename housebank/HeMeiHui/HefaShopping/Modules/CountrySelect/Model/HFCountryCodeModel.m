//
//  HFCountryCodeModel.m
//  HeMeiHui
//
//  Created by usermac on 2019/4/29.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFCountryCodeModel.h"

@implementation HFCountryCodeModel
+ (NSArray*)jsonSerialization  {
    NSArray *obj = [HFCountryCodeModel readLocalFileWithName:@"countryCode"];
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSDictionary *dict in obj) {
        HFCountryCodeModel *model = [[HFCountryCodeModel alloc] init];
        
        NSMutableArray *dataTempArr = [NSMutableArray array];
        NSArray *dataTemp = [dict valueForKey:@"data"];
        if (dataTemp.count > 0) {
            for (NSDictionary *dataDict in [dict valueForKey:@"data"]) {
                HFCountryCodeModel *data = [[HFCountryCodeModel alloc] init];
                data.countryCode = [dataDict valueForKey:@"phoneCode"];
                data.countryName = [dataDict valueForKey:@"countryName"];
                [dataTempArr addObject:data];
            }
            if(dataTempArr.count > 0) {
                model.indexKey = [dict valueForKey:@"key"];
            }
        }
        model.dataArray = [dataTempArr copy];
        if (dataTemp.count > 0) {
           [tempArray addObject:model];
        }
        
    }
    
    return [tempArray copy];
}
+ (id)readLocalFileWithName:(NSString *)name {
    // 获取文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"json"];
    // 将文件数据化
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    // 对数据进行JSON格式化并返回字典形式
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}
@end

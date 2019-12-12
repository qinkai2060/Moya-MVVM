//
//  WARRequestCareGroupModel.m
//  WARProfile
//
//  Created by 秦恺 on 2018/3/16.
//

#import "WARRequestCareGroupModel.h"
#import "WARContactCategoryModel.h"
@implementation WARRequestCareGroupModel
+ (NSArray*)prase:(NSArray *)categoryArr{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (WARContactCategoryModel *model in categoryArr) {
        NSMutableDictionary *reqmodel = [[NSMutableDictionary alloc] init];
        [reqmodel setObject:model.categoryId forKey:@"categoryId"];
        [reqmodel setObject:model.categoryName forKey:@"name"];
        [reqmodel setObject:@"" forKey:@"maskId"];
        [reqmodel setObject:@"" forKey:@"operateType"];
        [array addObject:reqmodel];
    }
    return array.copy;
}
@end

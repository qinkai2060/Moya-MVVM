//
//  WARIronBody.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/12.
//

#import "WARIronBody.h"
#import "MJExtension.h"

@implementation WARIronBody

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"pageContents" : @"WARFeedPageModel"};//前边，是属性数组的名字，后边就是类名
}

- (void)mj_keyValuesDidFinishConvertingToObject {
    
    NSMutableArray <WARFeedPageModel *> *pageContents = [NSMutableArray array];
    [_pageContents enumerateObjectsUsingBlock:^(WARFeedPageModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.components) {
            [pageContents addObject:obj];
        }
    }];
    _pageContents = pageContents;
}
 
@end

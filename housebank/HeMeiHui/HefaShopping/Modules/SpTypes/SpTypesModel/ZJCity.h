//
//  ZJContact.h
//  ZJIndexContacts
//
//  Created by ZeroJ on 16/10/10.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ZJCity : NSObject
@property (copy, nonatomic) NSString *name;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *pinyin;
@property (nonatomic, strong) NSString *py;
@property (nonatomic, strong) NSString *sort;
@property (nonatomic, strong) NSString *lng;
@property (nonatomic, strong) NSString *lat;
@property (nonatomic, strong) NSString *hidden;

// 搜索联系人的方法 (拼音/拼音首字母缩写/汉字)
+ (NSArray *)searchText:(NSString *)searchText inDataArray:(NSArray *)dataArray;

+ (NSMutableArray *)createSuoYin:(NSArray<ZJCity *> *)dataArrary;

@end

//
//  ZJcity.m
//  ZJIndexcitys
//
//  Created by ZeroJ on 16/10/10.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

#import "ZJCity.h"
#import "PinYin4Objc.h"
#import "ChineseToPinyin.h"
#import "FindRegionsModel.h"

@implementation ZJCity

static BOOL isIncludeChineseInNSString(NSString *string) {
    for (int i=0; i<string.length; i++) {
        unichar ch = [string characterAtIndex:i];
        if (0x4e00 < ch  && ch < 0x9fff) {
            return true;
        }
    }
    return false;
}

+ (NSArray *)searchText:(NSString *)searchText inDataArray:(NSArray *)dataArray {
    NSMutableArray *results = [NSMutableArray array];
    
    if (searchText.length <= 0 || dataArray.count <= 0) return results;
    
    if (isIncludeChineseInNSString(searchText)) { // 输入了中文-只查询中文
        for (ZJCity *city in dataArray) {
            NSRange resultRange = [city.name rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (resultRange.length > 0) {// 找到了
                    FindRegionsModel *model = [[FindRegionsModel alloc] init];
                    model.id = city.id;
                    model.name = city.name;
                    model.lat = city.lat;
                    model.lng = city.lng;
                    model.pinyin = city.pinyin;
                    model.py = city.py;
                    model.hidden = city.hidden;
                

                [results addObject:model];
            }
        }

    } else {
        for (ZJCity *city in dataArray) {
            
            if (isIncludeChineseInNSString(city.name)) {// 待查询中有中文--转为拼音
                
                HanyuPinyinOutputFormat *outputFormat = [[HanyuPinyinOutputFormat alloc] init];
                [outputFormat setToneType:ToneTypeWithoutTone];
                [outputFormat setVCharType:VCharTypeWithV];
                [outputFormat setCaseType:CaseTypeLowercase];
                
                static NSString *const separatorString = @" ";
                // 有分隔符
                NSString *completeHasSeparatorPinyin = [PinyinHelper toHanyuPinyinStringWithNSString:city.name withHanyuPinyinOutputFormat:outputFormat withNSString:separatorString];
                // 删除分隔符
                NSString *completeNOSeparatorPinyin = [completeHasSeparatorPinyin stringByReplacingOccurrencesOfString:separatorString withString:@""];
                // 处理多音字 -- 这里只处理了 '重庆'
                if ([city.name hasPrefix:@"重"] && [completeNOSeparatorPinyin hasPrefix:@"z"]) {
                    completeNOSeparatorPinyin = [completeNOSeparatorPinyin stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@"c"];
                }
                // 查询没有分隔符中是否包含 (不能使用有分隔符的拼音来查询, 因为输入的里面可能不会包含分隔符, 导致查询不到)
                NSRange resultRange = [completeNOSeparatorPinyin rangeOfString:searchText options:NSCaseInsensitiveSearch];
                if (resultRange.length > 0) {// 找到了
                    [results addObject:city];
                    continue; // 进入下一次循环, 不再执行下面这段代码
                }
                NSMutableString *headOfPinyin = [NSMutableString string];
                NSArray *pinyinArray = [completeHasSeparatorPinyin componentsSeparatedByString:separatorString];
                for (NSString *singlePinyin in pinyinArray) {
                    if (singlePinyin) { // 取每个拼音的首字母
                        [headOfPinyin appendString:[singlePinyin substringToIndex:1]];
                    }
                }
                
                NSRange headResultRange = [headOfPinyin rangeOfString:searchText options:NSCaseInsensitiveSearch];
                if (headResultRange.length > 0) {// 找到了
                    FindRegionsModel *model = [[FindRegionsModel alloc] init];
                    model.id = city.id;
                    model.name = city.name;
                    model.lat = city.lat;
                    model.lng = city.lng;
                    model.pinyin = city.pinyin;
                    model.py = city.py;
                    model.hidden = city.hidden;
                    

                    [results addObject:model];
                }

            }
        }
 
    }
    return results;
}


+ (NSMutableArray *)createSuoYin:(NSArray<ZJCity *> *)dataArrary{
    //建立索引
    UILocalizedIndexedCollation *indexCollection = [UILocalizedIndexedCollation currentCollation];
    
    NSMutableArray *sectionTitles = [NSMutableArray arrayWithCapacity:1];
    if (sectionTitles.count > 0) {
        [sectionTitles removeAllObjects];
    }
    
    [sectionTitles addObjectsFromArray:[indexCollection sectionTitles]];
    
    //返回27，是a－z和＃
    NSInteger highSection = [sectionTitles count];
    
    //tableView 会被分成27个section
    NSMutableArray *sortedArray = [NSMutableArray arrayWithCapacity:highSection];
    for (int i = 0; i < highSection; i++){
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
        [sortedArray addObject:sectionArray];
    }
    for (int i=0;i<dataArrary.count;i++){
        NSString *cUser = dataArrary[i].name;
        //getUserName是实现中文拼音检索的核心，见NameIndex类
        
        if (cUser) {
            NSString *firstLetter = [ChineseToPinyin pinyinFromChineseString:cUser];
            if (firstLetter.length>0) {
                NSInteger section = [indexCollection sectionForObject:[firstLetter substringToIndex:1] collationStringSelector:@selector(uppercaseString)];
                NSMutableArray *array = [sortedArray objectAtIndex:section];
                [array addObject:cUser];
            } else {
                if (sortedArray.count>0) {
                    NSMutableArray *array = [sortedArray lastObject];
                    [array addObject:cUser];
                }
            }
        }
    }
    
    NSMutableArray *soArr = [NSMutableArray arrayWithCapacity:1];
    for (int i = 0; i < sectionTitles.count; i++) {
        NSString *secStr = sectionTitles[i];
        if (sortedArray.count >= i) {
            NSArray *arr = sortedArray[i];
            
            NSDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:1];
            [dic setValue:secStr forKey:@"title"];
            [dic setValue:arr forKey:@"cities"];
            [soArr addObject:dic];
            
//            NSMutableArray *hotArr = [NSMutableArray arrayWithCapacity:1];
//            for (NSDictionary *cityDic in hotCityArr) {
//                FindRegionsModel *model = [[FindRegionsModel alloc] init];
//                [model setValuesForKeysWithDictionary:cityDic];
//                [hotArr addObject:model];
//            }
        }
    }
    return soArr;
    
}


@end

//
//  HFSectionModel.m
//  HeMeiHui
//
//  Created by usermac on 2019/3/14.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFSectionModel.h"
#import "HFHomeBaseModel.h"
#import "HFVIPModel.h"
#import "HFPopupModel.h"
@implementation HFSectionModel
+ (NSArray*)jsonSerialize:(NSArray*)dataArray isVip:(BOOL)isVip {

    NSMutableArray *arrayTemp = [[NSMutableArray alloc] init];
    //  NSArray *array = [[HFSectionModel readLocalFileWithName:@"home"] valueForKey:@"homeDataBean"];
    NSArray *array = dataArray;
    
    for (NSDictionary *sectionDict in array) {
        HFSectionModel *sectionModel = [[HFSectionModel alloc] init];
        sectionModel.isVip = isVip;
        sectionModel.moduleTitle = [HFUntilTool EmptyCheckobjnil:[ [sectionDict valueForKey:@"moduleTitle"] description]];
        if ([HFSectionModel  modules:[HFUntilTool EmptyCheckobjnil:[sectionDict valueForKey:@"name"]] type:[[HFUntilTool EmptyCheckobjnil:[sectionDict valueForKey:@"type"]] integerValue]]== 4) {
            
        }
        if ([[HFUntilTool EmptyCheckobjnil:[sectionDict valueForKey:@"isModuleShow"]] isEqualToString:@"true"]) {
            sectionModel.isModuleShow = YES;
        }else {
            sectionModel.isModuleShow = NO;
        }
        if ([[HFUntilTool EmptyCheckobjnil:[sectionDict valueForKey:@"isModuleTitleShow"]] isEqualToString:@"true"]) {
            sectionModel.isModuleTitleShow = YES;
        }else {
            sectionModel.isModuleTitleShow = NO;
        }
        if (![sectionDict.allKeys containsObject:@"isModuleTitleShow"]) {
            sectionModel.isModuleTitleShow = NO;
        }
//        if (![sectionDict.allKeys containsObject:@"isModuleShow"]) {
//            sectionModel.isModuleShow = YES;
//        }
        sectionModel.contentMode = [HFSectionModel  modules:[HFUntilTool EmptyCheckobjnil:[sectionDict valueForKey:@"name"]] type:[[HFUntilTool EmptyCheckobjnil:[sectionDict valueForKey:@"type"]] integerValue]];
        HFHomeBaseModel *baseModel = NULL;
        Class renderClass=[HFHomeBaseModel getRenderClassByMessageType:[HFSectionModel  modules:[HFUntilTool EmptyCheckobjnil:[sectionDict valueForKey:@"name"]] type:[[HFUntilTool EmptyCheckobjnil:[sectionDict valueForKey:@"type"]] integerValue]]];
        baseModel=[[renderClass alloc]init];
        baseModel.isVipP = isVip;
        if (baseModel){
            sectionModel.dataModelSource = @[baseModel];
            [baseModel getData:sectionDict];
            NSString *onoff = [[NSUserDefaults standardUserDefaults] objectForKey:nativeSwitch];
            if (([onoff isEqualToString:@"0"]&&sectionModel.contentMode == HFSectionModelModuleFourType)) {
                
            }else {
                if (sectionModel.isModuleShow){
                    [arrayTemp addObject:sectionModel];
                }
            }
            
        }

    }
    return  [arrayTemp copy];
}
+ (HFSegementModel*)segementMode:(NSArray*)array {
    
    NSPredicate *regex = [NSPredicate predicateWithFormat:@"contentMode == 14 "];
    if ([array filteredArrayUsingPredicate:regex].count >0) {
        return  (HFSegementModel*)[[array filteredArrayUsingPredicate:regex] firstObject];
    }
    return nil;
}
+ (HFPopupModel*)popupModel:(NSArray*)array {
    
    NSPredicate *regex = [NSPredicate predicateWithFormat:@"contentMode == 17 "];
    if ([array filteredArrayUsingPredicate:regex].count >0) {
        return  (HFPopupModel*)[[array filteredArrayUsingPredicate:regex] firstObject];
    }
    return nil;
}
+ (CGFloat)headerVIPHeight:(NSArray*)array {
    CGFloat he = 0;
    CGFloat sectionH = 0;
    for (HFSectionModel *model in array) {
        if (model.isModuleShow) {
            HFHomeBaseModel *baseMode = [model.dataModelSource firstObject];
            if (baseMode.contenMode == HHFHomeBaseModeBrowserBannerType) {
                baseMode.rowheight = 150;
            }
            he += baseMode.rowheight;
        }
        if (model.isModuleTitleShow) {
            sectionH +=45;
        }
    }
    return he+sectionH;
}
/**
 name :{
 @"modules_top_banner"// 轮播图
 @"modules_king_kong_area" // 入口
 @"modules_news"    //新闻
 @"modules_seckill" // 限时秒杀
 @"modules_middle_banner" // 广告位
 @"name" : @"modules_1" // 模块1 特价
 @"name" : @"modules_2" // 模块2 时尚单品
 @"name" : @"modules_3" // 模块3 zuber
 @"name" : @"modules_4" // 模块4
 @"name" : @"modules_5" // 模块5
 @"name" : @"modules_6" // 模块5
 }
 */
+ (NSInteger)modules:(NSString *)name type:(NSInteger)type{
    if ([name isEqualToString:@"modules_top_banner"]) {
        return 1;
    }
    if ([name isEqualToString:@"modules_king_kong_area"]) {
        return 2;
    }
    if ([name isEqualToString:@"modules_news"]) {
        return 3;
    }
    if ([name isEqualToString:@"modules_seckill"]) {
        return 4;
    }
    if ([name isEqualToString:@"modules_middle_banner"]) {
        return 5;
    }
    if ([name isEqualToString:@"modules_1"]) {
        return 6;
    }
    if ([name isEqualToString:@"modules_2"]||[name isEqualToString:@"modules_puzzle"]) {
        return 7;
    }
    if ([name isEqualToString:@"modules_3"]) {
        return 8;
    }
    if ([name isEqualToString:@"modules_4"]) {
        return 9;
    }
    if ([name isEqualToString:@"modules_5"] && (type == 4 ||type ==1)) {
        return 10;
    }
    if ([name isEqualToString:@"modules_5"] && type == 5) {
        return 11;
    }
    if ([name isEqualToString:@"modules_5"] && type == 6) {
        return 12;
    }
    if ([name isEqualToString:@"modules_6"]) {
        return 13;
    }
    if ([name isEqualToString:@"modules_classify"]) {
        return 14;
    }
    if ([name isEqualToString:@"modules_video"]) {
        return 15;
    }
    if ([name isEqualToString:@"modules_hotkey"]) {
        return 16;
    }
    if ([name isEqualToString:@"modules_popup_banner"]) {
        return 17;
    }
    return 0;
}
+ (NSDictionary *)readLocalFileWithName:(NSString *)name {
    // 获取文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"json"];
    // 将文件数据化
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    // 对数据进行JSON格式化并返回字典形式
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}
@end
@implementation HFSectionHeaderRect
@end

//
//  VideoTagsModel.h
//  HeMeiHui
//
//  Created by Qianhong Li on 2018/5/17.
//  Copyright © 2018年 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMHVideoTagsModel : NSObject
// 自增Id
@property (nonatomic, strong) NSNumber * id;
//
@property (nonatomic, strong) NSString * searchWord;
//
@property (nonatomic, strong) NSString * searchCount;
//
@property (nonatomic, strong) NSNumber * sort;


// ===================================
//
@property (nonatomic, strong) NSString * sid;
//标签名
@property (nonatomic, strong) NSString * tagName;
//标签图片
@property (nonatomic, strong) NSString * tagIcon;
//排序
@property (nonatomic, strong) NSNumber * tagSort;
//是否热门
@property (nonatomic, strong) NSNumber * isHot;
//插入时间
@property (nonatomic, strong) NSString * insertTime;
//插入者
@property (nonatomic, strong) NSString * insertUser;
//更新时间
@property (nonatomic, strong) NSString * updateTime;
//更新者
@property (nonatomic, strong) NSString * updateUser;

@end

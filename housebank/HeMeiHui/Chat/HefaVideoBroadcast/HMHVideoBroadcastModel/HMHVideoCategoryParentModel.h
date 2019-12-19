//
//  VideoCategoryParentModel.h
//  HeMeiHui
//
//  Created by Qianhong Li on 2018/5/19.
//  Copyright © 2018年 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMHVideoCategoryParentModel : NSObject

@property (nonatomic, strong) NSNumber * id;
//类别名称
@property (nonatomic, strong) NSString * name;
//父Id
@property (nonatomic, strong) NSNumber * pid;
//排序
@property (nonatomic, strong) NSNumber * sort;
@property (nonatomic, strong) NSNumber * topType;
@property (nonatomic, strong) NSMutableArray * children;
@property (nonatomic, strong) NSString * insertTime;
@property (nonatomic, strong) NSString * insertUser;
@property (nonatomic, strong) NSString * updateTime;
@property (nonatomic, strong) NSString * updateUser;

@property (nonatomic, assign) NSInteger indexSection;
@end

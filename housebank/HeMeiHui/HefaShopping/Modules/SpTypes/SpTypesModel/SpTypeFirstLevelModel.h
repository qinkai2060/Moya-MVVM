//
//  SpTypeFirstLevelModel.h
//  housebank
//
//  Created by liqianhong on 2018/10/30.
//  Copyright © 2018 hefa. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN
// 分类 一级二级model
@interface SpTypeFirstLevelModel : NSObject

@property (nonatomic, strong) NSString *levelId;
@property (nonatomic, strong) NSString *classifyGrade;
@property (nonatomic, strong) NSString *classifyName;
@property (nonatomic, strong) NSString *parentId;
@property (nonatomic, strong) NSString *navSort;
@property (nonatomic, strong) NSString *tags;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *remark;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *createUser;
@property (nonatomic, strong) NSString *updateUser;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *updateTime;
@property (nonatomic, strong) NSString *subClassifyNum;
@property (nonatomic, strong) NSString *parentClassifyName;
@property (nonatomic, strong) NSString *productCount;
@property (nonatomic, strong) NSString *attributesCount;
@property (nonatomic, strong) NSArray *list;
@property (nonatomic, strong) NSString *shopsId;

@property (nonatomic, assign) BOOL isSelected;
@end

NS_ASSUME_NONNULL_END

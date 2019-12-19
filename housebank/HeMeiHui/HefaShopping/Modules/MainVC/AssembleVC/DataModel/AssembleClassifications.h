//
//  AssembleClassifications.h
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/4/2.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import "SetBaseModel.h"
@protocol ClassificationsItem//不带*号

@end
NS_ASSUME_NONNULL_BEGIN
@interface ClassificationsItem :NSObject
@property (nonatomic , assign) NSInteger              ID;
@property (nonatomic , copy) NSString              * name;

@end


@interface Classifications :NSObject
@property (nonatomic , strong) NSArray <ClassificationsItem>              * classifications;

@end


@interface AssembleClassifications :SetBaseModel
@property (nonatomic , strong) Classifications              * data;

@end


NS_ASSUME_NONNULL_END

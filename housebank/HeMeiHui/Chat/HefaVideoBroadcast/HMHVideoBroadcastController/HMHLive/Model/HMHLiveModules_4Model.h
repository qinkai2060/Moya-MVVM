//
//  HMHLiveModules_4Model.h
//  HeMeiHui
//
//  Created by 张磊 on 2019/5/27.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMHLiveModules_4ItemsModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HMHLiveModules_4Model : NSObject
@property (nonatomic, assign) BOOL isModuleShow;
@property (nonatomic, strong) NSArray <HMHLiveModules_4ItemsModel *> *items;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *moduleTitle;
@property (nonatomic, strong) NSNumber *isModuleTitleShow;

@end

NS_ASSUME_NONNULL_END

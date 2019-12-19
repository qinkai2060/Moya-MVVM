//
//  HMHLiveModules_newsModel.h
//  HeMeiHui
//
//  Created by 张磊 on 2019/5/27.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMHLivieNewsItemsModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HMHLiveModules_newsModel : NSObject
@property (nonatomic,assign) BOOL isModuleShow;
@property (nonatomic,strong) NSArray <HMHLivieNewsItemsModel *> *items;
@end

NS_ASSUME_NONNULL_END

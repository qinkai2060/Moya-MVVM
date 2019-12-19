//
//  SpTypesSearchListViewController.h
//  housebank
//
//  Created by liqianhong on 2018/10/26.
//  Copyright © 2018 hefa. All rights reserved.
//

#import "SpBaseViewController.h"
#import "HMHBasePrimaryViewController.h"
// 搜索结果列表vc
NS_ASSUME_NONNULL_BEGIN
typedef enum:NSUInteger {
    SpTypesSearchListViewControllerTypeNone,
    SpTypesSearchListViewControllerTypeVip
}SpTypesSearchListViewControllerType;
typedef void(^textFiledText)(NSString *str);
@interface SpTypesSearchListViewController : SpBaseViewController

@property (nonatomic, strong) NSString *classId;
// 表示等级 1 2 3
@property (nonatomic, strong) NSString *level;
// 搜索文字
@property (nonatomic, strong) NSString *searchStr;

@property (nonatomic, copy) textFiledText textFiledTextBlock;

@property (nonatomic, assign) BOOL isFristIn;

@property (nonatomic, assign) SpTypesSearchListViewControllerType type;
@end

NS_ASSUME_NONNULL_END

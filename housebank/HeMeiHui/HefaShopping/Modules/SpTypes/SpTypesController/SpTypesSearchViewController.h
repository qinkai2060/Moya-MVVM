//
//  SpTypesSearchViewController.h
//  housebank
//
//  Created by liqianhong on 2018/10/26.
//  Copyright © 2018 hefa. All rights reserved.
//

#import "SpBaseViewController.h"
// 搜索vc
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger , SearchTypes) {
    
    //普通搜索
    OrdinarySearchType= 0,
    //全球家首页搜索
    GlobalHomeSearchType,
    
    
};

@protocol TypesSearchViewControllerDelegate <NSObject>

/**
 tableViewCell 的点击事件 indexRow为所属的row  searchText 历史搜索列表的内容
 */
- (void)BringBackSearchText:(NSString *)searchText;

@end
@interface SpTypesSearchViewController : SpBaseViewController
@property (nonatomic, weak) id<TypesSearchViewControllerDelegate> delegate;
//增加类型
@property (nonatomic ,assign) SearchTypes searchTypes;
@property (nonatomic ,copy) NSString *txt;

- (void)setTx:(NSString *)text;
@end

NS_ASSUME_NONNULL_END





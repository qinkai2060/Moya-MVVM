//
//  SpTypesSearchNoContentMainView.h
//  housebank
//
//  Created by liqianhong on 2018/10/30.
//  Copyright © 2018 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpTypesSearchView.h"
#import "SpTypesSearchTopView.h"
#import "AssembleSearchView.h"

// 搜索列表 无内容
NS_ASSUME_NONNULL_BEGIN

@interface SpTypesSearchNoContentMainView : UIView

@property (nonatomic, strong) AssembleSearchView *assembleSearchView;
@property (nonatomic, strong) SpTypesSearchView *searchView;
@property (nonatomic, strong) SpTypesSearchTopView *topView;

@end

NS_ASSUME_NONNULL_END

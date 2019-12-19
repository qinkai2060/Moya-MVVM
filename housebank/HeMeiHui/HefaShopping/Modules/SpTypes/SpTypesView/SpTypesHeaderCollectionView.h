//
//  CategoryHeaderCollectionView.h
//  housebank
//
//  Created by liqianhong on 2018/10/25.
//  Copyright © 2018 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpTypeFirstLevelModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol HeaderCollectionViewDelegate <NSObject>

/**
 更多按钮的点击事件
 */
//- (void)headerViewMoreBtnClick:(UIButton *)btn;

@end

@interface SpTypesHeaderCollectionView : UICollectionReusableView

@property (nonatomic, strong) UIButton *moreBtn;

//@property (nonatomic, weak) id<HeaderCollectionViewDelegate> delegate;

- (void)refreshHeaderViewWithModel:(SpTypeFirstLevelModel *)model;

@end

NS_ASSUME_NONNULL_END

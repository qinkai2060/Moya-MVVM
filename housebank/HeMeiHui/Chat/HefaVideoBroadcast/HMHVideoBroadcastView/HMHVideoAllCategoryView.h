//
//  HMHVideoAllCategoryView.h
//  mainVideo
//
//  Created by Qianhong Li on 2018/4/18.
//  Copyright © 2018年 Qianhong Li. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^allCategoryBlock)(NSInteger selectTag);

@interface HMHVideoAllCategoryView : UIView

@property (nonatomic, strong) allCategoryBlock allcategoryBlock;

- (instancetype)initWithFrame:(CGRect)frame withDataSource:(NSMutableArray *)dataSource;

+(CGFloat)getCategoryViewHeightWithArr:(NSMutableArray *)arr;

@end

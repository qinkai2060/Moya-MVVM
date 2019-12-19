//
//  hefaCategoryView.h
//  mainVideo
//
//  Created by Qianhong Li on 2018/4/18.
//  Copyright © 2018年 Qianhong Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMHVideoCategoryChildrenModel.h"
#import "HMHVideoCategoryParentModel.h"

typedef void(^hefaCategoryBlock)(NSInteger selectTag);
// 第一个按钮的点击事件
typedef void(^parentBtnClickBlock)(NSString *parent);

@interface HMHVideoCategoryView : UIView

@property (nonatomic, strong) hefaCategoryBlock categoryBlock;
@property (nonatomic, strong) parentBtnClickBlock parentBlock;

- (instancetype)initWithFrame:(CGRect)frame withSection:(NSInteger)indexPathSection parentModel:(HMHVideoCategoryParentModel *)pModel;

@end

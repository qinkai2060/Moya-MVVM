//
//  CustomCategoryView.h
//  HeMeiHui
//
//  Created by 张磊 on 2019/6/6.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CustomCategoryViewDelegate <NSObject>

- (void)didSelectCustomCategoryViewDelegateTilte:(NSString *)title index:(NSInteger)index;

@end
@interface CustomCategoryView : UIView
@property (nonatomic ,strong) UIScrollView *headScrollView;  //  顶部滚动视图

@property (nonatomic ,strong) NSArray *headArray;

@property (nonatomic, weak) id<CustomCategoryViewDelegate>delegate;
@end

NS_ASSUME_NONNULL_END

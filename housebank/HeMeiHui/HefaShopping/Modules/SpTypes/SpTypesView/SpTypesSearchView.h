//
//  CategorySearchView.h
//  housebank
//
//  Created by liqianhong on 2018/10/25.
//  Copyright © 2018 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpeakTextField.h"
NS_ASSUME_NONNULL_BEGIN

@protocol CateorySearchViewDelegate <NSObject>

/**
 返回按钮的点击事件
 */
- (void)backBtnClick;

/**
 搜索按钮的点击事件 此处是跳转
 */
- (void)searchBtnClick;

/**
  左右侧按钮的点击事件
 */
//- (void)searchRightBtnClick:(UIButton *)btn;

@end

@interface SpTypesSearchView : UIView

@property (nonatomic, strong) UIButton *backButton;

@property (nonatomic, strong) UIButton *searchBtn;

@property (nonatomic, strong) SpeakTextField *searchTextField;

@property(nonatomic,copy)void(^searchRightBtnClickBlock)(UIButton *btn);/*回调*/

@property (nonatomic, weak) id<CateorySearchViewDelegate> delegate;
/**
  isAddOneBtn 右侧是否有按钮
  searchKeyStr 搜索内容
  canEdit textField是否能编辑
  isHaveBack 是否有返回按钮
  isHaveBottomLine 底部是否有分割线
 */
- (instancetype)initWithFrame:(CGRect)frame isAddOneBtn:(BOOL)addOneBtn addBtnImageName:(NSString *)imageName addBtnTitle:(NSString *)addBtnTitle searchKeyStr:(NSString *)searchKeyStr canEidt:(BOOL)canEdit placeholderStr:(NSString *)placeholderStr isHaveBack:(BOOL)isHaveBack isHaveBottomLine:(BOOL)isHaveBottomLine;

@end

NS_ASSUME_NONNULL_END


//
//  SpTypesSearchFooterView.h
//  housebank
//
//  Created by liqianhong on 2018/10/26.
//  Copyright © 2018 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol searchFooterViewDelegate <NSObject>

/**
    清空历史记录
 */
- (void)deleteSearchFooterViewWithBtn:(UIButton *)btn;

@end

@interface SpTypesSearchFooterView : UIView

@property (nonatomic, weak) id<searchFooterViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END

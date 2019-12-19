//
//  DetailedRulesGroupBuyingCell.h
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/4/1.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DetailedRulesGroupBuyingCell : UICollectionViewCell
/* 标题 */
@property (strong , nonatomic)UILabel *featureTitleLabel;
/* 详细规则 */
@property (strong , nonatomic)UILabel *detailRulesLabel;
/* 指示按钮 */
@property (strong , nonatomic)UIButton *indicateButton;

@property (nonatomic , assign) NSInteger              activeType;// * 拼团类型，1：按拉新成团，2：按购买成团
- (void)reSetSelectedData:(NSString *)context;
@end

NS_ASSUME_NONNULL_END

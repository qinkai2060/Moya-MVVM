//
//  SpFeatureItemCell.h
//  housebank
//
//  Created by zhuchaoji on 2018/11/18.
//  Copyright © 2018年 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SpFeatureItemCell : UICollectionViewCell
/* 标题 */
@property (strong , nonatomic)UILabel *featureTitleLabel;
/* 名称 */
@property (strong , nonatomic)UILabel *featureLabel;
/* 指示按钮 */
@property (strong , nonatomic)UIButton *indicateButton;
//  分割线
@property (strong , nonatomic) UILabel *spaceLabe;

- (void)reSetSelectedData:(NSString *)context;
@end

NS_ASSUME_NONNULL_END

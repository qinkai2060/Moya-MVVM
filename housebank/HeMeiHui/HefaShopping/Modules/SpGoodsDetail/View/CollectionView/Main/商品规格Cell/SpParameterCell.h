//
//  SpParameterCell.h
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/1/14.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SpParameterCell : UICollectionViewCell
/* 标题 */
@property (strong , nonatomic)UILabel *featureTitleLabel;
/* 名称 */
@property (strong , nonatomic)UILabel *featureLabel;
/* 指示按钮 */
@property (strong , nonatomic)UIButton *indicateButton;
@end

NS_ASSUME_NONNULL_END

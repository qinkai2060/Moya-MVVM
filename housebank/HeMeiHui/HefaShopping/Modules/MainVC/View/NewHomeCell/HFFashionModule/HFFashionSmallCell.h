//
//  HFFashionSmallCell.h
//  HeMeiHui
//
//  Created by usermac on 2019/3/27.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFFashionModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HFFashionSmallCell : UICollectionViewCell
@property(nonatomic,strong)UILabel *titleLb;
@property(nonatomic,strong)UILabel *miaoshLb;
@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)UIView *rightView;
@property(nonatomic,strong)UIView *bottomView;
@property(nonatomic,strong)UIView *topView;
@property(nonatomic,strong)HFFashionModel *fashionModel;
- (void)doMessageRendering;
@end

NS_ASSUME_NONNULL_END

//
//  VipHeaderView.h
//  HeMeiHui
//
//  Created by 张磊 on 2019/7/15.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^EscalateBtnActionBlock)(NSString *title);

@interface VipHeaderView : UIView
@property (nonatomic, strong) UIImageView *bgView;
@property (nonatomic, strong) UIImageView *headerImg;
@property (nonatomic, strong) UILabel *vipLevelL;
@property (nonatomic, strong) UIButton *escalateBtn;
@property (nonatomic, copy) NSString *imagePath;//头像
@property (nonatomic, strong) NSNumber *vipLevel;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *arrDate;
@property (nonatomic, copy) EscalateBtnActionBlock escalateBlock;
@property (nonatomic, strong) UILabel *vipPrompt;

- (void)refreshVipLevel;
@end

NS_ASSUME_NONNULL_END

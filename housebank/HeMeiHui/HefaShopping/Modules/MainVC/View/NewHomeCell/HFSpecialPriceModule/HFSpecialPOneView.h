//
//  HFSpecialPOneView.h
//  HeMeiHui
//
//  Created by usermac on 2019/3/27.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFView.h"
#import "HFSpecialPriceOneModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HFSpecialPOneView : HFView
@property(nonatomic,strong)HFSpecialPriceOneModel *specialModel;
@property(nonatomic,strong)UILabel *titleLb;
@property(nonatomic,strong)UILabel *miaoshLb;
@property(nonatomic,strong)UILabel *tagLb;
@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)CALayer *linelayer;
@property(nonatomic,strong)CALayer *linelayer1;
@property(nonatomic,strong)CALayer *linelayer2;
- (void)doMessageRendering;
@end

NS_ASSUME_NONNULL_END

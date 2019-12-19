//
//  HFModuleSixView.h
//  HeMeiHui
//
//  Created by usermac on 2019/3/27.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFView.h"
#import "HFModuleSixModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HFModuleSixView : HFView
@property(nonatomic,strong)HFModuleSixModel *sixModel;
@property(nonatomic,strong)UILabel *titleLb;
@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)UIView *bgview;
- (void)doMessageRendering;
@end

NS_ASSUME_NONNULL_END

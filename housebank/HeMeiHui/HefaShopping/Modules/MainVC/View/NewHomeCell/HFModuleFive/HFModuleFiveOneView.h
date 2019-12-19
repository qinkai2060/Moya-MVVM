//
//  HFModuleFiveOneView.h
//  HeMeiHui
//
//  Created by usermac on 2019/3/27.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFView.h"
#import "HFMoudleFiveModel.h"
#import "HFMoudleFiveTwoModel.h"
#import "HFModuleFiveThreeModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^didModuleFiveOneBlock)(HFMoudleFiveModel*) ;
@interface HFModuleFiveOneView : HFView
@property(nonatomic,copy)didModuleFiveOneBlock didModuleFiveBlock;
@property(nonatomic,strong)HFMoudleFiveModel *fiveModel;
@property(nonatomic,strong)UILabel *titleLb;
@property(nonatomic,strong)UILabel *miaoshLb;
@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)UIImageView *imageViewTwo;
- (void)doMessageRendering;
@end

NS_ASSUME_NONNULL_END

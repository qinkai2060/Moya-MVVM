//
//  HFModuleFiveTwoView.h
//  
//
//  Created by usermac on 2019/3/27.
//

#import "HFView.h"
#import "HFMoudleFiveModel.h"
NS_ASSUME_NONNULL_BEGIN
@class HFMoudleFiveModel;
typedef void(^didModuleFiveTwoBlock)(HFMoudleFiveModel*) ;
@interface HFModuleFiveTwoView : HFView
@property(nonatomic,copy)didModuleFiveTwoBlock didModuleFiveTwoBlock;
@property(nonatomic,strong)HFMoudleFiveModel *fiveModel;
@property(nonatomic,strong)UILabel *titleLb;
@property(nonatomic,strong)UILabel *miaoshLb;
@property(nonatomic,strong)UIImageView *imageView;
- (void)doMessageRendering;
@end

NS_ASSUME_NONNULL_END

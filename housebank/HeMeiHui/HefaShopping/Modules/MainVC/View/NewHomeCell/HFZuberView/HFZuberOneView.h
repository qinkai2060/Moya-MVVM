//
//  HFZuberOneView.h
//  HeMeiHui
//
//  Created by usermac on 2019/3/27.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFView.h"
#import "HFModuleFourModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HFZuberOneView : HFView
@property(nonatomic,strong)HFModuleFourModel *fourModuleModel;
@property(nonatomic,strong)UIImageView *imageView;
- (void)doMessageRendering;
@end

NS_ASSUME_NONNULL_END

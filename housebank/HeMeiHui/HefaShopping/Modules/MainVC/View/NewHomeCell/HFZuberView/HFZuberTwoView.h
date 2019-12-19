//
//  HFZuberTwoView.h
//  HeMeiHui
//
//  Created by usermac on 2019/3/27.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFView.h"
#import "HFZuberModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HFZuberTwoView : HFView
@property(nonatomic,strong)HFZuberModel *zuberModel;
@property(nonatomic,strong)UIImageView *imageView;
- (void)doMessageRendering;
@end

NS_ASSUME_NONNULL_END

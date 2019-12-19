//
//  HFGlobalInterFaceLittleCell.h
//  HeMeiHui
//
//  Created by usermac on 2019/3/13.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFGlobalInterfaceModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HFGlobalInterFaceLittleCell : UICollectionViewCell
@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)UILabel *titleLb;
@property(nonatomic,strong)HFGlobalInterfaceModel *model;
- (void)doMessageRendering;
@end

NS_ASSUME_NONNULL_END

//
//  MyDeleteAccountCell.h
//  HeMeiHui
//
//  Created by usermac on 2019/8/28.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyDeletAcountModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface MyDeleteAccountCell : UITableViewCell
@property(nonatomic,strong)MyDeletAcountModel *model;
+ (void)registerRenderCell:(Class)cellClass messageType:(NSInteger)mtype;
- (void)doMessageRendering;
+ (Class)getRenderClassByMessageType:(NSInteger)msgType;
- (void)hh_setupSubviews;
@end

NS_ASSUME_NONNULL_END

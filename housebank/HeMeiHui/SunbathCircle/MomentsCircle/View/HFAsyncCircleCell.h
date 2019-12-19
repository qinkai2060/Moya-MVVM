//
//  HFAsyncCircleCell.h
//  HeMeiHui
//
//  Created by usermac on 2019/12/9.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HFAsyncCircleCell : UITableViewCell
+ (void)registerRenderCell:(Class)cellClass messageType:(NSInteger)mtype;
- (void)doMessageRendering;
+ (Class)getRenderClassByMessageType:(NSInteger)msgType;
- (void)hh_setupSubviews;
@end

NS_ASSUME_NONNULL_END
